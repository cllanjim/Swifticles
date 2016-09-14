//
//  ToolBarBottom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarBottom : UIView, TBSegmentDelegate, TBCheckBoxDelegate
{
    
    @IBInspectable @IBOutlet weak var segmentMode: TBSegment!{
        didSet {
            segmentMode.segmentCount = 2
            segmentMode.delegate = self
        }
    }
    
    
    @IBInspectable @IBOutlet weak var buttonExpand:TBButton! {
        didSet {
            //buttonExpand.styleSetSegment()
            
        }
    }
    
    @IBAction func clickExpand(_ sender: AnyObject) {
        ToolActions.bottomMenuToggleExpand()
    }
    
    func segmentSelected(_ segment:TBSegment, index: Int) {
        print("segmentSelected[\(segment)]\nsegIndex[\(index)]")
        
    }
    
    func checkBoxToggled(_ checkBox:TBCheckBox, checked: Bool) {
        
    }
    
}

