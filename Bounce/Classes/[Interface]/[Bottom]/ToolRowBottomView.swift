//
//  ToolRowBottomView.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowBottomView: ToolRow
{
    
    @IBInspectable @IBOutlet weak var segViewMode:TBSegment! {
        didSet {
            segViewMode.segmentCount = 2
            segViewMode.delegate = self
            segViewMode.setImage(index: 0, path: "tb_seg_view_grab", pathSelected: "tb_seg_view_grab")
            segViewMode.setImage(index: 1, path: "tb_seg_view_grab", pathSelected: "tb_seg_view_grab")
            segViewMode.selectedIndex = 0
        }
    }
    
    @IBInspectable @IBOutlet weak var checkboxGyro: TBCheckBox! {
        didSet {
            checkboxGyro.delegate = self
            checkboxGyro.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var checkbox3D: TBCheckBox! {
        didSet {
            checkbox3D.delegate = self
            checkbox3D.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    
    //

    
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
        
        
        checkbox3D.checked = ApplicationController.shared.engine!.stereoscopic
        checkboxGyro.checked = ApplicationController.shared.engine!.gyro
        
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
