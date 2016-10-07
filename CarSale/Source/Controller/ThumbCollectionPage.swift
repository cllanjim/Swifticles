//
//  ThumbCollectionPage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation


import UIKit

class ThumbCollectionPage : UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource, ImageDownloaderDelegate
{
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var refreshSpinner: RefreshSpinner?
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            layoutLandscape = Device.isLandscape
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var updateTimer:Timer?
    
    //Before the orientation actually is landscape, will it be switching to landscape?
    var layoutLandscape:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            }, completion: nil)
    }
    
    func getImageSetForIndex(index: Int) -> ImageSet? {
        return nil
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            [weak weakSelf = self] in
            weakSelf?.collectionView.reloadData()
        }
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
                if isc.didDownload == false && isc.didAttemptDownload == false && isc.isDownloading == false && isc.set != nil {
                    pullable.append(isc)
                    pickCell = isc
                }
            }
        }
        
        if pullable.count <= 0 {
            for cell in collectionView.visibleCells {
                if let isc = cell as? ImageSetCell {
                    if isc.didDownload == false && isc.isDownloading == false && isc.set != nil {
                        pullable.append(isc)
                        pickCell = isc
                    }
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
            pickCell!.didAttemptDownload = true
            ImageDownloader.shared.addDownload(forURL: pickCell!.set!.thumbURL, withObject: pickCell!)
            
            //See if we can start another thumb download!
            pullThumb()
        }
    }
    
    //Match up the thumb to the proper cell based on URL...
    func imageDownloadComplete(downloader: ImageDownloader, resultImage: UIImage, urlString: String, object: Any?) {
        print("downloaded thumb \(resultImage.size.width) x \(resultImage.size.height)\n\(urlString)\n")
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            if let isc = cell as? ImageSetCell, let set = isc.set {
                if set.thumbURL == urlString {
                    
                    isc.loadThumbComplete(thumb: resultImage)
                }
            }
        }
        pullThumb()
    }
    
    //Notify the cell that we couldn't pull its thumb.
    func imageDownloadError(downloader: ImageDownloader, urlString: String, object: Any?) {
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            if let isc = cell as? ImageSetCell, let set = isc.set {
                if set.thumbURL == urlString {
                    isc.loadThumbError()
                }
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0.0 {
            
            var offset:CGFloat = -scrollView.contentOffset.y
            var percent = offset / 120.0
            if percent > 1.0 { percent = 1.0 }
            
            refreshSpinner?.revealPercent = percent
            
            //print("CONTENT OFFSET = \(scrollView.contentOffset.y)")
            print("SPINNR PURCANT = \(percent)")
            
            
            
            
        } else {
            
        }
        
        
    }
    
    //Override this, here for completion's sake.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    //Override this, here for completion's sake.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let result = UICollectionViewCell(frame: CGRect(x: 0.0, y: 0.0, width: 256.0, height: 128.0))
        result.backgroundColor = UIColor.cyan
        return result
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appWidth = ApplicationController.width
        var width = (appWidth - (12.0 * 3.0)) / 2.0
        if Device.tablet {
            if layoutLandscape {
                width = (appWidth - (12.0 * 5.0)) / 4.0
            } else {
                width = (appWidth - (12.0 * 4.0)) / 3.0
            }
        } else {
            if layoutLandscape {
                width = (appWidth - (12.0 * 4.0)) / 3.0
            }
        }
        let height = CGFloat(Int(width * 0.75 + 30.0))
        width = CGFloat(Int(width))
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}




