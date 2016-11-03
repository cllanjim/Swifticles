//
//  ToolRowTopEdit.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowTopEdit: ToolRow
{
    
    @IBInspectable @IBOutlet weak var buttonFlipH:TBButton! {
        didSet {
            buttonFlipH.setImages(path: "tb_btn_add_blob", pathSelected: "tb_btn_add_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonFlipV:TBButton! {
        didSet {
            buttonFlipV.setImages(path: "tb_btn_add_blob", pathSelected: "tb_btn_add_blob_down")
        }
    }
    
    override func refreshUI() {
        super.refreshUI()
        
        /*
        if ApplicationController.shared.editMode == .distribution {
            segEditMode.selectedIndex = 2
        } else if ApplicationController.shared.editMode == .shape {
            segEditMode.selectedIndex = 1
        } else {
            segEditMode.selectedIndex = 0
        }
        */
        
        UIUpdateHistory()
        UIUpdateSelection()
        UIUpdateZoom()
        UIUpdateSceneMode()
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
    func UIUpdateHistory() {
        
        if ApplicationController.shared.canUndo() {
            //buttonUndoAlt.isEnabled = true
        } else {
            //buttonUndoAlt.isEnabled = false
        }
        
        if ApplicationController.shared.canRedo() {
            
        } else {
            
        }
    }
    
    func UIUpdateSelection() {
        if ApplicationController.shared.selectedBlob != nil {
            //buttonDeleteBlob.isEnabled = true
            //buttonCloneBlob.isEnabled = true
        } else {
            //buttonDeleteBlob.isEnabled = false
            //buttonCloneBlob.isEnabled = false
        }
    }
    
    func UIUpdateZoom() {
        
    }
    
    func UIUpdateSceneMode() {
        
    }
    
    override func handleSceneReady() {
        super.handleSceneReady()
        
    }
    
    override func handleZoomModeChange() {
        super.handleZoomModeChange()
        UIUpdateZoom()
    }
    
    override func handleSceneModeChanged() {
        super.handleSceneModeChanged()
        UIUpdateSceneMode()
    }
    
    override func handleEditModeChanged() {
        super.handleEditModeChanged()
        
    }
    
    override func handleViewModeChanged() {
        super.handleViewModeChanged()
        
    }
    
    override func handleBlobSelectionChanged() {
        super.handleBlobSelectionChanged()
        UIUpdateSelection()
    }
    
    override func handleHistoryChanged() {
        super.handleHistoryChanged()
        UIUpdateHistory()
    }
    
    
}

