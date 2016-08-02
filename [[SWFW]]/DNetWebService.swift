//
//  ScriptRelief.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

//import UIKit
import Foundation

enum DNetWebServiceDataType : Int{case TypeJSON = 0, TypeXML, TypeString, TypeData, TypeImage}
enum DNetWebServiceRequestType:Int{case RequestDefault = 1, RequestPost, RequestGet}

protocol DNetWebServiceDelegate
{
    func webServiceDidStart(pWS: DNetWebService)
    func webServiceDidFail(pWS: DNetWebService)
    func webServiceDidSucceed(pWS: DNetWebService)
    func webServiceDidReceiveResponse(pWS: DNetWebService)
    func webServiceDidUpdate(pWS: DNetWebService)
}

class DNetWebService : DSObject, DNetConnectionDelegate
{
    var mDelegate:DNetWebServiceDelegate! = nil
    
    var mDataType:DNetWebServiceDataType = DNetWebServiceDataType.TypeJSON
    
    
    var mRequestType:DNetWebServiceRequestType = DNetWebServiceRequestType.RequestDefault
    var mURLString:String! = nil
    
    var mHTTPBodyJSON: String! = nil
    
    var mConnection:DNetConnection! = nil
    
    var mDefaultFile : String!
    
    var mErrorString:String! = nil
    
    var mData:AnyObject! = nil
    var mDataFromFile:Bool = false
    
    var mParser:DNetParser! = nil
    
    
    
    var mActive:Bool = false
    var mDidFail:Bool = false
    var mDidSucceed:Bool = false
    var mDidReceiveResponse:Bool = false
    var mDidCancel:Bool = false
    
    
    required init()
    {
        super.init()
    }
    
    required init(url pURLString: String!, requestType pRequestType:DNetWebServiceRequestType, dataType pDataType:DNetWebServiceDataType)
    {
        super.init()
        
        self.mDataType = pDataType
        self.mRequestType = pRequestType
        if(pURLString != nil){self.mURLString = String(pURLString)}
    }
    
    func start()
    {
        clearConnection()
        
        //print("JSon Body:\n\(mHTTPBodyJSON)");
        //print("EarlString: \(mURLString)");
        
        self.mActive = true
        self.mDidFail = false
        self.mDidSucceed = false
        self.mDidReceiveResponse = false
        self.mDidCancel = false
        self.mDataFromFile = false
        self.mConnection = self.getConnection(mURLString)
        
        if(mConnection != nil)
        {
            self.performSelector(Selector("mainThreadStart"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
            
            mConnection.mDelegate = self
            mActive = true
            mConnection.start()
        }
        else
        {
            fail("Unable to start connection!")
        }
    }
    
    func getConnection(pURLString: String!) -> DNetConnection!
    {
        let aReturn:DNetConnection! = DNetConnection()
        
        if(mRequestType == DNetWebServiceRequestType.RequestDefault)
        {
            aReturn.generateRequest(pURLString)
        }
        else if(mRequestType == DNetWebServiceRequestType.RequestPost)
        {
            aReturn.generatePostRequest(pURLString)
        }
        else if(mRequestType == DNetWebServiceRequestType.RequestGet)
        {
            aReturn.generateGetRequest(pURLString)
        }
        
        if((mHTTPBodyJSON != nil) && (aReturn.mRequest != nil))
        {
            if(mHTTPBodyJSON.characters.count > 0)
            {
                aReturn.mRequest.HTTPBody = mHTTPBodyJSON.dataUsingEncoding(NSUTF8StringEncoding)
            }
        }
        
        return aReturn
    }
    
    func networkRequestDidReceiveResponse(pCon: DNetConnection)
    {
        self.mDidReceiveResponse = true
        self.performSelector(Selector("mainThreadResponse"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    func networkRequestDidUpdate(pCon: DNetConnection)
    {
        self.performSelector(Selector("mainThreadUpdate"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
    }
    
    func networkRequestDidFail(pCon: DNetConnection)
    {
        if(mConnection != nil)
        {
            mConnection.cancel()
            self.mConnection = nil
        }
        
        fail("Connection failure!")
    }
    
    func networkRequestDidSucceed(pCon: DNetConnection)
    {
        //gData.dataFileSave(mConnection.mData, pPath: gData.getDocsPath("response.jsn"))
        
        if(mConnection != nil)
        {
            mDataFromFile = false
            if(self.processData(mConnection.mData) == true)
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
    
    func processData(pData: NSData!) -> Bool
    {
        var aReturn:Bool = false
        
        self.mData = nil
        
        if(pData != nil)
        {
            if(mDataType == DNetWebServiceDataType.TypeJSON)
            {
                self.mData = gData.dataConvertJSON(pData)
                if(mData != nil){aReturn = true}
            }
        }
        
        if((aReturn == true) && (mParser != nil) && (mData != nil))
        {
            if(mParser.parse(mData) == false)
            {
                
                aReturn = false
            }
        }
        
        return aReturn
    }
    
    func setRequestTypePost()
    {
        mRequestType = DNetWebServiceRequestType.RequestPost;
    }
    
    func setRequestTypeGet()
    {
        mRequestType = DNetWebServiceRequestType.RequestGet;
    }
    
    /*
    func fail(pErrorMessage: String)
    {
        if(mDelegate != nil)
        {
            self.performSelector(Selector("failMainThread"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        }
    }
    */
    
    
    
    
    internal func failTryFile()
    {
        if(mDefaultFile != nil)
        {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 200 * Int64(NSEC_PER_MSEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.mDataFromFile = true
                let aData:NSData! = gData.dataFileLoad(self.mDefaultFile)
                if(self.processData(aData) == true)
                {self.succeess()}
                else{self.fail("Tried file: Unable to process data!")}
            }
        }
        else{self.fail("Tried file: No file path input!")}
    }
    
    
    func fail(pErrorMessage: String)
    {
        print("!!! -- WS Failure -- [\n\(pErrorMessage)\n]")
        
        if((mDataFromFile == false) && (mDefaultFile != nil))
        {
            mDataFromFile = true
            self.failTryFile()
        }
        else
        {
            
            
            cancel()
            self.mDidCancel = false
            self.performSelector(Selector("mainThreadFail"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        }
    }
    
    
    func succeess()
    {
            self.mActive = false
            self.mDidFail = false
            self.mDidSucceed = true
            
            self.performSelector(Selector("mainThreadSucceed"), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
        
        self.mDataFromFile = false
    }
    
    
    
    internal func mainThreadStart(){if(mDelegate != nil){mDelegate.webServiceDidStart(self)}}
    internal func mainThreadSucceed()
    {
        if(mDelegate != nil){mDelegate.webServiceDidSucceed(self)}
        if(mNotify != nil)
        {
            if(mNotify.respondsToSelector((Selector("notifyObject:"))))
            {
                mNotify.performSelector(Selector("notifyObject:"),
                    onThread: NSThread.mainThread(), withObject: self, waitUntilDone: true)
            }
        }
    }
    internal func mainThreadFail()
    {
        if(mDelegate != nil){mDelegate.webServiceDidFail(self)}
    
        if(mNotify != nil)
        {
            if(mNotify.respondsToSelector((Selector("notifyObject:"))))
            {
                mNotify.performSelector(Selector("notifyObject:"),
                    onThread: NSThread.mainThread(), withObject: self, waitUntilDone: true)
            }
        }
    }
    internal func mainThreadResponse(){if(mDelegate != nil){mDelegate.webServiceDidReceiveResponse(self)}}
    internal func mainThreadUpdate(){if(mDelegate != nil){mDelegate.webServiceDidUpdate(self)}}
    
    
    
    func clearConnection()
    {
        if(mConnection != nil)
        {
            mConnection.destroy()
            self.mConnection = nil
        }
        
        self.mActive = false
        self.mDidCancel = true
        self.mDidSucceed = false
        self.mDidFail = false
    }
    
    func cancel()
    {
        self.mActive = false
        self.mDidCancel = true
        self.mDidReceiveResponse = false
        self.mDidSucceed = false
        self.mDidFail = false
        
        clearConnection()
        
        mErrorString = ""
        self.mData = nil
    }
    
    override func destroy()
    {
        if(mDestroy == false)
        {
            cancel()
            super.destroy()
        }
        
    }
}
