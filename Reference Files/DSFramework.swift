//
//  DSFramework.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

struct gMath
{
    static let PI:CGFloat = 3.1415926535897932384626433832795028841968;
    static let PI2:CGFloat = (2 * PI);
    static let PI_2:CGFloat = (PI / 2);
    static let D_R:CGFloat = 0.01745329251994329576923690768488;
    static let R_D:CGFloat = 57.2957795130823208767981548141052;
}

class DSFramework : NSObject
{
    var deviceWidth:CGFloat = 320.0;
    var deviceHeight:CGFloat = 480.0;
    
    var appWidth:CGFloat = 320.0;
    var appHeight:CGFloat = 480.0;
    
    var enableDebug:Bool = false;
    var enableLogging:Bool = true;
    
    
    var mUpdating:Bool = true;
    
    var updateTimer: NSTimer! = nil;
    var mNewViews:NSMutableArray = NSMutableArray(capacity: 256);
    var mNewViewControllers:NSMutableArray = NSMutableArray(capacity: 256);
    
    var mNodes:NSMutableArray = NSMutableArray(capacity: 2048);
    var mUpdateNodes:NSMutableArray = NSMutableArray(capacity: 512);
    var mNewNodes:NSMutableArray = NSMutableArray(capacity: 256);
    var mUpdateQueueNodes:NSMutableArray = NSMutableArray(capacity: 256);
    
    var mDestroyQueueNodes:NSMutableArray = NSMutableArray(capacity: 512);
    var mDestroyNodes:NSMutableArray = NSMutableArray(capacity: 512);
    
    func basePreinitialize(){}
    func baseInitialize()
    {
        if(updateTimer != nil){updateTimer.invalidate();}
        self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
        NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    }
    
    func isTablet() -> Bool
    {
        if(deviceWidth >= 760.0){return true}
        else {return false}
    }
    
    func getOSVersion() -> CGFloat
    {
        return 7.0
        //if(deviceWidth >= 760.0){return true}
        //else {return false}
    }
    
    func getStatusBarHeight() -> CGFloat
    {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    
    func updateLayout()
    {
        /*
        var aView:DIView! = nil
        var aReloop:Bool = true
        
        var aLoops:Int = 0
        
        while(aReloop == true)
        {
        
        aReloop = false
        
        if(mLayoutViewsNext.count > 0){aReloop = true}
        if(mNewViews.count > 0){aReloop = true}
        
        
        if(mNewViews.count > 0)
        {
        for var aIndex:Int=0; aIndex<mNewViews.count; aIndex++
        {
        aView = (mNewViews.objectAtIndex(aIndex) as! DIView)
        aView.initialize()
        aView.mLayoutRequired = true
        aView.mLayoutFlag = true
        if(aView.mUpdate == true){aView.update();}
        mLayoutViewsNext.addObject(aView)
        }
        mNewViews.removeAllObjects()
        }
        
        
        if(mLayoutViewsNext.count > 0)
        {
        for var aIndex:Int=0; aIndex<mLayoutViewsNext.count; aIndex++
        {
        aView = (mLayoutViewsNext.objectAtIndex(aIndex) as! DIView)
        aView.mLayoutRequired = true
        aView.mLayoutFlag = true
        mLayoutViews.addObject(aView)
        }
        mLayoutViewsNext.removeAllObjects()
        }
        
        if(mLayoutViewsNext.count > 0){aReloop = true}
        if(mNewViews.count > 0){aReloop = true}
        
        aLoops++
        
        }
        
        if(mLayoutViews.count > 0)
        {
        for var aIndex:Int=0; aIndex<mLayoutViews.count; aIndex++
        {
        aView = (mLayoutViews.objectAtIndex(aIndex) as! DIView)
        aView.mLayoutFlag = true
        aView.mLayoutRequired = true
        
        }
        }
        
        
        if(mLayoutViews.count > 0)
        {
        for var aIndex:Int=0; aIndex<mLayoutViews.count; aIndex++
        {
        aView = (mLayoutViews.objectAtIndex(aIndex) as! DIView)
        
        let aTopView:DIView! = aView.bubbleLayoutRequired(aView)
        
        if(aTopView != nil){mLayoutFinalViews.addObject(aTopView)}
        
        mLayoutViewsDequeue.addObject(aView)
        }
        
        mLayoutViews.removeAllObjects()
        
        }
        
        if(mLayoutFinalViews.count > 0)
        {
        for var aIndex:Int=0; aIndex<mLayoutFinalViews.count; aIndex++
        {
        aView = (mLayoutFinalViews.objectAtIndex(aIndex) as! DIView)
        
        let aDepth:Int = aView.sweepLayoutDepth(0)
        
        aView.sweepLayoutDepth(aView, pDepth: aDepth + 1)
        }
        mLayoutFinalViews.removeAllObjects()
        }
        */
        
    }
    
    func update()
    {
        mUpdating = true
        
        self.updateLayout()
        
        
        var aNode:DINode! = nil;
        
        if(mNewViewControllers.count > 0)
        {
            for var aIndex:Int=0; aIndex<mNewViewControllers.count; aIndex++
            {
                let aVC:DIViewController! = (mNewViewControllers.objectAtIndex(aIndex) as! DIViewController)
                
                if(aVC.mView != nil)
                {
                    if(aVC.mView.mNode != nil)
                    {
                        
                        
                    }
                }
                
                aNode = aVC.getNode();
                if(aNode != nil){if(mNewNodes.containsObject(aNode) == false){mNewNodes.addObject(aNode);}}
            }
            mNewViewControllers.removeAllObjects()
            
        }
        if(mNewViews.count > 0)
        {
            for var aIndex:Int=0; aIndex<mNewViews.count; aIndex++
            {
                let aView:DIView! = (mNewViews.objectAtIndex(aIndex) as! DIView);
                aNode = aView.getNode();
                if(aNode != nil){if(mNewNodes.containsObject(aNode) == false){mNewNodes.addObject(aNode);}}
            }
            mNewViews.removeAllObjects();
        }
        
        if(mNewNodes.count > 0)
        {
            for var aIndex:Int=0; aIndex<mNewNodes.count; aIndex++
            {
                aNode = (mNewNodes.objectAtIndex(aIndex) as! DINode);
                aNode.baseInitialize();
            }
            
            for var aIndex:Int=0; aIndex<mNewNodes.count; aIndex++
            {
                aNode = (mNewNodes.objectAtIndex(aIndex) as! DINode);
                aNode.initialize();
            }
            
            for var aIndex:Int=0; aIndex<mNewNodes.count; aIndex++
            {
                aNode = (mNewNodes.objectAtIndex(aIndex) as! DINode);
                mNodes.addObject(aNode);
            }
            mNewNodes.removeAllObjects();
        }
        
        if(mUpdateQueueNodes.count > 0)
        {
            for var aIndex:Int=0; aIndex<mUpdateQueueNodes.count; aIndex++
            {
                mUpdateNodes.addObject((mUpdateQueueNodes.objectAtIndex(aIndex) as! DINode));
            }
            mUpdateQueueNodes.removeAllObjects()
        }
        
        
        
        
        //for var aIndex:Int = 0; aIndex < mUpdateViews.count; aIndex++
        //{
        //    aView = (mUpdateViews.objectAtIndex(aIndex) as! DIView)
        //    if(aView.mUpdateAllowed == true){aView.update();}
        //}
        
        
        for var aIndex:Int = 0; aIndex < mUpdateNodes.count; aIndex++
        {
            aNode = (mUpdateNodes.objectAtIndex(aIndex) as! DINode);
            aNode.update();
        }
        
        
        if(mDestroyQueueNodes.count > 0)
        {
            for var aIndex:Int=0; aIndex<mDestroyQueueNodes.count; aIndex++
            {
                aNode = (mDestroyQueueNodes.objectAtIndex(aIndex) as! DINode);
                aNode.mDestroyTick--;
                
                if(aNode.mDestroyTick == 2)
                {
                    mNodes.removeObject(aNode);
                
                    
                    //print("DESTROY:");
                    //aNode.log();
                    
                }
                if(aNode.mDestroyTick <= 0){mDestroyNodes.addObject(aNode);}
            }
        }
        
        if(mDestroyNodes.count > 0)
        {
            for var aIndex:Int=0; aIndex<mDestroyNodes.count; aIndex++
            {
                aNode = (mDestroyNodes.objectAtIndex(aIndex) as! DINode);
                mDestroyQueueNodes.removeObject(aNode);
            }
            mDestroyNodes.removeAllObjects()
        }
        
        /*
        mNewViews:NSMutableArray
        mNewViewsLoop:NSMutableArray
        mLayoutViews:NSMutableArray
        mUpdateViewsQueue:NSMutableArray
        :NSMutableArray
        
        mNewViewControllers:NSMutableArray
        mNewViewControllersLoop:NSMutableArray
        mLayoutViewControllers:NSMutableArray
        
        updateViewControllersQueue:NSMutableArray
        
        destroyViewControllers:NSMutableArray
        mKillViewControllers:NSMutableArray
        */
        
        mUpdating = false
    }
    
    
    
    func objectsEqual(pObj1:AnyObject, pObj2:AnyObject) -> Bool
    {
        let aObj1:NSObject! = (pObj1 as! NSObject)
        let aObj2:NSObject! = (pObj2 as! NSObject)
        if(aObj1 == aObj2){return true;}
        else {return false;}
    }
    
    func registerNew(view pView: DIView!){mNewViews.addObject(pView);}
    
    func registerNew(vc pViewController: DIViewController!){mNewViewControllers.addObject(pViewController);}
    
    func registerUpdate(node pNode: DINode!)
    {
        if(pNode != nil)
        {
            if(pNode.mUpdate == false)
            {
                pNode.mUpdate = true;
                mUpdateQueueNodes.addObject(pNode);
            }
        }
    }
    
    func removeUpdate(node pNode: DINode!)
    {
        if(pNode != nil)
        {
            if(pNode.mUpdate == true)
            {
                pNode.mUpdate = false;
                if(mUpdateQueueNodes.containsObject(pNode)){mUpdateQueueNodes.removeObject(pNode);}
                if(mUpdateNodes.containsObject(pNode)){mUpdateNodes.removeObject(pNode);}
            }
        }
    }
    func registerDestroy(node pNode: DINode!)
    {
        if(pNode != nil)
        {
            if(pNode.mDestroy == false)
            {
                pNode.destroy();
                mDestroyQueueNodes.addObject(pNode);
            }
        }
    }
    
    
    func bubbleReset(node pNode: DINode!)
    {
        
    }
    
    func bubbleReset()
    {
        if(mNodes.count > 0)
        {
            var aNode:DINode! = nil;
            for var aIndex:Int = 0; aIndex < mNodes.count; aIndex++
            {
                aNode = (mNodes.objectAtIndex(aIndex) as! DINode);
                aNode.mBubbleCheck = true;
                aNode.mBubbleFlag = false;
            }
        }
    }
    
    func bubbleProbe()
    {
        if(mNodes.count > 0)
        {
            var aNode:DINode! = nil;
            for var aIndex:Int = 0; aIndex < mNodes.count; aIndex++
            {
                aNode = (mNodes.objectAtIndex(aIndex) as! DINode);
                //aNode.update();
                
                
            }
        }
    }
    
    
    //
    //    func registerNewVC(pView: DIViewController!){if(pView != nil){mNewVCs.addObject(pView)}}
    //    func registerUpdateVC(pView: DIViewController){if(pView.mUpdate == false){pView.mUpdate = true;mUpdateVCQueue.addObject(pView);}}
    //    func removeUpdateVC(pView: DIViewController)
    //    {
    //        if(pView.mUpdate == true)
    //        {
    //            pView.mUpdate = false;
    //            if(mUpdateVCQueue.containsObject(pView)){mUpdateVCQueue.removeObject(pView);}
    //            if(mUpdateVCs.containsObject(pView)){mUpdateVCs.removeObject(pView);}
    //        }
    //    }
    //    func destroyVC(pView: DIViewController!)
    //    {
    //        if(pView != nil)
    //        {
    //            if(pView.mDestroy == false){pView.mDestroy = true;mDestroyVCs.addObject(pView);}
    //        }
    //    }
    
    
    class var shared: DSFramework
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSFramework? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSFramework()}
        return Static.cInstance!
    }
    
    
    override init()
    {
        super.init();
    }
    
    func networkConnected() -> Bool
    {
        //var aNetworkReachability:Reachability = Reach
        
        /*
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        } else {
        NSLog(@"There IS internet connection");
        }
        */
        
        return true
    }
    
    func clr(pRed:CGFloat, _ pGreen:CGFloat, _ pBlue:CGFloat, _ pAlpha:CGFloat) -> UIColor
    {
        return UIColor(red: pRed, green: pGreen, blue: pBlue, alpha: pAlpha);
    }
    
    func getRoot() -> UIViewController!
    {
        let appDelegate:UIApplicationDelegate!  = UIApplication.sharedApplication().delegate!;
        let viewController:UIViewController = UIApplication.sharedApplication().delegate!.window!!.rootViewController!
        return viewController
    }
    
    func setDeviceSize(pWidth: CGFloat, pHeight: CGFloat)
    {
        deviceWidth = pWidth;
        deviceHeight = pHeight;
        appWidth = deviceWidth;
        appHeight = deviceHeight;
    }
    
    
    
    
    
    func getRectAspectFit(frame pFrame:CGRect, size pSize:CGSize, border pBorder:CGFloat) -> CGRect
    {
        var aScale:CGFloat = 1.0

        let aObjectWidth:CGFloat = pSize.width;
        let aObjectHeight:CGFloat = pSize.height;
        
        let aProperWidth:CGFloat = pFrame.size.width - pBorder * 2.0;
        let aProperHeight:CGFloat = pFrame.size.height - pBorder * 2.0;
        
        var aWidth:CGFloat = aProperWidth
        var aHeight:CGFloat = aProperHeight
        
        if(aObjectWidth > 0 && aObjectHeight > 0 && aProperWidth > 0 && aProperHeight > 0)
        {
            if((pSize.width / pSize.height) > (aProperWidth / aProperHeight))
            {
                aScale = aProperWidth / aObjectWidth;
                aWidth = aObjectWidth * aScale;
                aHeight = aObjectHeight * aScale;
                
            }
            else
            {
                aScale = aProperHeight / aObjectHeight;
                aWidth = aObjectWidth * aScale;
                aHeight = aObjectHeight * aScale;
            }
        }
        
        let aX:CGFloat = (pFrame.origin.x + pFrame.size.width / 2.0) - aWidth / 2.0;
        let aY:CGFloat = (pFrame.origin.y + pFrame.size.height / 2.0) - aHeight / 2.0;
        
        return CGRectMake(aX, aY, aWidth, aHeight);
    }
    
    
    func getRectAspectFill(frame pFrame:CGRect, size pSize:CGSize, border pBorder:CGFloat) -> CGRect
    {
        var aScale:CGFloat = 1.0
        
        let aObjectWidth:CGFloat = pSize.width;
        let aObjectHeight:CGFloat = pSize.height;
        
        let aProperWidth:CGFloat = pFrame.size.width - pBorder * 2.0;
        let aProperHeight:CGFloat = pFrame.size.height - pBorder * 2.0;
        
        var aWidth:CGFloat = aProperWidth
        var aHeight:CGFloat = aProperHeight
        
        if(aObjectWidth > 0 && aObjectHeight > 0 && aProperWidth > 0 && aProperHeight > 0)
        {
            if((pSize.width / pSize.height) < (aProperWidth / aProperHeight))
            {
                aScale = aProperWidth / aObjectWidth;
                aWidth = aObjectWidth * aScale;
                aHeight = aObjectHeight * aScale;
            }
            else
            {
                aScale = aProperHeight / aObjectHeight;
                aWidth = aObjectWidth * aScale;
                aHeight = aObjectHeight * aScale;
            }
        }
        
        let aX:CGFloat = (pFrame.origin.x + pFrame.size.width / 2.0) - aWidth / 2.0;
        let aY:CGFloat = (pFrame.origin.y + pFrame.size.height / 2.0) - aHeight / 2.0;
        
        return CGRectMake(aX, aY, aWidth, aHeight);
        
    }
    
    
    func getRectAspectFitScale(frame pFrame:CGRect, size pSize:CGSize, border pBorder:CGFloat) -> CGFloat
    {
        var aScale:CGFloat = 1.0
        
        let aObjectWidth:CGFloat = pSize.width;
        let aObjectHeight:CGFloat = pSize.height;
        
        let aProperWidth:CGFloat = pFrame.size.width - pBorder * 2.0;
        let aProperHeight:CGFloat = pFrame.size.height - pBorder * 2.0;
        
        if(aObjectWidth > 0 && aObjectHeight > 0 && aProperWidth > 0 && aProperHeight > 0)
        {
            if((pSize.width / pSize.height) > (aProperWidth / aProperHeight))
            {
                aScale = aProperWidth / aObjectWidth;
                
            }
            else{aScale = aProperHeight / aObjectHeight;}
        }
        
        return aScale
    }
    
    func getRectAspectFillScale(frame pFrame:CGRect, size pSize:CGSize, border pBorder:CGFloat) -> CGFloat
    {
        var aScale:CGFloat = 1.0
        
        let aObjectWidth:CGFloat = pSize.width;
        let aObjectHeight:CGFloat = pSize.height;
        let aProperWidth:CGFloat = pFrame.size.width - pBorder * 2.0;
        let aProperHeight:CGFloat = pFrame.size.height - pBorder * 2.0;
        if(aObjectWidth > 0 && aObjectHeight > 0 && aProperWidth > 0 && aProperHeight > 0)
        {
            if((pSize.width / pSize.height) < (aProperWidth / aProperHeight))
            {
                aScale = aProperWidth / aObjectWidth;
            }
            else
            {
                aScale = aProperHeight / aObjectHeight;
            }
        }
        return aScale;
    }
    
    //class
    func getName(obj pObj: Any) -> String
    {
        
        //let typeLongName = _stdlib_getDemangledTypeName(pObj)
        //let tokens = split(typeLongName, { $0 == "." })
        //if let typeName = tokens.last {
        //    println("Variable \(variable) is of Type \(typeName).")
        //}
        
        
        return String(pObj.dynamicType);
        //return (self.dynamicType).componentsSeparatedByString(".").last!
        
        //prints more readable results for dictionaries, arrays, Int, etc
        //return _stdlib_getDemangledTypeName(pObj)//.componentsSeparatedByString(".").last!
    }
    
    
}

let gDS:DSFramework = DSFramework.shared;


