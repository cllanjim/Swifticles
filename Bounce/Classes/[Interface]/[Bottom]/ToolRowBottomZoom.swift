//
//  ToolRowBottomZoom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/15/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

class ToolRowBottomZoom: ToolRow
{
    
    @IBInspectable @IBOutlet weak var checkboxZoomMode: TBCheckBox! {
        didSet {
            checkboxZoomMode.delegate = self
            checkboxZoomMode.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setUp() {
        super.setUp()
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

