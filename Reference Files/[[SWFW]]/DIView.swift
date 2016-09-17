//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit


//protocol DIViewProtocol
//{
//    
//    var mW: CGFloat {get set}
//    var mH: CGFloat {get set}
//    
//    func make(frame: CGRect) ->Void;
//    func spawn() -> Void;
//    
//    func adjustContent() -> Void
//    func internalAdjustContent();
//    //func hasFur() -> String
//    //func countLegs() -> String
//    
//    func destroy() ->Void;
//    
//}


class DIView : UIView
{
    var mX:CGFloat = 0.0;
    var mY:CGFloat = 0.0;
    var mW:CGFloat = 0.0;
    var mH:CGFloat = 0.0;
    var mW2:CGFloat = 0.0;
    var mH2:CGFloat = 0.0;
    var mCX:CGFloat = 0.0;
    var mCY:CGFloat = 0.0;
    
    var mViewController:DIViewController! = nil;
    
    
    var mNode:DINode! = nil;
    
    var mNotify:AnyObject! = nil
    var mRectSet:Bool = false
    var mParent:DIView! = nil
    var mUpdateAllowed:Bool = true;
    
    var mAnimatingIn:Bool = false;
    var mAnimatingOut:Bool = false;
    
    
    required init(){super.init(frame: CGRectMake(0.0, 0.0, 0.0, 0.0));
        self.setRect(CGRectMake(0.0, 0.0, 0.0, 0.0));}
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.setRect(CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
    }
    
    required override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.setRect(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))
    }
    
    func getNode() -> DINode!
    {
        var aReturn:DINode! = mNode;
        
        if(mNode == nil)
        {
            if(mViewController != nil)
            {
                aReturn = mViewController.getNode();
            }
            
            if(aReturn == nil)
            {
                self.mNode = DINode(view: self);
                aReturn = self.mNode;
            }
            
        }
        return mNode;
    }
    
    func mkchk(pFrame:CGRect)
    {
        if(mDidMake == false){self.make(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))}
        else{self.setRect(pFrame)}
        if(mDidSpawn == false){self.spawn()}
        self.mRectSet = false
        self.setRect(pFrame)
    }
    
    func mkchk(){self.mkchk(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height));}
    
    
    func makeSafetyCheck(){if(mDidMake == true){print("ERROR!!! Double-Make NOT ALLOWED...!");exit(0);}}
    var mDidMake:Bool = false
    func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        gDS.registerNew(view: self);self.mDidMake = true;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        self.internalAdjustContent()
    }
    
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
    
    internal func internalAdjustContent()
    {
        self.mX = self.frame.origin.x;
        self.mY = self.frame.origin.y;
        self.mW = self.frame.size.width;
        self.mH = self.frame.size.height;
        self.mW2 = mW / 2.0;
        self.mH2 = mH / 2.0;
        self.mCX = mX + mW2;
        self.mCY = mY + mH2;
    }
    
    func notifyObject(pObj:AnyObject)
    {
        
    }
    
    
    
    func notifySend()
    {
        if(mNotify != nil)
        {
            if(mNotify.respondsToSelector((Selector("notifyObject:"))))
            {
                mNotify.performSelector(Selector("notifyObject:"),
                    onThread: NSThread.mainThread(), withObject: self, waitUntilDone: true)
            }
        }
    }
    
    func baseInitialize(){self.mkchk();}
    func initialize(){}
    
    func baseUpdate()
    {
        
        
    //    self.update();
    
    }
    func update(){}
    
    func allowAction() -> Bool
    {
        if((mAnimatingIn == true) || (mAnimatingOut == true))
        {
            return false;
        }
        return true;
    }
    
    func buttonClick(pButton:DIButtonView!)
    {
        
    }
    
    func sliderMove(pSlider:DISliderView!)
    {
        
    }
    
    
    override func addSubview(view: UIView)
    {
        super.addSubview(view)
        
        if(view.isKindOfClass(DIView) == true)
        {
            let aView:DIView = view as! DIView
            aView.mParent = self;
            if((view.frame.size.width > 0) && (view.frame.size.height > 0)){aView.mkchk();}
        }
    }
    
    func add(pViewController:UIViewController!)
    {
        if(pViewController != nil)
        {
            pViewController.view.frame = CGRect(x: pViewController.view.frame.origin.x, y: pViewController.view.frame.origin.y, width: pViewController.view.frame.size.width, height: pViewController.view.frame.size.height)
            
            if(pViewController.view != nil){self.addSubview(pViewController.view)}
            if((pViewController.view.frame.size.width > 0) && (pViewController.view.frame.size.height > 0))
            {
                if(pViewController.isKindOfClass(DIViewController) == true)
                {
                    let aViewController:DIViewController = (pViewController as! DIViewController)
                    aViewController.mkchk();
                }
            }
        }
    }
    
    
    
    func setRect(pRect:CGRect)
    {
        if((pRect.origin.x != mX) || (pRect.origin.y != mY) || (pRect.size.width != mW) || (pRect.size.height != mH) || (mRectSet == false))
        {
            mRectSet = true
            self.frame = CGRect(x: pRect.origin.x, y: pRect.origin.y, width: pRect.size.width, height: pRect.size.height);
            
            self.internalAdjustContent()
            if((mDidMake == true) && (mDidSpawn == true))
            {
                self.adjustContent();
            }
        }
        else{self.internalAdjustContent();}
    }
    
    func setX(pX:CGFloat){self.setRect(CGRect(x: pX, y: mY, width: mW, height: mH));}
    func setY(pY:CGFloat){self.setRect(CGRect(x: mX, y: pY, width: mW, height: mH));}
    func setWidth(pWidth:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: pWidth, height: mH));}
    func setHeight(pHeight:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: mW, height: pHeight));}

    func updateStart(){gDS.registerUpdate(node:self.getNode());}
    func updateStop(){gDS.removeUpdate(node: self.getNode());}
    
    
    
    func renderToImage(view pView:DIView) -> UIImage
    {
        
        let window: UIWindow! = UIApplication.sharedApplication().keyWindow
        
        return window.capture();
        
        /*
        UIGraphicsBeginImageContextWithOptions(pView.frame.size, self.opaque, 0.0)
        window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
        */
        
        
        /*
        let windowImage = window.capture()
        
        
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        CGRect rect = [keyWindow bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [keyWindow.layer renderInContext:context];
        UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        This code capture a UIView in native resolution
        
        CGRect rect = [captureView bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [captureView.layer renderInContext:context];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
*/
        
        /*
        UIGraphicsBeginImageContextWithOptions(pView.bounds.size, false, UIScreen.mainScreen().scale)
        pView.drawViewHierarchyInRect(pView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        */
    }
    
    func toImage() -> UIImage
    {
        return self.renderToImage(view: self);
        
        /*
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        */
    }
    
    
    /*
    
    func bubbleLayoutRequired(pView:UIView!) -> DIView!
    {
        if(pView != nil)
        {
            var aCheck:DIView! = nil
            var aView:DIView! = nil
            
            if(pView.superview != nil)
            {
                aCheck = self.bubbleLayoutRequired(pView.superview)
            }
            
            if(pView.isKindOfClass(DIView))
            {
                aView = (pView as! DIView)
                
                if(aView.mLayoutFlag == true)
                {
                    aView.mLayoutFlag = false
                    
                    if(aCheck != nil)
                    {return aCheck;}
                    else{return aView;}
                    
                }
                else{aView = nil;}
            }
            else{if(aCheck != nil){return aCheck;}}
        }
        
        return nil
    }
    
    
   
    
    func layoutRequired()
    {
        if(mLayoutFlag == false)
        {
            gDS.layoutView(self)
            self.mLayoutFlag = true
        }
        self.mLayoutRequired = true
    }
    
    func sweepLayoutDepth(pView:UIView!, pDepth:Int) -> Int
    {
        var aReturn:Int = -1
        
        if(pView != nil)
        {
            var aCheckDepth:Int = -1
            
            if(pView.isKindOfClass(DIView))
            {
                let aView:DIView! = (pView as! DIView)
                
                aView.mLayoutDepth = pDepth
                aReturn = pDepth
            }
            
            for var aIndex:Int=0; aIndex<pView.subviews.count; aIndex++
            {
                aCheckDepth = self.sweepLayoutDepth(pView.subviews[aIndex], pDepth: (pDepth + 1))
                
                if(aCheckDepth != -1)
                {
                    if(aCheckDepth > aReturn)
                    {
                        aReturn = aCheckDepth
                    }
                }
            }
        }
        
        return aReturn
    }
    
    func sweepLayoutDepth(pDepth:Int) -> Int{return self.sweepLayoutDepth(self, pDepth: pDepth)}
    
    func sweepLayout(pView:UIView!, pDepth:Int)
    {
        if(pView != nil)
        {
            if(pView.isKindOfClass(DIView))
            {
                let aView:DIView! = (pView as! DIView)
                
                if(aView.mLayoutDepth == pDepth)
                {
                    aView.basePlace()
                    aView.mLayoutRequired = false
                    aView.mLayoutFlag = false
                }
            }
            
            for var aIndex:Int=0; aIndex<pView.subviews.count; aIndex++
            {
                self.sweepLayout(pView.subviews[aIndex], pDepth: (pDepth + 1))
            }
        }
    }
    
    func sweepLayout(pDepth:Int)
    {
        for var aIndex:Int=pDepth; aIndex>=0; aIndex--
        {
            self.sweepLayout(self, pDepth: pDepth)
        }}
    */
    
    func sizeFullScreen()
    {
        self.setRect(CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
    }
    
    func sizeFullScreenInset(pInset:CGFloat)
    {
        self.setRect(CGRectMake(pInset, pInset, gDS.appWidth - pInset * 2.0, gDS.appHeight - pInset * 2.0))
    }
    
    func centerRect(pRect:CGRect) -> CGRect
    {
        return CGRectMake(mW2 - (pRect.size.width / 2.0), mH2 - (pRect.size.height / 2.0), pRect.size.width, pRect.size.height);
    }
    
    func log()
    {
        print("View (\(gDS.getName(obj: self)) => [\(self.frame.origin.x), \(self.frame.origin.y)] (\(self.frame.size.width) x \(self.frame.size.height)")
    }
    
    func testBG()
    {
        self.backgroundColor = UIColor(red: 0.45 + gRnd.f(min: 0.0, max: 0.3), green: 0.45 + gRnd.f(min: 0.0, max: 0.3), blue: 0.45 + gRnd.f(min: 0.0, max: 0.3), alpha: gRnd.f(min: 0.25, max: 0.45))
    }
    
    func didFinishTransitionIn()
    {
        
    }
    
    
    
    func animateInComplete()
    {
        
    }
    
    func animateOutComplete()
    {
        
    }
    
    func setAnimationStateIn()
    {
        self.alpha = 1.0;
    }
    
    func setAnimationStateOut()
    {
        self.alpha = 0.0;
    }
    
    func animateInDelayed(time pTime:CGFloat, del pDelay:CGFloat)
    {
        self.mAnimatingIn = true;
        self.mAnimatingOut = false;
        self.setAnimationStateOut();
        UIView.animateWithDuration(Double(pTime), delay: Double(pDelay), options: UIViewAnimationOptions.TransitionNone , animations:{self.setAnimationStateIn();}, completion: {(value: Bool) in
                self.mAnimatingIn = false;
                self.animateInComplete();
        })
        
    }
    
    func animateOutDelayed(time pTime:CGFloat, del pDelay:CGFloat)
    {
        self.mAnimatingIn = false;
        self.mAnimatingOut = true;
        self.setAnimationStateIn();
        UIView.animateWithDuration(Double(pTime), delay: Double(pDelay), options: UIViewAnimationOptions.TransitionNone , animations:{self.setAnimationStateOut();},completion:{(value: Bool) in
            self.mAnimatingOut = false;
            self.animateOutComplete();
        })
    }
    
    func animateIn(time pTime:CGFloat)
    {
        self.animateInDelayed(time: pTime, del: 0.0);
    }
    
    func animateOut(time pTime:CGFloat)
    {
        self.animateOutDelayed(time: pTime, del: 0.0);
    }
    
    func animateIn()
    {
        self.animateIn(time:0.42)
    }
    
    func animateOut()
    {
        self.animateOut(time:0.42)
    }
    
    
    func spawnController() -> DIViewController
    {
        let aViewController:DIViewController = DIViewController(view: self);
        return aViewController;
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
            self.userInteractionEnabled = false
            self.updateStop()
            
            
            
            gDS.registerDestroy(node: self.getNode());
            self.layer.removeAllAnimations();
            self.removeFromSuperview()
        }
    }
}



