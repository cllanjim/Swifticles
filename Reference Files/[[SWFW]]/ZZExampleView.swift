//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class ZZExampleView : DIElement
{
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck();
        super.make(frame);
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck();
        super.spawn();
    }
    
    override func adjustContent()
    {
        super.adjustContent()
    }
    
    
    //override func initialize(){super.initialize()}
    //override func baseUpdate(){super.baseUpdate();self.update();}
    
    override func buttonClick(pButton:DIButtonView!){}
    override func sliderMove(pSlider:DISliderView!){}
    
    override func setAnimationStateIn(){}
    override func setAnimationStateOut(){}
    override func animateInComplete(){super.animateInComplete();}
    override func animateOutComplete(){super.animateOutComplete();}
    
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            super.destroy()
        }
    }
}



