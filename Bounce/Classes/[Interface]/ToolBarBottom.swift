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
    
    @IBInspectable @IBOutlet weak var segMode:TBSegment! {
        didSet {
            segMode.segmentCount = 2
            segMode.delegate = self
        }
    }
    
    
    @IBInspectable @IBOutlet weak var buttonExpand:TBButton! {
        didSet {
            //buttonExpand.styleSetSegment()
            
        }
    }
    
    @IBAction func clickExpand(sender: AnyObject) {
        ToolActions.bottomMenuToggleExpand()
    }
    
    func segmentSelected(segment:TBSegment, index: Int) {
        print("segmentSelected[\(segment)]\nsegIndex[\(index)]")
        
        if segment === segMode {
            
            if segMode.selectedIndex == 0 {
                gApp.engine?.sceneMode = .edit
            } else {
                gApp.engine?.sceneMode = .view
            }
            
        }
        
    }
    
    func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
}

