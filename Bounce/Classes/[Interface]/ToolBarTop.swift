//
//  ToolBarTop.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarTop: UIView, TBSegmentDelegate, TBCheckBoxDelegate {
    
    @IBOutlet weak var buttonMenu: TBButton!
    @IBOutlet weak var buttonAddBlob: TBButton!
    
    @IBOutlet weak var checkBoxZoom: TBCheckBox! {
        didSet {
            checkBoxZoom.delegate = self
        }
    }
    
    @IBOutlet weak var segMode: TBSegment!{
        didSet {
            segMode.segmentCount = 2
            segMode.delegate = self
        }
    }
    
    @IBOutlet weak var segEditMode: TBSegment!{
        didSet {
            segEditMode.segmentCount = 2
            segEditMode.delegate = self
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    internal func setUp() {
        
    }
    
    @IBAction func clickMenu(_ sender: AnyObject) {
        
        ToolActions.menu()
    }
    
    @IBAction func clickAddBlob(_ sender: AnyObject) {
        
        ToolActions.addBlob()
    }
    
    func segmentSelected(segment:TBSegment, index: Int) {
        print("segmentSelected[\(segment)]\nsegIndex[\(index)]")
        
        if segment === segEditMode {
            
            if segEditMode.selectedIndex == 0 {
                gApp.engine?.editMode = .affine
            } else {
                gApp.engine?.editMode = .shape
            }
            
        }
        
    }
    
    func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
        if checkBox == checkBoxZoom {
            
            ToolActions.setZoomMode(zoomMode: checked)
        }
        
    }
    
    deinit {
        print("ToolBarTop.deinit()")
    }
    
    
}
