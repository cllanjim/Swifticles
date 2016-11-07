//
//  ToolRowTopEditWeight.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 11/4/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowTopEditWeight: ToolRow
{

    @IBInspectable @IBOutlet weak var checkboxShowCenterWeight: TBCheckBox! {
        didSet {
            checkboxShowCenterWeight.delegate = self
            checkboxShowCenterWeight.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var checkboxShowEdgeWeight: TBCheckBox! {
        didSet {
            checkboxShowEdgeWeight.delegate = self
            checkboxShowEdgeWeight.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var sliderCenterWeight: UISlider! {
        didSet {
            sliderCenterWeight.maximumValue = 1.0
            sliderCenterWeight.minimumValue = 0.0
        }
    }
    
    @IBInspectable @IBOutlet weak var sliderEdgeWeight: UISlider! {
        didSet {
            sliderEdgeWeight.maximumValue = 1.0
            sliderEdgeWeight.minimumValue = 0.0
        }
    }
    
    @IBInspectable @IBOutlet weak var labelCenterWeight:UILabel!
    @IBInspectable @IBOutlet weak var labelEdgeWeight:UILabel!
    
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
        
        if let engine = ApplicationController.shared.engine {
            
            checkboxShowEdgeWeight.checked = engine.editShowEdgeWeight
            checkboxShowCenterWeight.checked = engine.editShowCenterWeight
            
            
        }
        
        
    }
    
    func UIUpdateSelection() {
        
        if let blob = ApplicationController.shared.selectedBlob {
            sliderEdgeWeight.isEnabled = true
            sliderEdgeWeight.value = Float(blob.centerBulgeFactor)
            
            sliderCenterWeight.isEnabled = true
            sliderEdgeWeight.value = Float(blob.centerBulgeFactor)
            
            labelCenterWeight.isHidden = false
            labelEdgeWeight.isHidden = false
            
            UIUpdateEdgeWeightText()
            UIUpdateCenterWeightText()
            
        } else {
            sliderEdgeWeight.isEnabled = false
            sliderCenterWeight.isEnabled = false
            labelCenterWeight.isHidden = true
            labelEdgeWeight.isHidden = true
        }
    }
    
    func UIUpdateCenterWeightText() {
        if let blob = ApplicationController.shared.selectedBlob {
            let percentInt = Int(Float(blob.centerBulgeFactor * 100.0 + 0.5))
            labelCenterWeight.text = "\(percentInt)%"
        }
    }
    
    func UIUpdateEdgeWeightText() {
        if let blob = ApplicationController.shared.selectedBlob {
            let percentInt = Int(Float(blob.edgeBulgeFactor * 100.0 + 0.5))
            labelEdgeWeight.text = "\(percentInt)%"
        }
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        if checkBox === checkboxShowCenterWeight {
            ToolActions.setEditShowCenterWeight(checkboxShowCenterWeight.checked)
        } else if checkBox === checkboxShowEdgeWeight {
            ToolActions.setEditShowEdgeWeight(checkboxShowEdgeWeight.checked)
        }
    }
    
    @IBAction func slide(sender: UISlider) {
        if let blob = ApplicationController.shared.selectedBlob {
            if sender === sliderCenterWeight {
                blob.centerBulgeFactor = CGFloat(sliderCenterWeight.value)
                UIUpdateCenterWeightText()
                
            } else if sender === sliderEdgeWeight {
                blob.edgeBulgeFactor = CGFloat(sliderEdgeWeight.value)
                UIUpdateEdgeWeightText()
            }
        }
    }
    
    override func handleSceneReady() {
        super.handleSceneReady()
    }
    
    override func handleZoomModeChanged() {
        super.handleZoomModeChanged()
        
    }
    
    func handleZoomModeChangedForced() {
        
        
    }
    
    override func handleSceneModeChanged() {
        super.handleSceneModeChanged()
        
    }
    
    override func handleBlobSelectionChanged() {
        super.handleBlobSelectionChanged()
        UIUpdateSelection()
    }
    
}

