//
//  ToolBarTop.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarTop: ToolRow {
    
    @IBInspectable @IBOutlet weak var buttonMenu:TBButton! {
        didSet {
            buttonMenu.setImages(path: "tb_btn_menu", pathSelected: "tb_btn_menu_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonMenuAlt:TBButton! {
        didSet {
            buttonMenuAlt.setImages(path: "tb_btn_menu", pathSelected: "tb_btn_menu_down")
        }
    }    
    
    @IBInspectable @IBOutlet weak var buttonExpand:TBButton! {
        didSet {
            buttonExpand.setImages(path: "tb_btn_select_next_blob", pathSelected: "tb_btn_select_next_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonExpandAlt:TBButton! {
        didSet {
            buttonExpand.setImages(path: "tb_btn_select_next_blob", pathSelected: "tb_btn_select_next_blob_down")
        }
    }
    
    override func setUp() {
        super.setUp()
        if ApplicationController.shared.isSceneLandscape {
            buttonExpandAlt.isHidden = true
            buttonMenuAlt.isHidden = true
        }
    }
    
    @IBAction func clickMenu(_ sender: AnyObject) {
        
        ToolActions.menu()
    }
    
    @IBAction func clickExpand(sender: AnyObject) {
        ToolActions.topMenuToggleExpand()
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
    deinit {
        print("ToolBarTop.deinit()")
    }
    
    
}
