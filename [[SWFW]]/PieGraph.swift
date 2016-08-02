//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class PieGraph : DIView
{
    var circleBackground:DDCircle!;
    
    var circleGreen:DDCircle!;
    var circleYellow:DDCircle!;
    var circleRed:DDCircle!;
    
    
    var spanStartGreen:CGFloat = 10.0
    var spanStartYellow:CGFloat = 10.0
    var spanStartRed:CGFloat = 10.0
    
    var spanEndGreen:CGFloat = 220.0
    var spanEndYellow:CGFloat = 170.0
    var spanEndRed:CGFloat = 80.0
    
    
    var spanStart:CGFloat = -42.0
    var spanPercent:CGFloat = 0.0
    
    
    //var radiusStart:CGFloat = 10.0
    
    
    var buttonClick:UIButton!
    
    var buttonClickFade:CGFloat = 0.0
    var buttonClickFadePrevious:CGFloat = 0.0
    
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect)
    {
        super.init(frame: frame);

        
        
        let aRadiusOuter:CGFloat = 136.0
        let aRadiusInner:CGFloat = 42.0
        //var aStartAngle:CGFloat = -45.0
        
        
        self.circleBackground = DDCircle(pCenter: CGPointMake(mW2, mH2), pRadius: mW2);
        self.circleGreen = DDCircle(pCenter: CGPointMake(mW2, mH2), pRadius: mW2);
        self.circleRed = DDCircle(pCenter: CGPointMake(mW2, mH2), pRadius: mW2);
        self.circleYellow = DDCircle(pCenter: CGPointMake(mW2, mH2), pRadius: mW2);
        
        self.addSubview(circleBackground)
        
        self.addSubview(circleGreen)
        self.addSubview(circleYellow)
        self.addSubview(circleRed)
        
        circleBackground.mRadius = aRadiusOuter + 16.0;
        circleBackground.mFillColor = UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 0.7)
        circleBackground.mStrokeColor = UIColor(red: 0.02, green: 0.04, blue: 0.3, alpha: 1.0)
        circleBackground.mStrokeWidth = 8.0
        
        //circleBackground.mInnerRadius = aRadiusInner;
        
        
        circleGreen.mRadius = aRadiusOuter - 10.0;
        circleGreen.mInnerRadius = aRadiusInner;
        circleGreen.mAngleStart = spanStart;
        circleGreen.mAngleEnd = spanStart + spanStartGreen;
        circleGreen.mStrokeWidth = 3.0
        circleGreen.mStrokeColor = UIColor.blackColor()
        circleGreen.mFillColor = UIColor(red: 0.014, green: 0.92, blue: 0.04, alpha: 1.0)
        
        circleYellow.mRadius = aRadiusOuter - 5.0;
        circleYellow.mInnerRadius = aRadiusInner;
        circleYellow.mAngleStart = spanStart;
        circleYellow.mAngleEnd = spanStart + spanStartYellow;
        circleYellow.mStrokeWidth = 3.0
        circleYellow.mStrokeColor = UIColor.blackColor()
        circleYellow.mFillColor = UIColor(red: 0.98, green: 0.95, blue: 0.3, alpha: 1.0)
        
        
        circleRed.mRadius = aRadiusOuter;
        circleRed.mInnerRadius = aRadiusInner;
        circleRed.mAngleStart = spanStart;
        circleRed.mAngleEnd = spanStart + spanStartRed;
        circleRed.mStrokeWidth = 3.0
        circleRed.mStrokeColor = UIColor.blackColor()
        circleRed.mFillColor = UIColor(red: 0.8, green: 0.04, blue: 0.1, alpha: 1.0)
        
        self.updateStart()
    }
    
    override func update()
    {
        super.update()

        spanPercent += 0.0076
        if(spanPercent >= 1.6)
        {
            spanPercent = 0.0
        }
        
        
        var aPercent:CGFloat = spanPercent
        if(aPercent > 1.0){aPercent = 1.0}
        
        
        //aPercent = -cos(aPercent * gMath.PI_2) + 1.0;
        
        aPercent = sin(aPercent * gMath.PI_2);
        
        
        let aStartAngle:CGFloat = spanStart + aPercent * 40.0
        
        
        circleRed.mAngleStart = aStartAngle;
        circleYellow.mAngleStart = aStartAngle;
        circleGreen.mAngleStart = aStartAngle;
        
        circleRed.mAngleEnd = (aStartAngle + spanStartRed) + (aPercent * spanEndRed);
        circleYellow.mAngleEnd = (aStartAngle + spanStartYellow) + (aPercent * spanEndYellow);
        circleGreen.mAngleEnd = (aStartAngle + spanStartGreen) + (aPercent * spanEndGreen);
        
        circleGreen.refresh()
        circleYellow.refresh()
        circleRed.refresh()
        
        
    }
    
    @IBAction func click(pButton:UIButton!)
    {
        let aRand1:CGFloat = gRnd.getFloat(min: 100.0, max: 400.0)
        let aRand2:CGFloat = gRnd.getFloat(min: 100.0, max: 400.0)
        
        print("CLICK\(aRand1) - \(aRand2) ..!")
    }
    
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            buttonClick.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
            
            super.destroy()
        }
    }
}



