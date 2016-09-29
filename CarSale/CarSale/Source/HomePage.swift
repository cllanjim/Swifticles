//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit


class HomePage : UIViewController, UICollectionViewDelegate, WebFetcherDelegate
{
    @IBOutlet weak var header: HomePageHeader!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sessionTask: URLSessionTask?
    private var sessionDataTask: URLSessionDataTask?
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeFetcher.fetchAllMakes()
        imgFetcher.fetchImageSets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        
        if fetcher === makeFetcher {
            
            print("___\nFetched Makes!\n___")
            
            makes = makeFetcher.makes
            makeFetcher.clear()
            
            print(makes)
            
            collectionView.reloadData()
        } else if fetcher === imgFetcher {
            
            print("___\nFetched Image Sets!\n___")
            
            //makes = makeFetcher.makes
            //makeFetcher.clear()
            
            //print(makes)
            
            //collectionView.reloadData()
        }
        
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
        
    }
}





