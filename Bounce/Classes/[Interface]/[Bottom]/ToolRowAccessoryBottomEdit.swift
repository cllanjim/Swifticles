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
