//
//  ToolRowAccessoryBottomZoom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowAccessoryBottomZoom: ToolRow
{
    
    @IBInspectable @IBOutlet weak var checkboxZoomMode: TBCheckBox! {
        didSet {
            checkboxZoomMode.delegate = self
            checkboxZoomMode.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonResetZoom:TBButton! {
        didSet {
            buttonResetZoom.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
        }
    }
    
    override func setUp() {
        super.setUp()
        addObserver(selector: #selector(handleZoomModeChangedForced), notification: .zoomModeChangedForced)
    }
    
    override func refreshUI() {
        super.refreshUI()
        UIUpdateHistory()
        UIUpdateSelection()
        UIUpdateZoom()
        UIUpdateSceneMode()
    }
    
    func UIUpdateSelection() {
        
    }
    
    func UIUpdateHistory() {
        
    }
    
    func UIUpdateZoom() {
        checkboxZoomMode.checked = ApplicationController.shared.zoomMode
    }
    
    func UIUpdateSceneMode() {
        
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        if checkBox === checkboxZoomMode {
            ToolActions.setZoomMode(zoomMode: checkboxZoomMode.checked)
        }
    }
    
    @IBAction func clickResetZoom(sender: AnyObject) {
        if ApplicationController.shared.allowInterfaceAction() {
            ToolActions.resetZoom()
        }
    }
    
    override func handleSceneReady() {
        super.handleSceneReady()
        
    }
    
    override func handleZoomModeChanged() {
        super.handleZoomModeChanged()
        UIUpdateZoom()
    }
    
    func handleZoomModeChangedForced() {
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
}


