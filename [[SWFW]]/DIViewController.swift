//
//  DIViewController.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIViewController: UIViewController
{
    var mX:CGFloat = 0.0;
    var mY:CGFloat = 0.0;
    var mW:CGFloat = 0.0;
    var mH:CGFloat = 0.0;
    var mW2:CGFloat = 0.0;
    var mH2:CGFloat = 0.0;
    var mCX:CGFloat = 0.0;
    var mCY:CGFloat = 0.0;
    
    var mRectSet:Bool = false
    
    var mUpdateAllowed:Bool = true;
    
    var mView:DIView! = nil;
    var mNode:DINode! = nil;
    
    required init()
    {
        super.init(nibName: nil, bundle: nil);
        self.setRect(CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setRect(CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
    }
    
    override required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    init(view pView:DIView!)
    {
        super.init(nibName: nil, bundle: nil);
        self.mView = pView
        if(mView != nil)
        {
            self.view.addSubview(mView)
            self.setRect(CGRectMake(pView.mX, pView.mY, pView.mW, pView.mH))
            
            if((mView.frame.size.width > 0) && (mView.frame.size.height > 0))
            {
                mView.mkchk();
            }
            
        }
        else
        {
            self.setRect(CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
        }
        
        
    }
    
    
    
    func mkchk(pFrame:CGRect)
    {
        //self.makeCheck(pFrame)
        if(mDidMake == false){self.make(CGRectMake(mX, mY, mW, mH))}
        //self.spawnCheck()
        if(mDidSpawn == false){self.spawn()}
        
        self.mRectSet = false
        self.setRect(pFrame)
    }
    
    func mkchk()
    {
        self.mkchk(CGRectMake(mX, mY, mW, mH));
    }
    
    
    func makeSafetyCheck(){if(mDidMake == true){print("ERROR!!! Double-Make NOT ALLOWED...!");exit(0);}}
    var mDidMake:Bool = false
    func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        gDS.registerNew(vc: self);
        self.mDidMake = true;
        self.setRect(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))
        self.internalAdjustContent()
    }
    
    //func makeCheck(frame: CGRect){}
    
    
    func spawnSafetyCheck()
    {
        if(mDidMake == false)
        {
            print("ERROR!!! Spawn before make ILLEGAL...!")
            sleep(100000)
        }
        
        if(mDidSpawn == true)
        {
            print("ERROR!!! Double - Spawn before make ILLEGAL...!")
            sleep(100000)
        }
    }
    var mDidSpawn:Bool = false
    func spawn(){self.spawnSafetyCheck();self.mDidSpawn = true;}
    
    func adjustContent()
    {
        self.internalAdjustContent();
    }
    
    
    func baseInitialize(){self.mkchk();}
    func initialize(){}
    func baseUpdate(){}
    
    func getNode() -> DINode!
    {
        var aReturn:DINode! = mNode;
        if(aReturn == nil)
        {
            self.mNode = DINode(vc: self);
            aReturn = self.mNode;
        }
        return aReturn;
    }
    
    func update()
    {
        
    }
    
    func updateStart()
    {
        gDS.registerUpdate(node: self.getNode());
    }
    
    func updateStop()
    {
        gDS.removeUpdate(node: self.getNode());
    }

    internal func internalAdjustContent()
    {
        self.mX = self.view.frame.origin.x;
        self.mY = self.view.frame.origin.y;
        self.mW = self.view.frame.size.width;
        self.mH = self.view.frame.size.height;
        self.mW2 = mW / 2.0;
        self.mH2 = mH / 2.0;
        self.mCX = mX + mW2;
        self.mCY = mY + mH2;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func didFinishTransitionIn()
    {
        if(self.view != nil)
        {
            if(self.view.respondsToSelector((Selector("didFinishAnimatingIn"))))
            {
                self.view.performSelector(Selector("didFinishAnimatingIn"),
                    onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: true)
            }
        }
        if(mView != nil)
        {
            mView.didFinishTransitionIn();
        }
    }
    
    func addSubview(pView:UIView!)
    {
        if(pView != nil)
        {
            self.view.addSubview(pView)
        }
    }
    
    func add(pViewController:UIViewController!)
    {
        if(pViewController != nil)
        {
            pViewController.view.frame = CGRect(x: pViewController.view.frame.origin.x, y: pViewController.view.frame.origin.y, width: pViewController.view.frame.size.width, height: pViewController.view.frame.size.height)
            if(pViewController.view != nil){self.view.addSubview(pViewController.view)}
        }
    }
    
    
    func setRect(pRect:CGRect)
    {
        if((pRect.origin.x != mX) || (pRect.origin.y != mY) || (pRect.size.width != mW) || (pRect.size.height != mH) || (mRectSet == false))
        {
            mRectSet = true
            self.view.frame = CGRect(x: pRect.origin.x, y: pRect.origin.y, width: pRect.size.width, height: pRect.size.height);
            if(mView != nil)
            {
                mView.setRect(CGRectMake(0.0, 0.0, pRect.size.width, pRect.size.height))
            }
            
            self.internalAdjustContent()
            if((mDidMake == true) && (mDidSpawn == true))
            {
                self.adjustContent();
            }
        }
        //self.internalAdjustContent();
    }
    
    
    func setX(pX:CGFloat)
    {
        self.setRect(CGRect(x: pX, y: mY, width: mW, height: mH));
    }
    
    func setY(pY:CGFloat)
    {
        self.setRect(CGRect(x: mX, y: pY, width: mW, height: mH));
    }
    
    func setWidth(pWidth:CGFloat)
    {
        self.setRect(CGRect(x: mX, y: mY, width: pWidth, height: mH));
    }
    
    func setHeight(pHeight:CGFloat)
    {
        self.setRect(CGRect(x: mX, y: mY, width: mW, height: pHeight));
    }
    
    func log()
    {
        print("View Controller (\(gDS.getName(obj: self)) => [\(self.view.frame.origin.x), \(self.view.frame.origin.y)] (\(self.view.frame.size.width) x \(self.view.frame.size.height)")
    }
    
    func shouldDest() -> Bool
    {
        return (getNode().mDestroy == false)
    }
    
    func destroy()
    {
        if(shouldDest() == true)
        {
            self.mUpdateAllowed = false
            self.view.userInteractionEnabled = false
            self.updateStop()
            gDS.registerDestroy(node: self.getNode())
            
            //gDS.destroy(self)
            self.view.layer.removeAllAnimations();
            self.view.removeFromSuperview()

        }
    }
}
