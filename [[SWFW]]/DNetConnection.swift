//
//  DNetHTTPRequest.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/22/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

protocol DNetConnectionDelegate
{
    func networkRequestDidFail(pCon: DNetConnection)
    func networkRequestDidSucceed(pCon: DNetConnection)
    func networkRequestDidReceiveResponse(pCon: DNetConnection)
    func networkRequestDidUpdate(pCon: DNetConnection)
}

class DNetConnection :DSObject, NSURLSessionDelegate, NSURLConnectionDataDelegate
{
    var mDelegate:DNetConnectionDelegate! = nil
    
    var mURLString:String!
    var mURL:NSURL!
    var mRequest:NSMutableURLRequest!
    
    var mSession:NSURLSession!
    var mData:NSData!
    
    var mSessionTask:NSURLSessionDataTask!
    
    var mActive:Bool = false
    var mDidFail:Bool = false
    var mDidSucceed:Bool = false
    var mDidReceiveResponse:Bool = false
    var mDidCancel:Bool = false
    
    required init()
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
        self.mURLString = String(pURLString)
        self.mURL = NSURL(string: mURLString)
        
        cancel()
        if(mURLString != nil)
        {
            if(mURLString.characters.count > 0)
            {
                self.mRequest = NSMutableURLRequest(URL: mURL, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0)
            }
        }
    }
    
    func generatePostRequest(pURLString: String)
    {
        self.mURLString = String(pURLString)
        self.mURL = NSURL(string: mURLString)
        cancel()
        if(mURLString != nil)
        {
            if(mURLString.characters.count > 0)
            {
                self.mRequest = NSMutableURLRequest(URL: mURL, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0);
                if(mRequest != nil){mRequest.HTTPMethod = "POST"}
            }
        }
    }
    
    func generateGetRequest(pURLString: String)
    {
        self.mURLString = String(pURLString)
        self.mURL = NSURL(string: mURLString)
        
        cancel()
        if(mURLString != nil)
        {
            if(mURLString.characters.count > 0)
            {
                self.mRequest = NSMutableURLRequest(URL: mURL, cachePolicy:
                    NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 24.0)
                if(mRequest != nil){mRequest.HTTPMethod = "GET"}
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
        if(mData == nil){self.mData = NSMutableData()}
        (mData as! NSMutableData).appendData(data)
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
        let aRequest : NSURLRequest? = request
        completionHandler(aRequest)
    }
    
    func start()
    {
        self.mActive = true
        self.mDidFail = false
        self.mDidSucceed = false
        self.mDidReceiveResponse = false
        self.mDidCancel = false
        
        if(mRequest != nil)
        {
            self.mSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue:NSOperationQueue.mainQueue())
            
            
            
            self.mSessionTask = mSession.dataTaskWithRequest(mRequest, completionHandler:
                {pData, response, error -> Void in
                    
                    //print("Response = \(response)")
                    //print("Error = \(error)")
                    
                    if(error != nil){self.conFail(error!.localizedDescription);return;}
                    if(pData == nil){self.conFail("Completed with null data!");return;}
                    if(response == nil){self.conFail("No response generated!");return;}
                    
                    self.mData = NSData(data: pData!)
                    self.conSucceess()
            })
            mSessionTask.resume()
        }
    }
    
    
    func cancel()
    {
        self.mActive = false
        self.mDidCancel = true
        self.mDidReceiveResponse = false
        self.mDidSucceed = false
        self.mDidFail = false
        
        if(mSessionTask != nil)
        {
            mSessionTask.cancel()
            self.mSessionTask = nil
        }
        if(mRequest != nil)
        {
            self.mRequest = nil
        }
        if(mData != nil)
        {
            self.mData = nil;
        }
    }
    
    //
    
    internal func updateMainThread(){if(mDelegate != nil){mDelegate.networkRequestDidUpdate(self)}}
    internal func receiveResponseMainThread(){if(mDelegate != nil){mDelegate.networkRequestDidReceiveResponse(self)}}
    internal func failMainThread(){if(mDelegate != nil){mDelegate.networkRequestDidFail(self)}}
    internal func succeessMainThread(){if(mDelegate != nil){mDelegate.networkRequestDidSucceed(self)}}
    
    
    internal func conResponse()
    {
        self.performSelector(Selector("receiveResponseMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        
        self.mDidReceiveResponse = true
        
    }
    
    internal func comUpdate(pErrorMessage: String)
    {
        self.performSelector(Selector("updateMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    internal func conFail(pErrorMessage: String)
    {
        self.mActive = false
        self.mDidFail = true
        self.mDidSucceed = false
        
        self.cancel()
        self.performSelector(Selector("failMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    
    internal func conSucceess()
    {
        self.mActive = false
        self.mDidFail = false
        self.mDidSucceed = true
        
        self.performSelector(Selector("succeessMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    override func destroy()
    {
        if(mDestroy == false)
        {
            self.cancel()
            
            self.mDelegate = nil
            
            self.mURLString = nil
            self.mURL = nil
            
            super.destroy();
        }
    }
    
}
