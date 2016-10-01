//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit


class HomePage : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WebFetcherDelegate, ImageDownloaderDelegate
{
    @IBOutlet weak var header: HomePageHeader!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            layoutLandscape = Device.isLandscape
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var layoutLandscape:Bool = false
    
    /*
     // Defaults to YES, and if YES, any selection is cleared in viewWillAppear:
     // This property has no effect if the useLayoutToLayoutNavigationTransitions property is set to YES
     open var clearsSelectionOnViewWillAppear: Bool
     
     
     // Set to YES before pushing a a UICollectionViewController onto a
     // UINavigationController. The top view controller of the navigation controller
     // must be a UICollectionViewController that was pushed with this property set
     // to NO. This property should NOT be changed on a UICollectionViewController that
     // has already been pushed onto a UINavigationController.
     @available(iOS 7.0, *)
     open var useLayoutToLayoutNavigationTransitions: Bool
     
     
     // The layout object is needed when defining interactive layout to layout transitions.
     @available(iOS 7.0, *)
     open var collectionViewLayout: UICollectionViewLayout { get }
     
     
     // Defaults to YES, and if YES, a system standard reordering gesture is used to drive collection view reordering
     @available(iOS 9.0, *)
     open var installsStandardGestureForInteractiveMovement: Bool
     */
    
    private var _makeFetcher: EdmundsMakesFetcher?
    var makeFetcher: EdmundsMakesFetcher {
        
        if _makeFetcher == nil {
            _makeFetcher = EdmundsMakesFetcher()
            _makeFetcher!.delegate = self
        }
        return _makeFetcher!
    }
    var makes = [EdmundsMake]()
    
    
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
        
        
        //ImageDownloader.shared.del
        
        makeFetcher.fetchAllMakes()
        
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0) { [weak weakSelf = self] in
        //weakSelf?.imgFetcher.fetchImageSets()
        //}
        
        imgFetcher.fetchImageSets()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImageDownloader.shared.delegate = self
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width > size.height {
            layoutLandscape = true
        } else {
            layoutLandscape = false
        }
        
        collectionView!.reloadData()
        
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
    
    func syncImages() {
        guard imageSets.count > 0 && makes.count > 0 else {
            //Show placeholder cells even if thumbs haven't come in..
            if makes.count > 0 {
                collectionView?.reloadData()
            }
            return
        }
        for i in 0..<makes.count {
            makes[i].set = getImageSetForIndex(index: i)
        }
        collectionView?.reloadData()
    }
    
    func getImageSetForIndex(index: Int) -> ImageSet? {
        var result:ImageSet?
        if imageSets.count > 0 {
            if index > imageSets.count {
                //Mod it..
            }
            if index >= 0 && index < imageSets.count {
                result = imageSets[index]
            }
        }
        return result
    }
    
    func pullThumb() -> Bool {
        
        if ImageDownloader.shared.isReady == false { return false }
        
        var result:Bool = false
        
        
        var pickCell: ImageSetCell?
        
        let visibleCells = collectionView.visibleCells
        
        let ipp = collectionView.indexPathsForVisibleItems
        
        
        for cell in visibleCells {
            
            if let isc = cell as? ImageSetCell {
                
                if isc.didDownload == false && isc.isDownloading == false && isc.set != nil {
                    pickCell = isc
                    break
                }
                
                
            }
        }
        
        if let cell = pickCell, let set = cell.set {
            cell.isDownloading = true
            ImageDownloader.shared.addDownload(forURL: set.thumbURL, withObject: cell)
        }
        
        return result
    }
    
    func pullThumb(forCell cell: ImageSetCell) -> Bool {
        
        if ImageDownloader.shared.isReady == false { return false }
        
        var result:Bool = false
        
        if cell.didDownload == false && cell.isDownloading == false {
            if let set = cell.set {
                cell.isDownloading = true
                ImageDownloader.shared.addDownload(forURL: set.thumbURL, withObject: cell)
                return true
            }
        }
        
        return false
    }
    
    //urlString
    
    
    func imageDownloadComplete(downloader: ImageDownloader, resultImage: UIImage, urlString: String, object: Any?) {
        print("SUCCESSFULLY DOWNLOADED IMAGE \(resultImage.size.width) x \(resultImage.size.height)\n\(urlString)\n")
        
        let visibleCells = collectionView.visibleCells
        
        let ipp = collectionView.indexPathsForVisibleItems
        
        
        for cell in visibleCells {
            
            if let isc = cell as? ImageSetCell, let set = isc.set {
                
                if set.thumbURL == urlString {
                    
                    
                    isc.imageView?.image = resultImage
                    //cell.
                    
                }
                
            
                pullThumb(forCell: isc)
                
            }
        }
        
        print("....")
    }
    
    func imageDownloadError(downloader: ImageDownloader, urlString: String, object: Any?) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "car_cell", for: indexPath) as! HomePageMakeCell
        
        cell.reset()
        
        cell.make = makes[indexPath.row]
        
        pullThumb(forCell: cell)
        
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
        var height = width
        return CGSize(width: width, height: height)
    }
    /*
     @available(iOS 6.0, *)
     optional
     
     @available(iOS 6.0, *)
     optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
     
     @available(iOS 6.0, *)
     optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
     
     @available(iOS 6.0, *)
     optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
     
     @available(iOS 6.0, *)
     optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
     
     @available(iOS 6.0, *)
     optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //Weak var handles this, FOOL!
    //deinit {
    //    if ImageDownloader.shared.delegate === self {
    //        ImageDownloader.shared.delegate = nil
    //    }
    //}
    
}





