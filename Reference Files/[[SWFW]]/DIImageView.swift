//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIImageView : DIElement
{
    var mImageView:UIImageView! = nil
    var mImage:UIImage! = nil
    var mImageName:String! = nil
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    init(path pPath:String!)
    {
        super.init()
        self.loadImage(path: pPath)
    }
    
    
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
        if(mImageView != nil){mImageView.frame = CGRectMake(0.0, 0.0, mW, mH);}
    }
    
    func loadImage(path pPath:String!) -> Bool
    {
        if(pPath != nil){if(pPath.characters.count > 0){
            
            if(gData.fileExists(pPath) == true)
            {
                self.mImageName = String(pPath)
                self.mImage = UIImage(contentsOfFile: pPath)
            }
            if(mImage == nil)
            {
                var aPath:String! = gData.getBundlePath(pPath)
                if(gData.fileExists(aPath) == true)
                {
                    self.mImageName = String(aPath)
                    self.mImage = UIImage(contentsOfFile: aPath)
                }
                else
                {
                    aPath = gData.getDocsPath(pPath)
                    if(gData.fileExists(aPath) == true)
                    {
                        self.mImageName = String(aPath)
                        self.mImage = UIImage(contentsOfFile: aPath)
                    }
                }
            }
        }}
     
        if(self.mImage != nil)
        {
            if(mImage.size.width > 0)
            {
                var aWidth:CGFloat = mImage.size.width
                var aHeight:CGFloat = mImage.size.height
                
                
                if(gDS.isTablet() == false)
                {
                    aWidth /= 2.0
                    aHeight /= 2.0
                }
                
                if((mW <= 1) || (mH <= 1))
                {
                    setRect(CGRectMake(mX, mY, aWidth, aHeight))
                }
                
                if(mImageView == nil)
                {
                    self.mImageView = UIImageView(frame: CGRectMake(0.0, 0.0, aWidth, aHeight))
                    self.addSubview(mImageView)
                }
                
                mImageView.image = mImage
                //mImageView.setNeedsDisplay()
                
                return true
            }
        }
        
        return false
    }
    
    
    
    func destroyImage()
    {
        self.mImage = nil
        if(mImageView != nil)
        {
            mImageView.image = nil
            mImageView.removeFromSuperview()
            self.mImageView = nil
        }
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            destroyImage()
            
            self.mImageName = nil
            
            super.destroy()
        }
    }
}



