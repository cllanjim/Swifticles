//
//  ToolRowBottomZoom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/15/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowBottomZoom: ToolRow
{
    
    @IBInspectable @IBOutlet weak var checkboxZoomMode: TBCheckBox! {
        didSet {
            checkboxZoomMode.delegate = self
            checkboxZoomMode.setImages(path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
        }
    }
    
    @IBInspectable @IBOutlet weak var sliderZoomScale: UISlider! {
        didSet {
            sliderZoomScale.maximumValue = 4.0
            sliderZoomScale.minimumValue = 0.75
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonResetZoom:TBButton! {
        didSet {
            buttonResetZoom.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var labelZoomPercent:UILabel! {
        didSet {
            
            //buttonResetZoom.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
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
        addObserver(selector: #selector(handleZoomModeChangedForced), notification: .zoomModeChangedForced)
        addObserver(selector: #selector(handleZoomScaleChanged), notification: .zoomScaleChanged)
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
        
    }
    
    func UIUpdateZoomCheck() {
        checkboxZoomMode.checked = ApplicationController.shared.zoomMode
    }
    
    func UIUpdateZoomSlider() {
        if let bounce = ApplicationController.shared.bounce {
            sliderZoomScale.value = Float(bounce.screenScale)
            UIUpdateZoomText()
        }
    }
    
    func UIUpdateZoomText() {
        if let bounce = ApplicationController.shared.bounce {
            let percentInt = Int(Float(bounce.screenScale * 100.0 + 0.5))
            labelZoomPercent.text = "\(percentInt)%"
        }
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
    
    @IBAction func slideZoomScale(sender: UISlider) {
        if sender === sliderZoomScale {
            if let bounce = ApplicationController.shared.bounce {
                bounce.setZoom(CGFloat(sliderZoomScale.value))
                UIUpdateZoomText()
            }
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

