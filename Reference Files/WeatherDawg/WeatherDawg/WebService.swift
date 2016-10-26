//
//  ScriptRelief.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

//import UIKit
import Foundation

enum WebServiceDataType : Int{case TypeJSON = 0, TypeXML, TypeString, TypeData, TypeImage}
enum WebServiceRequestType:Int{case RequestDefault = 1, RequestPost, RequestGet}

protocol WebServiceDelegate
{
    func webServiceDidStart(ws: WebService)
    func webServiceDidFail(ws: WebService)
    func webServiceDidSucceed(ws: WebService)
    func webServiceDidReceiveResponse(ws: WebService)
    func webServiceDidUpdate(ws: WebService)
}

class WebService : NSObject, NetworkConnectionDelegate
{
    var delegate:WebServiceDelegate! = nil
    
    var dataType:WebServiceDataType = WebServiceDataType.TypeJSON
    
    var requestType:WebServiceRequestType = WebServiceRequestType.RequestDefault
    var urlString:String! = nil
    
    var httpBody: String! = nil
    
    var connection:NetworkConnection! = nil
    
    var errorString:String! = nil
    
    var data:AnyObject! = nil
    var dataFromFile:Bool = false
    
    var isActive:Bool = false
    var didFail:Bool = false
    var didSucceed:Bool = false
    var didReceiveResponse:Bool = false
    var didCancel:Bool = false
    
    
    override init()
    {
        super.init()
    }
    
    required init(url pURLString: String!, requestType pRequestType:WebServiceRequestType, dataType pDataType:WebServiceDataType)
    {
        super.init()
        
        self.dataType = pDataType
        self.requestType = pRequestType
        if(pURLString != nil){self.urlString = String(pURLString)}
    }
    
    func start()
    {
        clearConnection()
        
        self.isActive = true
        self.didFail = false
        self.didSucceed = false
        self.didReceiveResponse = false
        self.didCancel = false
        self.dataFromFile = false
        self.connection = self.getConnection(urlString)
        
        if(connection != nil)
        {
            self.performSelector(Selector("mainThreadStart"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
            
            connection.delegate = self
            isActive = true
            connection.start()
        }
        else
        {
            fail("Unable to start connection!")
        }
    }
    
    func getConnection(pURLString: String!) -> NetworkConnection!
    {
        let result:NetworkConnection! = NetworkConnection()
        
        if(requestType == WebServiceRequestType.RequestDefault)
        {
            result.generateRequest(pURLString)
        }
        else if(requestType == WebServiceRequestType.RequestPost)
        {
            result.generatePostRequest(pURLString)
        }
        else if(requestType == WebServiceRequestType.RequestGet)
        {
            result.generateGetRequest(pURLString)
        }
        
        if((httpBody != nil) && (result.request != nil))
        {
            if(httpBody.characters.count > 0)
            {
                result.request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            }
        }
        
        return result
    }
    
    func networkRequestDidReceiveResponse(con: NetworkConnection)
    {
        self.didReceiveResponse = true
        self.performSelector(Selector("mainThreadResponse"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    func networkRequestDidUpdate(con: NetworkConnection)
    {
        self.performSelector(Selector("mainThreadUpdate"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    func networkRequestDidFail(con: NetworkConnection)
    {
        if(connection != nil)
        {
            connection.cancel()
            self.connection = nil
        }
        
        fail("Connection failure!")
    }
    
    func networkRequestDidSucceed(con: NetworkConnection)
    {
        if(connection != nil)
        {
            dataFromFile = false
            if(self.processData(connection.data) == true)
            {
                self.succeess()
            }
            else
            {
                self.fail("Unable to parse data (Connection)!")
            }
        }
        else
        {
            fail("Request finished with null connection!")
        }
    }
    
    func dataConvertJSON(pData: NSData!) -> AnyObject!
    {
        var result:AnyObject! = nil
        if(pData != nil)
        {
            do{result = try NSJSONSerialization.JSONObjectWithData(pData!, options:.MutableLeaves)}
            catch{result = nil;}
        }
        return result
    }
    
    func processData(pData: NSData!) -> Bool
    {
        var result:Bool = false
        
        self.data = nil
        
        if(pData != nil)
        {
            if(dataType == WebServiceDataType.TypeJSON)
            {
                self.data = dataConvertJSON(pData)
                if(data != nil){result = true}
            }
        }
        
        return result
    }
    
    func setRequestTypePost()
    {
        requestType = WebServiceRequestType.RequestPost;
    }
    
    func setRequestTypeGet()
    {
        requestType = WebServiceRequestType.RequestGet;
    }
    
    func fail(pErrorMessage: String)
    {
        print("!!! -- WS Failure -- [\n\(pErrorMessage)\n]")
        
        cancel()
        self.didCancel = false
        self.performSelector(Selector("mainThreadFail"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    
    func succeess()
    {
        self.isActive = false
        self.didFail = false
        self.didSucceed = true
        
        self.performSelector(Selector("mainThreadSucceed"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        
        self.dataFromFile = false
    }
    
    
    
    internal func mainThreadStart(){if(delegate != nil){delegate.webServiceDidStart(self)}}
    internal func mainThreadSucceed(){if(delegate != nil){delegate.webServiceDidSucceed(self)}}
    internal func mainThreadFail(){if(delegate != nil){delegate.webServiceDidFail(self)}}
    internal func mainThreadResponse(){if(delegate != nil){delegate.webServiceDidReceiveResponse(self)}}
    internal func mainThreadUpdate(){if(delegate != nil){delegate.webServiceDidUpdate(self)}}
    
    
    
    func clearConnection()
    {
        if(connection != nil)
        {
            connection.cancel()
            self.connection = nil
        }
        
        self.isActive = false
        self.didCancel = true
        self.didSucceed = false
        self.didFail = false
    }
    
    func cancel()
    {
        self.isActive = false
        self.didCancel = true
        self.didReceiveResponse = false
        self.didSucceed = false
        self.didFail = false
        
        clearConnection()
        
        errorString = ""
        self.data = nil
    }
}



