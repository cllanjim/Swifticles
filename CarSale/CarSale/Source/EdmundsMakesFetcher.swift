//
//  EdmundsMakesFetcher.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

//API KEY: yfwsqhj7ymscvt5sxh32f68a
//Shared secret: JQeZpBDHUdG8bzPbjQT6h6t2

//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a
//http://api.edmunds.com/api/vehicle/v2/lexus/models?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&callback=myFunction
//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&state=new&view=full

protocol EdmundsMakesFetcherDelegate
{
    func makesFetchDidSucceed(fetcher: EdmundsMakesFetcher)
    func makesFetchDidFail(fetcher: EdmundsMakesFetcher, result: EdmundsWebResult)
}

class EdmundsMakesFetcher : NSObject, URLSessionDelegate
{
    var delegate:EdmundsMakesFetcherDelegate?
    
    var makes = [EdmundsMake]()
    
    private var sessionTask: URLSession?
    private var sessionDataTask: URLSessionDataTask?
    
    //internal func
    
    internal func fail(result: EdmundsWebResult) {
        print("FAIL!")
    }
    
    func fetchAllMakes() {
        fetch("https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a")
    }
    
    private func fetch(_ urlString: String?) {
        
        
        
        guard urlString != nil else {
            fail(result: .invalid)
            return
        }
        
        print("fetch(\"\(urlString!)\")")
        
        guard let url = URL(string: urlString!) else {
            fail(result: .invalid)
            return
        }
        
        let request = NSURLRequest(url: url)
        
        sessionTask = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        guard sessionTask != nil else {
            fail(result: .invalid)
            return
        }
        
        self.sessionDataTask = sessionTask!.dataTask(with: request as URLRequest, completionHandler:
            {
                [weakSelf = self] (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if data == nil || response == nil || error != nil {
                        weakSelf.fail(result: .error)
                    } else {
                        let _jsonData = FileUtils.parseJSON(data: data) as? [String:Any]
                        guard _jsonData != nil else {
                            weakSelf.fail(result: .error)
                            return
                        }
                        weakSelf.parse(data: _jsonData!)
                    }
                }
            })
        
        guard sessionDataTask != nil else {
            fail(result: .invalid)
            return
        }
        
        sessionDataTask!.resume()
    }
    
    func parse(data: [String:Any]) {
        
        makes.removeAll()
        print("JSON DATA = ")
        print("\(data)")
        
        if let _makes = data["makes"] as? [[String:Any]] {
            
            for _make in _makes {
                
                var make = EdmundsMake()
                if make.load(data: _make) {
                    makes.append(make)
                }
            }
            
            print("____")
            print("\(makes)")
            
        }
        
        
        
    }
    
    //private func fetch
    
    
    
    
}











