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
    
    @IBOutlet weak var segViewModeLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var segViewModeRightConstraint: NSLayoutConstraint!
    
    @IBInspectable @IBOutlet weak var segViewMode:TBSegment! {
        didSet {
            segViewMode.segmentCount = 2
            segViewMode.delegate = self
            segViewMode.setImage(index: 0, path: "tb_seg_view_free", pathSelected: "tb_seg_view_free_selected")
            segViewMode.setImage(index: 1, path: "tb_seg_view_loops", pathSelected: "tb_seg_view_loops_selected")
            segViewMode.selectedIndex = 0
        }
    }
    
    @IBInspectable @IBOutlet weak var checkboxGyro: TBCheckBox! {
        didSet {
            checkboxGyro.delegate = self
            checkboxGyro.setImages(path: "tb_cb_zoom", pathSelected: nil)
        }
    }
    
    @IBInspectable @IBOutlet weak var checkbox3D: TBCheckBox! {
        didSet {
            checkbox3D.delegate = self
            checkbox3D.setImages(path: "tb_cb_3d", pathSelected: nil)
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonUndoAlt:TBButton! {
        didSet {
            buttonUndoAlt.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
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
        
        addObserver(selector: #selector(handleHistoryChanged), notification: .historyChanged)
        
        if ApplicationController.shared.isSceneLandscape {
            buttonUndoAlt.isHidden = true
        }
        
        if Device.isTablet {
            let padding = CGFloat(Int(mainContainer!.width * 0.23))
            segViewModeLeftConstraint.constant = padding
            segViewModeRightConstraint.constant = -padding
        } else if ApplicationController.shared.isSceneLandscape {
            let padding = CGFloat(Int(mainContainer!.width * 0.14))
            segViewModeLeftConstraint.constant = padding
            segViewModeRightConstraint.constant = -padding
        }
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
        
        if ApplicationController.shared.canUndo() {
            buttonUndoAlt.isEnabled = true
        } else {
            buttonUndoAlt.isEnabled = false
        }
    }
    
    func UIUpdateZoom() {
        
    }
    
    func UIUpdateSceneMode() {
        
    }
    
    @IBAction func clickUndo(sender: AnyObject) {
        ToolActions.undo()
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
    
    func handleHistoryChanged() {
        UIUpdateHistory()
    }
    
}
