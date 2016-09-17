//
//  DIPageElement.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIElementVC : DIElement
{
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}

    private var viewController:DIViewController!;
    init(vc pViewController: DIViewController)
    {
        super.init(frame: CGRectMake(pViewController.view.frame.origin.x, pViewController.view.frame.origin.y,
            pViewController.view.frame.size.width, pViewController.view.frame.size.height))
        self.viewController = pViewController
        viewController.view.frame = CGRectMake(0.0, 0.0, viewController.view.frame.size.width, viewController.view.frame.size.height)
        addSubview(viewController.view)
    }
    
    override func setRect(pRect:CGRect){super.setRect(pRect)}
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            if(viewController != nil){viewController.destroy();self.viewController = nil;}
            super.destroy()
        }
    }
}



