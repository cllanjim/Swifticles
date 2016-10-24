//
//  ToolRowAccessoryBottomEdit.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowAccessoryBottomEdit: ToolRow
{
    
    @IBInspectable @IBOutlet weak var buttonAddBlob:TBButton! {
        didSet {
            buttonAddBlob.setImages(path: "tb_btn_new_blob", pathSelected: "tb_btn_new_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonDeleteBlob:TBButton! {
        didSet {
            buttonDeleteBlob.setImages(path: "tb_btn_new_blob", pathSelected: "tb_btn_new_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonCloneBlob:TBButton! {
        didSet {
            buttonCloneBlob.setImages(path: "tb_btn_new_blob", pathSelected: "tb_btn_new_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonResetZoom:TBButton! {
        didSet {
            buttonResetZoom.setImages(path: "tb_btn_new_blob", pathSelected: "tb_btn_new_blob_down")
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
        
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
}
