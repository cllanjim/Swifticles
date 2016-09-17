//
//  DILabel.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/26/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

class DILabel: UILabel
{
    var mX:CGFloat = 0.0;
    var mY:CGFloat = 0.0;
    var mW:CGFloat = 0.0;
    var mH:CGFloat = 0.0;
    var mW2:CGFloat = 0.0;
    var mH2:CGFloat = 0.0;
    var mCX:CGFloat = 0.0;
    var mCY:CGFloat = 0.0;
    
    var mDestroy:Bool = false;
    var mRectSet:Bool = false
    
    required init()
    {
        super.init(frame: CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
        self.setRect(CGRectMake(0.0, 0.0, 160.0, 42.0))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.setRect(CGRectMake(0.0, 0.0, 160.0, 42.0))
    }
    
    required override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.setRect(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))
    }
    
    func mkchk(pFrame:CGRect)
    {
        //self.makeCheck(pFrame)
        if(mDidMake == false){self.make(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))}
        //self.spawnCheck()
        if(mDidSpawn == false){self.spawn()}
        
        self.mRectSet = false
        self.setRect(pFrame)
    }
    
    func mkchk()
    {
        self.mkchk(CGRectMake(mX, mY, mW, mH));
        
        //self.mkchk(CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height));
    }
    
    
    func makeSafetyCheck(){if(mDidMake == true){print("ERROR!!! Double-Make NOT ALLOWED...!");exit(0);}}
    var mDidMake:Bool = false
    func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        self.mDidMake = true;
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
    
    func add(pViewController:UIViewController!)
    {
        if(pViewController != nil)
        {
            pViewController.view.frame = CGRect(x: pViewController.view.frame.origin.x, y: pViewController.view.frame.origin.y, width: pViewController.view.frame.size.width, height: pViewController.view.frame.size.height)
            if(pViewController.view != nil){self.addSubview(pViewController.view)}
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
    
    
    
    func getHeight(str pString:String!) -> CGFloat
    {
        var aNull:Bool = true
        if(self.text != nil)
        {
            if(self.text?.characters.count > 0)
            {
                aNull = false
            }
        }
        
        if(aNull == true)
        {
            return self.font.lineHeight
        }
        else
        {
            if(cCheckLabel == nil)
            {
                cCheckLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
                cCheckLabel.numberOfLines = 0
                cCheckLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                
            }
            cCheckLabel.frame = CGRectMake(0, 0, self.frame.width, CGFloat.max)
            
            
            cCheckLabel.font = self.font
            cCheckLabel.text = pString
            cCheckLabel.sizeToFit()
            return cCheckLabel.frame.height
        }
        
        
    }
    
    func getHeight() -> CGFloat
    {
        return self.getHeight(str: self.text)
    }
    
    func setX(pX:CGFloat){self.setRect(CGRect(x: pX, y: mY, width: mW, height: mH));}
    func setY(pY:CGFloat){self.setRect(CGRect(x: mX, y: pY, width: mW, height: mH));}
    func setWidth(pWidth:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: pWidth, height: mH));}
    func setHeight(pHeight:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: mW, height: pHeight));}
    
    func destroy()
    {
        if(mDestroy == false)
        {
            mDestroy = true;
            self.layer.removeAllAnimations();
            self.removeFromSuperview()
        }
    }
}

var cCheckLabel:UILabel! = nil

