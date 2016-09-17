//
//  DDCircle.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDCircle : DIElement
{
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
        
        self.userInteractionEnabled = false
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
        //
        //...
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
    
    var mRadius:CGFloat = 10.0;
    var mDiameter:CGFloat = 20.0;
    
    var mAngleStart:CGFloat = 0.0
    var mAngleEnd:CGFloat = 360.0
    
    var mInnerRadius:CGFloat = 0.0
    var mAngleOffset:CGFloat = -90.0
    
    var mStrokeWidth:CGFloat = 0.0
    var mStrokeInset:CGFloat = 0.0
    
    @IBInspectable var mFillColor: UIColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.0);
    @IBInspectable var mStrokeColor: UIColor = UIColor(red: 0.02, green: 0.01, blue: 0.03, alpha: 1.0);
    
    var mPathFill : UIBezierPath!;
    var mPathOutline : UIBezierPath!;
    var mPathOutlineInner : UIBezierPath!;
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    init(pCenter:CGPoint, pRadius:CGFloat)
    {
        let aDiameter:CGFloat = (pRadius * 2.0)
        super.init(frame:CGRectMake(pCenter.x - pRadius, pCenter.y - pRadius, aDiameter, aDiameter))
        
        mRadius = pRadius;
        mDiameter = aDiameter;
    }
    
    
    override func setRect(pRect:CGRect)
    {
        super.setRect(pRect)
        
        mDiameter = pRect.size.width
        if(pRect.size.height < pRect.size.width){mDiameter = pRect.size.height}
        
        mRadius = (mDiameter * 0.5)
        
        //mCX = mW2
        //mCY = mH2
        

        refresh()
    }
    
    func refresh()
    {
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect)
    {
        var aClosed:Bool = false;
        var aInner:Bool = false;
        
        var aStartAngle:CGFloat = mAngleStart;
        var aEndAngle:CGFloat = mAngleEnd;
        
        if((mAngleEnd >= 360.0) && (mAngleStart <= 0.0)){aClosed = true;}
        if((mAngleEnd - mAngleStart) >= 360.0){aClosed = true;}
        
        if(aClosed == false)
        {
            aStartAngle += mAngleOffset;aEndAngle += mAngleOffset;
            aStartAngle *= gMath.D_R;aEndAngle *= gMath.D_R;
        }
        
        let aCenter:CGPoint = CGPoint(x: mW2, y: mH2);
        
        if(aClosed == true)
        {
            aStartAngle = 0.0
            aEndAngle = gMath.PI2
        }
        
        self.mPathFill = nil;
        self.mPathOutline = nil;
        self.mPathOutlineInner = nil;
        
        mPathFill = UIBezierPath(arcCenter: aCenter, radius: mRadius,
            startAngle: aStartAngle, endAngle: aEndAngle, clockwise: true)
        if(mInnerRadius > 0.01)
        {
            mPathFill.addArcWithCenter(aCenter, radius: mInnerRadius,
                startAngle: aEndAngle, endAngle: aStartAngle, clockwise: false)
            mPathFill.closePath()
            aInner = true;
        }
        
        if(mStrokeWidth > 0.01)
        {
            let aOutlineShift:CGFloat = mStrokeWidth / 2.0 + mStrokeInset
            
            mPathOutline = UIBezierPath(arcCenter: aCenter, radius: (mRadius - aOutlineShift),
                startAngle: aStartAngle, endAngle: aEndAngle, clockwise: true)
            
            if(aInner == true)
            {
                if(aClosed == true)
                {
                    mPathOutlineInner = UIBezierPath(arcCenter: aCenter, radius: (mInnerRadius + aOutlineShift),
                        startAngle: aStartAngle, endAngle: aEndAngle, clockwise: true)
                }
                else
                {
                    mPathOutline.addArcWithCenter(aCenter, radius: mInnerRadius + aOutlineShift,
                        startAngle: aEndAngle, endAngle: aStartAngle, clockwise: false)
                    mPathOutline.closePath()
                }
            }
        }
        
        if((aInner == false) && (aClosed == false))
        {
            if(mPathFill != nil)
            {
                mPathFill.addLineToPoint(aCenter);
                mPathFill.closePath();
            }
            if(mPathOutline != nil)
            {
                mPathOutline.addLineToPoint(aCenter);
                mPathOutline.closePath();
            }
        }
        
        if(mPathFill != 0)
        {
            mFillColor.setFill()
            mPathFill.fill();
        }
        
        if(mStrokeWidth > 0.01)
        {
            if(mPathOutline != nil)
            {
                mStrokeColor.setStroke();
                mPathOutline.lineWidth = mStrokeWidth
                mPathOutline.stroke();
            }
            if(mPathOutlineInner != nil)
            {
                mStrokeColor.setStroke();
                mPathOutlineInner.lineWidth = mStrokeWidth
                mPathOutlineInner.stroke();
            }
        }
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            if(mPathFill != nil){mPathFill.removeAllPoints();self.mPathFill = nil;}
            if(mPathOutline != nil){mPathOutline.removeAllPoints();self.mPathOutline = nil;}
            if(mPathOutlineInner != nil){mPathOutlineInner.removeAllPoints();self.mPathOutlineInner = nil;}
            super.destroy()
        }
    }
    
}
