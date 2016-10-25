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
            buttonResetZoom.setImages(path: "tb_btn_reset_zoom", pathSelected: "tb_btn_reset_zoom_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonUndoAlt:TBButton! {
        didSet {
            buttonUndoAlt.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var checkboxZoomMode: TBCheckBox! {
        didSet {
            checkboxZoomMode.delegate = self
            checkboxZoomMode.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    override func setUp() {
        if ApplicationController.shared.isSceneLandscape {
            buttonUndoAlt.isHidden = true
        }
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
        
        updateHistory()
    }
    
    @IBAction func clickUndo(sender: AnyObject) {
        ToolActions.undo()
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

    func updateHistory() {
        
        if ApplicationController.shared.canUndo() {
            buttonUndoAlt.isEnabled = true
        } else {
            buttonUndoAlt.isEnabled = false
        }
        
        if ApplicationController.shared.canRedo() {
            
        } else {
            
        }
    }
    
    override func handleSceneReady() {
        super.handleSceneReady()
        
    }
    
    override func handleZoomModeChange() {
        super.handleZoomModeChange()
    }
    
    override func handleSceneModeChanged() {
        super.handleSceneModeChanged()
    }
    
    override func handleEditModeChanged() {
        super.handleEditModeChanged()
        
    }
    
    override func handleViewModeChanged() {
        super.handleViewModeChanged()
        
    }
    
    override func handleBlobSelectionChanged() {
        super.handleBlobSelectionChanged()
        
    }
    
    override func handleHistoryChanged() {
        super.handleHistoryChanged()
        
        updateHistory()
    }
    
}
