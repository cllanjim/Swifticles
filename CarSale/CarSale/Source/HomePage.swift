//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit




class HomePage : UIViewController, UICollectionViewDelegate, EdmundsMakesFetcherDelegate
{
    @IBOutlet weak var header: HomePageHeader!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sessionTask: URLSessionTask?
    private var sessionDataTask: URLSessionDataTask?
    
    var fetcher = EdmundsMakesFetcher() { didSet { fetcher.delegate = self } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetcher.fetchAllMakes()
        
        
        /*
        let request = NSURLRequest(url: URL(string: urlString)!)
        
        self.sessionTask = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        
        self.sessionDataTask = sessionTask!.dataTask(with: request as URLRequest, completionHandler:
            {
                [weakSelf = self] (data, response, error) -> Void in
                
                if data == nil || response == nil || error != nil {
                    weakSelf.fail()
                } else {
                    
                    DispatchQueue.main.async { //[strongSelf = weakSelf] in
                        
                        let jsonData = FileUtils.parseJSON(data: data) as? [String:AnyObject]
                        
                        
                        print("JSON DATA = ")
                        print("\(jsonData)")
                    }
                }
                
                
                
                
                
                var str = String(data: data!, encoding: String.Encoding.utf8)
                
                print(str)
                
                print("Response = \(response)")
                print("Error = \(error)")
                
            })
        sessionDataTask?.resume()
        */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func makesFetchDidSucceed(fetcher: EdmundsMakesFetcher) {
        
    }
    
    func makesFetchDidFail(fetcher: EdmundsMakesFetcher, result: EdmundsWebResult) {
        
    }
    
}
