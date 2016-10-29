//
//  ToolRowTopView.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

class ToolRowTopView: ToolRow
{
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
        
        
        //checkbox3D.checked = ApplicationController.shared.engine!.stereoscopic
        //checkboxGyro.checked = ApplicationController.shared.engine!.gyro
        
        UIUpdateHistory()
        UIUpdateZoom()
        UIUpdateSceneMode()
        UIUpdateSelection()
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
