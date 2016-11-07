//
//  ToolRowAccessoryBottomView.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowAccessoryBottomView: ToolRow
{
    
    @IBOutlet weak var checkboxGyro: TBCheckBox! {
        didSet {
            checkboxGyro.delegate = self
            checkboxGyro.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBOutlet weak var checkbox3D: TBCheckBox! {
        didSet {
            checkbox3D.delegate = self
            checkbox3D.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func refreshUI() {
        super.refreshUI()
        
        checkbox3D.checked = ApplicationController.shared.engine!.stereoscopic
        checkboxGyro.checked = ApplicationController.shared.engine!.gyro
        
        UIUpdateSelection()
        UIUpdateZoom()
        UIUpdateSceneMode()
    }
    
    func UIUpdateSelection() {
        
    }
    
    func UIUpdateZoom() {
        
    }
    
    func UIUpdateSceneMode() {
        
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        if checkBox === checkbox3D {
            ToolActions.setStereoscopicEnabled(checkbox3D.checked)
        }
        if checkBox === checkboxGyro {
            ToolActions.setGyroEnabled(checkboxGyro.checked)
        }
    }
    
    
    override func handleSceneReady() {
        super.handleSceneReady()
        
    }
    
    override func handleZoomModeChanged() {
        super.handleZoomModeChanged()
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

