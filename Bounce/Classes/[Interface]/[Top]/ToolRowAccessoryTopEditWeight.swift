//
//  ToolRowAccessoryTopEditWeight.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 11/4/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowAccessoryTopEditWeight: ToolRow
{
    
    @IBInspectable @IBOutlet weak var checkboxShowCenterWeight: TBCheckBox! {
        didSet {
            checkboxShowCenterWeight.delegate = self
            checkboxShowCenterWeight.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var sliderCenterWeight: UISlider! {
        didSet {
            sliderCenterWeight.maximumValue = 1.0
            sliderCenterWeight.minimumValue = 0.0
        }
    }
    
    @IBInspectable @IBOutlet weak var labelCenterWeight:UILabel!
    
    override func setUp() {
        super.setUp()
        addObserver(selector: #selector(handleZoomModeChangedForced), notification: .zoomModeChangedForced)
    }
    
    @IBAction func clickResetZoom(sender: AnyObject) {
        if ApplicationController.shared.allowInterfaceAction() {
            ToolActions.resetZoom()
        }
    }
    
    override func refreshUI() {
        super.refreshUI()
        UIUpdateSelection()
        UIUpdateZoomCheck()
        UIUpdateSceneMode()
        UIUpdateZoomSlider()
    }
    
    func UIUpdateSelection() {
        
        if let blob = ApplicationController.shared.selectedBlob {
            
        } else {
            
        }
        
        
        //weightBulgeFactor
        
    }
    
    func UIUpdateZoomCheck() {
        
    }
    
    func UIUpdateZoomSlider() {
        if let bounce = ApplicationController.shared.bounce {
            
        }
    }
    
    
    func UIUpdateSceneMode() {
        
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        //if checkBox === checkboxZoomMode {
        //    ToolActions.setZoomMode(zoomMode: checkboxZoomMode.checked)
        //}
    }
    
    @IBAction func slideZoomScale(sender: UISlider) {
        if sender === sliderCenterWeight {
            
            //sliderBulgeWeight
        }
        
    }
    
    override func handleSceneReady() {
        super.handleSceneReady()
    }
    
    override func handleZoomModeChanged() {
        super.handleZoomModeChanged()
        UIUpdateZoomCheck()
    }
    
    func handleZoomModeChangedForced() {
        UIUpdateZoomCheck()
    }
    
    func handleZoomScaleChanged() {
        UIUpdateZoomSlider()
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

