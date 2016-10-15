//
//  WebFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

protocol WebFetcherDelegate
{
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult)
    func fetchDidFail(fetcher: WebFetcher, result: WebResult)
}

//Fetches JSON data asynchronously with parsing support.
class WebFetcher : NSObject, URLSessionDelegate
{
    var delegate:WebFetcherDelegate?
    
    var data:Data?
    
    var cachingPolicy: NSURLRequest.CachePolicy = .reloadRevalidatingCacheData
    var timeoutInterval: TimeInterval = 16.0
    
    private var sessionTask: URLSession?
    private var sessionDataTask: URLSessionDataTask?
    
    func clear() {
        sessionDataTask?.cancel()
        sessionDataTask = nil
        sessionTask?.invalidateAndCancel()
        sessionTask = nil
        data = nil
    }
    
    internal func succeed() {
        //Typically we want to notify the delegate once a fetch succeeds.
        delegate?.fetchDidSucceed(fetcher: self, result: .success)
    }
    
    internal func fail(result: WebResult) {
        clear()
        delegate?.fetchDidFail(fetcher: self, result: result)
    }
    
    func fetchDidComplete(_ data: Data) {
        //By default, we are successful.
        succeed()
    }
    
    func fetch(_ urlString: String?) {
        //Sanity check.
        guard urlString != nil else {
            fail(result: .invalid)
            return
        }
        
        print("fetch(\"\(urlString!)\")")
        
        //Sanity check.
        guard let url = URL(string: urlString!) else {
            fail(result: .invalid)
            return
        }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: cachingPolicy, timeoutInterval: timeoutInterval)
        
        sessionTask = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        //Sanity check.
        guard sessionTask != nil else {
            fail(result: .invalid)
            return
        }
        
        self.sessionDataTask = sessionTask!.dataTask(with: request as URLRequest, completionHandler:
            {
                [weak weakSelf = self] (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if data == nil || response == nil || error != nil {
                        //Something went wrong with the request...
                        weakSelf?.fail(result: .error)
                    } else {
                        //Request completed!
                        weakSelf?.data = data
                        weakSelf?.fetchDidComplete(data!)
                    }
                }
            })
        
        //Sanity check.
        guard sessionDataTask != nil else {
            fail(result: .invalid)
            return
        }
        sessionDataTask!.resume()
    }
}
