//
//  DemoView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class ZZExampleViewController : DIViewController
{
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)}
    
    override func initialize()
    {
        super.initialize()
        //self.mName = "Example VC"
    }
    
    //override func baseUpdate(){super.baseUpdate();}
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            super.destroy()
        }
    }
    
    
}
