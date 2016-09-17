//
//  JiggleConfig.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DINode : NSObject
{
    var mViewController:DIViewController! = nil;
    var mView:DIView! = nil;
    var mLabel:DILabel! = nil;
    
    var mUpdate:Bool = false;
    var mUpdateTicks:Int = 0;
    
    var mDestroy:Bool = false;
    var mDestroyTick:Int = 8;
    
    var mBubbleFlag:Bool = false;
    var mBubbleCheck:Bool = false;
    var mBubbleDepth:Int = -1;
    
    func baseInitialize()
    {
        if(mView != nil){mView.baseInitialize();}
        else if(mViewController != nil){mViewController.baseInitialize();}
    }
    
    func initialize()
    {
        if(mView != nil){mView.initialize();}
        else if(mViewController != nil){mViewController.initialize();}
    }
    
    func update()
    {
        if(mView != nil){mView.baseUpdate();}
        else if(mViewController != nil){mViewController.baseUpdate();}
    }
    
    func updateStart()
    {
        mUpdate = true;
        
        //if(mView != nil){mView.mUpdate = true;}
        //else if(mViewController != nil){mViewController.mUpdate = true;}
    }
    
    func updateStop()
    {
        mUpdate = false;
        
        //if(mView != nil){mView.mUpdate = false;}
        //else if(mViewController != nil){mViewController.mUpdate = false;}
    }
    
    func destroy()
    {
        mDestroy = true;
        mDestroyTick = 10;
    }
    
    func log()
    {
        if(mView != nil){mView.log();}
        else if(mViewController != nil){mViewController.log();}
    }
    
    override init(){super.init();}
    init(vc pViewController: DIViewController!){self.mViewController = pViewController;}
    init(view pView: DIView!){self.mView = pView;}
    
    var mRoot:UIViewController! = nil;
    
    
}