//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit


class HomePage : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WebFetcherDelegate, ImageDownloaderDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var header: HomePageHeader! { didSet { header.homePage = self } }
    
    @IBOutlet weak var searchResults: HomePageSearchResults! {
        didSet {
            searchResults.homePage = self
            searchResults.isHidden = true
        }
    }
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainContainer: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            layoutLandscape = Device.isLandscape
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var updateTimer:Timer?
    
    
    var searchMode:Bool = false {
        didSet {
            if searchMode {
                searchResults.reset()
                animateSearchModeOn()
                header.animateSearchModeOn()
            } else {
                animateSearchModeOff()
                header.animateSearchModeOff()
            }
        }
    }
    
    
    //Before the orientation actually is landscape, will it be switching to landscape?
    var layoutLandscape:Bool = false

    private var _makeFetcher: EdmundsMakesFetcher?
    var makeFetcher: EdmundsMakesFetcher {
        if _makeFetcher == nil {
            _makeFetcher = EdmundsMakesFetcher()
            _makeFetcher!.delegate = self
        }
        return _makeFetcher!
    }
    var makes = [EdmundsMake]()
    var models = [EdmundsModel]()
    
    
    //
    
    
    
    
    private var _imgFetcher: ImageSetFetcher?
    var imgFetcher: ImageSetFetcher {
        if _imgFetcher == nil {
            _imgFetcher = ImageSetFetcher()
            _imgFetcher!.delegate = self
        }
        return _imgFetcher!
    }
    var imageSets = [ImageSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.searchResults = searchResults
        
        makeFetcher.fetchAllMakes()
        imgFetcher.fetchImageSets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImageDownloader.shared.delegate = self
        
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width > size.height {
            layoutLandscape = true
        } else {
            layoutLandscape = false
        }
        
        //collectionView!.reloadData()
        reloadData()
        
        coordinator.animate(alongsideTransition: { [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in
            if let checkSelf = weakSelf {
                
            }
            }, completion: nil)
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        
        //Don't know which order these will come back,
        //syncImages handles the case when both are ready.
        if fetcher === makeFetcher {
            print("___\nFetched Makes!\n___")
            makes = makeFetcher.makes
            makeFetcher.clear()
            syncImages()
            
            
            //var models = [EdmundsModel]()
            buildSearchTree()
            
        } else if fetcher === imgFetcher {
            print("___\nFetched Image Sets!\n___")
            imageSets = imgFetcher.sets
            imgFetcher.clear()
            syncImages()
        }
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        //Theoretically present some type of error indicator to the user.
    }
    
    //It wouldn't even be an actual tree if there were no pinecones.
    //Pre-Condition: makes has been populated.
    func buildSearchTree() {
        
        models.removeAll()
        
        var makeIndex:Int = 0
        for make in makes {
            
            //print("make[\(makeIndex)] = \"\(make.name)\"")
            
            if make.name.characters.count > 0 {
                
                var modelIndex:Int = 0
                
                for model in make.models {
                    
                    if model.name.characters.count > 0 {
                        
                        models.append(model)
                        
                        //print("\t\tmodel[\(modelIndex)] = \"\(model.name)\"")
                        
                        modelIndex += 1
                    }
                }
                makeIndex += 1
            }
        }
        
        searchResults.buildSearchTree(models: models)
        
    }
    
    func syncImages() {
        guard imageSets.count > 0 && makes.count > 0 else {
            //Show placeholder cells even if thumbs haven't come in..
            if makes.count > 0 {
                //collectionView?.reloadData()
                reloadData()
            }
            return
        }
        for i in 0..<makes.count {
            makes[i].set = getImageSetForIndex(index: i)
        }
        //collectionView?.reloadData()
        reloadData()
    }
    
    func getImageSetForIndex(index: Int) -> ImageSet? {
        var result:ImageSet?
        var slot = index
        if imageSets.count > 0 {
            while slot >= imageSets.count {
                slot -= imageSets.count
            }
            if slot >= 0 && slot < imageSets.count {
                result = imageSets[slot]
            }
        }
        return result
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            [weak weakSelf = self] in
            weakSelf?.collectionView.reloadData()
            //Apple Bug - visibleCells is not ready.
        }
        
        //TODO, need better guarantee that this won't miss.
        //(Probably a constant updating timer that tries to pull thumbs...)
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.125) {
        //    [weak weakSelf = self] in
        //    weakSelf?.pullThumb()
        //}
    }
    
    func update() {

        pullThumb()
    }
    
    func pullThumb() -> Void {
        
        if ImageDownloader.shared.isReady == false { return }
        if collectionView.visibleCells.count == 0 { return }
        
        var pickCell: ImageSetCell?
        
        var pullable = [ImageSetCell]()
        pullable.reserveCapacity(collectionView.visibleCells.count)
        
        //Find the valid cells that need thumbs pulled.
        for cell in collectionView.visibleCells {
            if let isc = cell as? ImageSetCell {
                if isc.didDownload == false && isc.isDownloading == false && isc.set != nil {
                    pullable.append(isc)
                    pickCell = isc
                }
            }
        }
        
        if pullable.count > 0 {
            //Get the top left pullable cell.
            var topY = pickCell!.frame.origin.y
            var leftX = pickCell!.frame.origin.x
            for cell in pullable {
                if cell.frame.origin.y <= topY {
                    topY = cell.frame.origin.y
                    leftX = cell.frame.origin.x
                    pickCell = cell
                }
            }
            for cell in pullable {
                if cell.frame.origin.y <= topY && cell.frame.origin.x <= leftX {
                    leftX = cell.frame.origin.x
                    pickCell = cell
                }
            }
        }
        
        //We found one, fetch the thumbs plz!
        if pickCell != nil {
            pickCell!.isDownloading = true
            ImageDownloader.shared.addDownload(forURL: pickCell!.set!.thumbURL, withObject: pickCell!)
            
            //See if we can start another thumb download!
            pullThumb()
        }
    }
    
    func imageDownloadComplete(downloader: ImageDownloader, resultImage: UIImage, urlString: String, object: Any?) {
        print("downloaded thumb \(resultImage.size.width) x \(resultImage.size.height)\n\(urlString)\n")
        
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            if let isc = cell as? ImageSetCell, let set = isc.set {
                if set.thumbURL == urlString {
                    isc.imageView?.image = resultImage
                    if let hpc = isc as? HomePageMakeCell {
                        hpc.animateLoadComplete()
                    }
                }
            }
        }
        pullThumb()
    }
    
    func imageDownloadError(downloader: ImageDownloader, urlString: String, object: Any?) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _ = pullThumb()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "car_cell", for: indexPath) as! HomePageMakeCell
        cell.reset()
        cell.make = makes[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appWidth = ApplicationController.width
        var width = (appWidth / 2) - (4.0 * 3.0)
        if Device.tablet {
            if layoutLandscape {
                width = (appWidth / 4.0) - (4.0 * 5.0)
            } else {
                width = (appWidth / 3.0) - (4.0 * 4.0)
            }
        } else {
            if layoutLandscape {
                width = (appWidth / 3.0) - (4.0 * 4.0)
            }
        }
        let height = width * 0.75 + 30.0
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func animateSearchModeOn() {
        headerHeightConstraint.constant = 78 - 20.0//Device.statusBarHeight
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.view.layoutIfNeeded()
            }, completion: nil)
        searchResults.animateIn()
    }
    
    internal func animateSearchModeOff() {
        headerHeightConstraint.constant = 78
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.view.layoutIfNeeded()
            }, completion: nil)
        searchResults.animateOut()
    }
}





