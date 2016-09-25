//
//  ToolRow.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/24/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRowContainer : ToolView
{
    override func setUp() {
        super.setUp()
        
        
        clipsToBounds = false
        isMultipleTouchEnabled = false
        
        for i in 0..<toolRows.count {
            toolRows[i].index = i
        }
        
        //updateToolRow()
        
    }
    
    deinit {
        
    }
    
    var toolRows = [ToolView]()
    
    var expanded:Bool = true
    
    override func handleSceneReady() {
        /*
        if expanded {
            menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
        } else {
            menuHeightConstraint.constant = toolBar.height
        }
        */
        setNeedsUpdateConstraints()
    }
    
    override func handleSceneModeChanged() {
        super.handleSceneModeChanged()
        //updateToolRow()
    }
    
    override func handleZoomModeChange() {
        super.handleZoomModeChange()
        //updateToolRow()
    }
    
    //override func handleBlobSelectionChanged() { }
    var _currentToolRow: ToolView?
    var toolRow: ToolView? {
        get {
            return _currentToolRow
        }
        set {
            guard newValue != _currentToolRow else { return }
            
            
            var previousToolRow = _currentToolRow
            _currentToolRow = newValue
            
            if _currentToolRow != nil {
                bringSubview(toFront: _currentToolRow!)
            }
            
            
            //Initial case, snap everything into place.
            if _currentToolRow != nil && previousToolRow == nil {
                
                for tr in toolRows {
                    if tr !== _currentToolRow {
                        sendOffScreenLeft(tr)
                        tr.isHidden = true
                    }
                }
                sendOnScreen(_currentToolRow!)
                _currentToolRow!.isHidden = false
                
                layoutIfNeeded()
                
                
                //Initial case, snap everything into place.
            } else if _currentToolRow == nil && previousToolRow != nil {
                print("***UNUSED CASE***)")
                print("***DISMISS ALL***)")
                
                //Usual case, animate them all pretty.
            } else if _currentToolRow != nil && previousToolRow != nil {
                
                if _currentToolRow!.index > previousToolRow!.index {
                    
                    sendOffScreenRight(_currentToolRow!)
                    sendOnScreen(previousToolRow!)
                    
                    _currentToolRow?.layoutIfNeeded()
                    previousToolRow?.layoutIfNeeded()
                    layoutIfNeeded()
                    
                    sendOffScreenLeft(previousToolRow!)
                    
                    
                } else {
                    sendOffScreenLeft(_currentToolRow!)
                    sendOnScreen(previousToolRow!)
                    
                    _currentToolRow?.layoutIfNeeded()
                    previousToolRow?.layoutIfNeeded()
                    layoutIfNeeded()
                    
                    sendOffScreenRight(previousToolRow!)
                }
                
                _currentToolRow?.isHidden = false
                previousToolRow?.isHidden = false
                
                sendOnScreen(_currentToolRow!)
                
                UIView.animate(withDuration: 0.4, animations: {
                    [weakSelf = self] in
                    weakSelf._currentToolRow?.layoutIfNeeded()
                    previousToolRow?.layoutIfNeeded()
                    weakSelf.layoutIfNeeded()
                    weakSelf.superview?.layoutIfNeeded()
                    }, completion: { [weakSelf = self] (finished:Bool) in
                        previousToolRow?.isHidden = true
                        weakSelf._currentToolRow!.isHidden = false
                    })
            }
        }
    }
    
    func updateToolRowConstraints() {
        //
        
        //_currentToolRow
    }
    
    func sendOnScreen(_ row:ToolView) {
        row.leftConstraint?.constant = 0.0
        row.setNeedsLayout()
    }
    
    func sendOffScreenLeft(_ row:ToolView) {
        row.leftConstraint?.constant = CGFloat(-Int(ApplicationController.shared.width + 0.5))
        row.setNeedsLayout()
    }
    
    func sendOffScreenRight(_ row:ToolView) {
        row.leftConstraint?.constant = CGFloat(Int(ApplicationController.shared.width + 0.5))
        row.setNeedsLayout()
    }
    
    
    func expand() {
        if expanded == false {
            expanded = true
            
            /*
            menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
            */
        }
    }
    
    func collapse() {
        if expanded == true {
            expanded = false
            
            /*
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
            */
        }
    }
    
    //override func handleSceneReady() { }
    //override func handleZoomModeChange() { }
    //override func handleSceneModeChanged() { }
    //override func handleEditModeChanged() { }
    //override func handleViewModeChanged() { }
    //override func handleBlobAdded() { }
    //override func handleBlobSelectionChanged() { }
}

