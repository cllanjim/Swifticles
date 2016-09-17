//
//  DDCircle.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDShape : DIElement
{
    
    var mPointList:NSMutableArray = NSMutableArray()
    
    var mPath : UIBezierPath!;
    var mShapeLayer: CAShapeLayer!
    
    var mStrokeColor: UIColor = UIColor(red: (138.0 / 255.0), green: (190.0 / 255.0), blue: (56.0 / 255.0), alpha: 1.0)
    var mStrokeSize:CGFloat = 6.0
    var mStroke:Bool = true
    
    var mFillColor: UIColor = UIColor(red: (51.0 / 255.0), green: (42 / 255.0), blue: (134 / 255.0), alpha: 1.0)
    var mFill:Bool = true
    
    
    var mShadowColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.16, alpha: 0.34)
    var mShadowSize:CGFloat = 1.2
    var mShadowOffset:CGPoint = CGPointMake(-1.0, 2.0)
    var mShadow:Bool = true
    
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
        
        self.userInteractionEnabled = false
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        //
        //...
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        //
        //...
    }
    
    func addPoint(pPoint: CGPoint)
    {
        let aPoint:CGPoint = CGPointMake(pPoint.x, pPoint.y)
        let aValue:NSValue = NSValue(CGPoint: aPoint)
        mPointList.addObject(aValue)
    }
    
    override func setRect(pRect:CGRect)
    {
        super.setRect(pRect)
    }
    
    func convertX(pX: CGFloat) -> CGFloat
    {
        return pX * mW
    }
    
    func convertY(pY: CGFloat) -> CGFloat
    {
        return pY * mH
    }
    
    
    func getPoint(pIndex: Int) -> CGPoint
    {
        var aReturn:CGPoint = CGPointMake(0.0, 0.0)
        if((pIndex >= 0) && (pIndex < mPointList.count))
        {
            aReturn = (mPointList.objectAtIndex(pIndex) as! NSValue).CGPointValue()
        }
        return aReturn
    }
    
    func refresh(){self.setNeedsDisplay()}
    
    override func drawRect(rect: CGRect)
    {
        destroyPath()
        destroyShapeLayer()
        
        if(mPointList.count > 1)
        {
            self.mPath = UIBezierPath()
            
            var aPoint:CGPoint = getPoint(0)
            
            mPath.moveToPoint(CGPointMake(self.convertX(aPoint.x), self.convertY(aPoint.y)))
            
            for var aIndex:Int=1; aIndex<mPointList.count; aIndex++
            {
                aPoint = getPoint(aIndex)
                
                mPath.addLineToPoint(CGPointMake(self.convertX(aPoint.x), self.convertY(aPoint.y)))
            }
            
            self.mShapeLayer = CAShapeLayer()
            
            mShapeLayer.path = mPath.CGPath

            
            if(mStroke == true)
            {
                mShapeLayer.strokeColor = mStrokeColor.CGColor;
                mShapeLayer.lineWidth = mStrokeSize;
            }
            else
            {
                mShapeLayer.strokeColor = UIColor.clearColor().CGColor;
                mShapeLayer.lineWidth = 0.0;
            }
            
            
            if(mFill == true){mShapeLayer.fillColor = UIColor.clearColor().CGColor}
            else{mShapeLayer.fillColor = UIColor.clearColor().CGColor}

            if(mShadow == true)
            {
                mShapeLayer.shadowColor = mShadowColor.CGColor
                mShapeLayer.shadowOffset = CGSizeMake(mShadowOffset.x, mShadowOffset.y)
                mShapeLayer.shadowOpacity = 1.0
                mShapeLayer.shadowRadius = mShadowSize
            }
            else
            
            {
                mShapeLayer.shadowColor = UIColor.clearColor().CGColor
                mShapeLayer.shadowOffset = CGSizeMake(0.0, 0.0)
                mShapeLayer.shadowOpacity = 0.0
                mShapeLayer.shadowRadius = 0.0
            }
            
            
            
            
            self.layer.addSublayer(mShapeLayer)
            
            
        }
        

        //design path in layer
        
        
        /*
        
        //design the path
        var path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        //design path in layer
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        */
    }

    
    
    func destroyPath()
    {
        if(mPath != nil)
        {
            mPath.removeAllPoints()
            self.mPath = nil
            refresh()
        }
    }
    
    func destroyShapeLayer()
    {
        if(mShapeLayer != nil)
        {
            mShapeLayer.removeAllAnimations()
            mShapeLayer.removeFromSuperlayer()
            self.mShapeLayer = nil
            refresh()
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            destroyPath()
            destroyShapeLayer()
            //if(mPathFill != nil){mPathFill.removeAllPoints();self.mPathFill = nil;}
            //if(mPathOutline != nil){mPathOutline.removeAllPoints();self.mPathOutline = nil;}
            //if(mPathOutlineInner != nil){mPathOutlineInner.removeAllPoints();self.mPathOutlineInner = nil;}
            
            super.destroy()
        }
    }
    
}
