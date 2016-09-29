//
//  DNetHTTPRequest.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/22/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation



protocol NetworkConnectionDelegate
{
    func networkRequestDidFail(con: NetworkConnection)
    func networkRequestDidSucceed(con: NetworkConnection)
    func networkRequestDidReceiveResponse(con: NetworkConnection)
    func networkRequestDidUpdate(con: NetworkConnection)
}

class NetworkConnection : NSObject, NSURLSessionDelegate, NSURLConnectionDataDelegate
{
    var delegate:NetworkConnectionDelegate! = nil
    
    var urlString:String!
    var url:NSURL!
    var request:NSMutableURLRequest!
    
    var session:NSURLSession!
    var data:NSData!
    
    var sessionTask:NSURLSessionDataTask!
    
    var isActive:Bool = false
    var didFail:Bool = false
    var didSucceed:Bool = false
    var didReceiveResponse:Bool = false
    var didCancel:Bool = false
    
    override init()
    {
        super.init()
    }
    
    init(pURLString: String)
    {
        super.init()
        self.generateRequest(pURLString)
        self.start()
    }
    
    func generateRequest(pURLString: String)
    {
        self.urlString = String(pURLString)
        self.url = NSURL(string: urlString)
        
        cancel()
        if(urlString != nil)
        {
            if(urlString.characters.count > 0)
            {
                self.request = NSMutableURLRequest(URL: url, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0)
            }
        }
    }
    
    func generatePostRequest(pURLString: String)
    {
        self.urlString = String(pURLString)
        self.url = NSURL(string: urlString)
        cancel()
        if(urlString != nil)
        {
            if(urlString.characters.count > 0)
            {
                self.request = NSMutableURLRequest(URL: url, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0);
                if(request != nil){request.HTTPMethod = "POST"}
            }
        }
    }
    
    func generateGetRequest(pURLString: String)
    {
        self.urlString = String(pURLString)
        self.url = NSURL(string: urlString)
        
        cancel()
        
        if(urlString != nil)
        {
            if(urlString.characters.count > 0)
            {
                self.request = NSMutableURLRequest(URL: url, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0)
                if(request != nil){request.HTTPMethod = "GET"}
            }
        }
    }
    
    func connection(connection: NSURLConnection,  didReceiveResponse response: NSURLResponse)
    {
        self.conResponse()
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        self.conFail(error.localizedDescription)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        if(self.data == nil){self.data = NSMutableData()}
        (self.data as! NSMutableData).appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        conSucceess()
    }
    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,
            NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> Void)
    {
        let request : NSURLRequest? = request
        completionHandler(request)
    }
    
    func start()
    {
        self.isActive = true
        self.didFail = false
        self.didSucceed = false
        self.didReceiveResponse = false
        self.didCancel = false
        
        if(request != nil)
        {
            self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue:NSOperationQueue.mainQueue())
            self.sessionTask = session.dataTaskWithRequest(request, completionHandler:
                {pData, response, error -> Void in
                    
                    if(error != nil){self.conFail(error!.localizedDescription);return;}
                    if(pData == nil){self.conFail("Completed with null data!");return;}
                    if(response == nil){self.conFail("No response generated!");return;}
                    
                    self.data = NSData(data: pData!)
                    self.conSucceess()
            })
            sessionTask.resume()
        }
    }
    
    
    func cancel()
    {
        self.isActive = false
        self.didCancel = true
        self.didReceiveResponse = false
        self.didSucceed = false
        self.didFail = false
        
        if(sessionTask != nil)
        {
            sessionTask.cancel()
            self.sessionTask = nil
        }
        if(request != nil)
        {
            self.request = nil
        }
        if(data != nil)
        {
            self.data = nil;
        }
    }
    
    internal func updateMainThread(){if(delegate != nil){delegate.networkRequestDidUpdate(self)}}
    internal func receiveResponseMainThread(){if(delegate != nil){delegate.networkRequestDidReceiveResponse(self)}}
    internal func failMainThread(){if(delegate != nil){delegate.networkRequestDidFail(self)}}
    internal func succeessMainThread(){if(delegate != nil){delegate.networkRequestDidSucceed(self)}}
    
    internal func conResponse()
    {
        self.performSelector(Selector("receiveResponseMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        
        self.didReceiveResponse = true
        
    }
    
    internal func comUpdate(pErrorMessage: String)
    {
        self.performSelector(Selector("updateMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    internal func conFail(pErrorMessage: String)
    {
        self.isActive = false
        self.didFail = true
        self.didSucceed = false
        
        self.cancel()
        self.performSelector(Selector("failMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    internal func conSucceess()
    {
        self.isActive = false
        self.didFail = false
        self.didSucceed = true
        
        self.performSelector(Selector("succeessMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
}

