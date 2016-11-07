//
//  ToolBarBottom.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarBottom : ToolRow
{
    
    @IBInspectable @IBOutlet weak var segMode:TBSegment! {
        didSet {
            segMode.segmentCount = 2
            segMode.delegate = self
            segMode.orange = true
            segMode.setImage(index: 0, path: "tb_seg_edit", pathSelected: "tb_seg_edit_selected")
            segMode.setImage(index: 1, path: "tb_seg_view", pathSelected: "tb_seg_view_selected")
            segMode.selectedIndex = 0
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonExpand:TBButton! {
        didSet {
            buttonExpand.setImages(path: "tb_btn_select_next_blob", pathSelected: "tb_btn_select_next_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonExpandAlt:TBButton! {
        didSet {
            buttonExpand.setImages(path: "tb_btn_select_next_blob", pathSelected: "tb_btn_select_next_blob_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonUndo:TBButton! {
        didSet {
            buttonUndo.setImages(path: "tb_btn_undo", pathSelected: "tb_btn_undo_down")
        }
    }
    
    @IBInspectable @IBOutlet weak var buttonRedo:TBButton! {
        didSet {
            buttonRedo.setImages(path: "tb_btn_redo", pathSelected: "tb_btn_redo_down")
        }
    }
    
    
    @IBInspectable @IBOutlet weak var buttonRedoAlt:TBButton! {
        didSet {
            buttonRedoAlt.setImages(path: "tb_btn_redo", pathSelected: "tb_btn_redo_down")
        }
    }
    
    override func setUp() {
        addObserver(selector: #selector(handleHistoryChanged), notification: .historyChanged)
        if ApplicationController.shared.isSceneLandscape {
            buttonExpandAlt.isHidden = true
            buttonRedoAlt.isHidden = true
        }
        super.setUp()
    }
    
    override func refreshUI() {
        super.refreshUI()
        
        if ApplicationController.shared.sceneMode == .view {
            segMode.selectedIndex = 1
        } else {
            segMode.selectedIndex = 0
        }
        
        
        UIUpdateZoom()
        UIUpdateSceneMode()
    }
    
    
    @IBAction func clickExpand(sender: AnyObject) {
        ToolActions.bottomMenuToggleExpand()
    }
    
    @IBAction func clickUndo(sender: AnyObject) {
        ToolActions.undo()
    }
    
    @IBAction func clickRedo(sender: AnyObject) {
        ToolActions.redo()
    }
    
    func UIUpdateHistory() {
        
        if ApplicationController.shared.canUndo() {
            buttonUndo.isEnabled = true
        } else {
            buttonUndo.isEnabled = false
        }
        
        if ApplicationController.shared.canRedo() {
            buttonRedo.isEnabled = true
            buttonRedoAlt.isEnabled = true
        } else {
            buttonRedo.isEnabled = false
            buttonRedoAlt.isEnabled = false
        }
    }
    
    func UIUpdateZoom() {
        
        UIUpdateHistory()
        
        if ApplicationController.shared.zoomMode == false {
            
            if buttonUndo.alpha < 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonUndo.alpha = 1.0
                })
            }
            if buttonRedo.alpha < 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonRedo.alpha = 1.0
                })
            }
            if buttonRedoAlt.alpha < 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonRedoAlt.alpha = 1.0
                })
            }
        } else {
            if buttonUndo.alpha > 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonUndo.alpha = 0.0
                })
            }
            if buttonRedo.alpha > 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonRedo.alpha = 0.0
                })
            }
            if buttonRedoAlt.alpha > 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    [weak weakSelf = self] in
                    weakSelf?.buttonRedoAlt.alpha = 0.0
                })
            }
        }
    }
    
    func UIUpdateSceneMode() {
        
    }
    
    override func segmentSelected(segment:TBSegment, index: Int) {
        if segment === segMode {
            if segMode.selectedIndex == 0 {
                ApplicationController.shared.sceneMode = .edit
            } else {
                ApplicationController.shared.sceneMode = .view
            }
        }
    }
    
    override func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
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
    }
    
    override func handleEditModeChanged() {
        super.handleEditModeChanged()
        
    }
    
    override func handleViewModeChanged() {
        super.handleViewModeChanged()
        
    }
    
    override func handleBlobSelectionChanged() {
        super.handleBlobSelectionChanged()
        
    }
    
    func handleHistoryChanged() {
        UIUpdateHistory()
    }
    
}

