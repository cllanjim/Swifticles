//
//  WebFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
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
    
    private var sessionTask: URLSession?
    private var sessionDataTask: URLSessionDataTask?
    
    func clear() {
        sessionDataTask?.cancel()
        sessionDataTask = nil
        
        sessionTask?.invalidateAndCancel()
        sessionTask = nil
    }
    
    internal func succeed() {
        //Typically we want to notify the delegate once a fetch succeeds.
        delegate?.fetchDidSucceed(fetcher: self, result: .success)
    }
    
    internal func fail(result: WebResult) {
        
        clear()
        
        if delegate != nil {
            delegate!.fetchDidFail(fetcher: self, result: result)
        }
        
        print("FAIL!")
    }
    
    func parse(data: Any) -> Bool {
        print("PARSE SHOULD BE OVERRIDEN")
        return true
    }
    
    func fetch(_ urlString: String?) {
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
                        //Something went wrong with the request...
                        weakSelf.fail(result: .error)
                    } else {
                        //Request succeeded, let's see if we can get JSON out of it.
                        let _jsonData = FileUtils.parseJSON(data: data)
                        guard _jsonData != nil else {
                            //It's not even JSON!
                            weakSelf.fail(result: .error)
                            return
                        }
                        
                        //It's JSON, let's try to parse it.
                        if weakSelf.parse(data: _jsonData!) {
                            //Woohoo!
                            weakSelf.succeed()
                        } else {
                            //Parsing failed, was this the expected data?
                            weakSelf.fail(result: .error)
                        }
                    }
                }
            })
        
        guard sessionDataTask != nil else {
            fail(result: .invalid)
            return
        }
        sessionDataTask!.resume()
    }
}
