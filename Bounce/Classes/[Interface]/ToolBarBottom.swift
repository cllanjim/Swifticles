//
//  ToolBarBottom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarBottom : ToolView, TBSegmentDelegate, TBCheckBoxDelegate
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
    
    override func handleSceneReady() {
        print("ToolBarBottom.handleSceneReady()")
        
        /*
        switch gr.state {
        case .began:
            gestureBegan(gestureTouchCenter)
            panRecognizerTouchCount = gr.numberOfTouches
            break
        case .changed:
            */
        
        switch ApplicationController.shared.sceneMode {
            case .edit :
                segMode.selectedIndex = 0
                break
            case .view:
                segMode.selectedIndex = 1
                break
            }
    }
    
    @IBAction func clickExpand(sender: AnyObject) {
        ToolActions.bottomMenuToggleExpand()
    }
    
    func segmentSelected(segment:TBSegment, index: Int) {
        print("segmentSelected[\(segment)]\nsegIndex[\(index)]")
        
        if segment === segMode {
            
            if segMode.selectedIndex == 0 {
                ApplicationController.shared.sceneMode = .edit
            } else {
                ApplicationController.shared.sceneMode = .view
            }
            
        }
        
    }
    
    func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
}

