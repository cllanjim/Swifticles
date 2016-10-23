//
//  ToolRowBottomEdit.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowBottomEdit: ToolRow
{
    
    @IBInspectable @IBOutlet weak var segEditMode:TBSegment! {
        didSet {
            segEditMode.segmentCount = 3
            segEditMode.delegate = self
            segEditMode.setImage(index: 0, path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
            segEditMode.setImage(index: 1, path: "tb_seg_view", pathSelected: "tb_seg_view_selected")
            segEditMode.setImage(index: 2, path: "tb_seg_view", pathSelected: "tb_seg_view_selected")
            segEditMode.selectedIndex = 0
        }
    }
    
    @IBInspectable @IBOutlet weak var checkboxZoomMode: TBCheckBox! {
        didSet {
            checkboxZoomMode.delegate = self
            checkboxZoomMode.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func refreshUI() {
        super.refreshUI()
        
        if ApplicationController.shared.editMode == .distribution {
            segEditMode.selectedIndex = 2
        } else if ApplicationController.shared.editMode == .shape {
            segEditMode.selectedIndex = 1
        } else {
            segEditMode.selectedIndex = 0
        }
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
        if segment === segEditMode {
            if segEditMode.selectedIndex == 2 {
                ApplicationController.shared.editMode = .distribution
            } else if segEditMode.selectedIndex == 1 {
                ApplicationController.shared.editMode = .shape
            } else {
                ApplicationController.shared.editMode = .affine
            }
        }
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
}
