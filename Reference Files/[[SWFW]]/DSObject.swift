//
//  DSObject.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

class DSObject : NSObject
{
    var mNotify:NSObject! = nil
    var mDestroy:Bool = false;
    
    required override init()
    {
        super.init()
    }
    
    func notify(pObj:AnyObject)
    {
        
    }
    
    func notifySend()
    {
        if(mNotify != nil)
        {
            if(mNotify.respondsToSelector((Selector("notifyObject:"))))
            {
                mNotify.performSelector(Selector("notifyObject:"),
                onThread: NSThread.mainThread(), withObject: self,
                waitUntilDone: true)
            }
        }
    }
    
    func destroy()
    {
        if(mDestroy == false)
        {
            self.mDestroy = true
            self.mNotify = nil;
        }
        
    }
    
}
