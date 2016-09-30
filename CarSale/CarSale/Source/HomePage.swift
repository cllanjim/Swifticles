//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit


class HomePage : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, WebFetcherDelegate
{
    @IBOutlet weak var header: HomePageHeader!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
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
        
        makeFetcher.fetchAllMakes()
        imgFetcher.fetchImageSets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
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
            collectionView?.reloadData()
            
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
            return
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "car_cell", for: indexPath) as! HomePageMakeCell
        
        
        
        return cell
        
        /*
        !.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photoInfo = photos[indexPath.item] as Dictionary
        let photoUrlString = (self.layoutType == LayoutType.grid) ? photoInfo["url_q"] : photoInfo["url_z"]
        let photoUrlRequest : URLRequest = URLRequest(url: URL.URLWithString(photoUrlString))
        
        let imageRequestSuccess = {
            (request : URLRequest!, response : HTTPURLResponse!, image : UIImage!) -> Void in
            photoCell.photoImageView.image = image;
            photoCell.photoImageView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                photoCell.photoImageView.alpha = 1.0
            })
        }
        let imageRequestFailure = {
            (request : URLRequest!, response : HTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        photoCell.photoImageView.setImageWithURLRequest(photoUrlRequest, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        
        photoCell.photoInfo = photoInfo
        return photoCell;
        */
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let appWidth = ApplicationController.width
        let appHeight = ApplicationController.height
        
        
        var width = (appWidth / 2) - (8.0 + 8.0 + 8.0)
        
        if Device.tablet {
            width = (appWidth / 3) - (8.0 + 8.0 + 8.0 + 8.0)
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
    
    
}





