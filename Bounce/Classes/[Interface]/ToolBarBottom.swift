//
//  ToolBarBottom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarBottom : UIView
{
    
    @IBOutlet weak var buttonExpand:TBButton! {
        didSet {
            //buttonExpand.styleSetSegment()
            
        }
    }
    
    @IBAction func clickExpand(_ sender: AnyObject) {
        ToolActions.bottomMenuToggleExpand()
    }
    
}


