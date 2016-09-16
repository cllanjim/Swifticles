//
//  TopMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BottomMenu: ToolView
{
    var toolRows = [ToolView]()
    
    
    @IBOutlet weak internal var toolRowEdit: ToolRowBottomEdit! {
        didSet { toolRows.append(toolRowEdit) }
    }
    @IBOutlet weak internal var toolRowView: ToolRowBottomView! {
        didSet { toolRows.append(toolRowView) }
    }
    @IBOutlet weak internal var toolRowZoom: ToolRowBottomZoom! {
        didSet { toolRows.append(toolRowZoom) }
    }
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    var expanded:Bool = true
    
    @IBOutlet weak var toolBar: ToolBarBottom!
    @IBOutlet weak var toolMenuContainer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setUp() {
        super.setUp()
        
        clipsToBounds = false
        isMultipleTouchEnabled = false
        
        for i in 0..<toolRows.count {
            toolRows[i].index = i
        }
        
        updateToolRow()
    }
    
    override func handleSceneReady() {
        print("BottomMenu.handleSceneReady()")
        
        if expanded {
            menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
        } else {
            menuHeightConstraint.constant = toolBar.height
        }
        setNeedsUpdateConstraints()
    }
    
    override func handleSceneModeChanged() {
        print("BottomMenu.handleSceneModeChanged()")
        
        updateToolRow()
        
        
        //@IBOutlet weak internal var toolRowEdit: ToolRowBottomEdit!
        //@IBOutlet weak internal var toolRowView: ToolRowBottomView!
        
        
    }
    
    override func handleZoomModeChange() {
        print("BottomMenu.handleZoomModeChange()")
        
        updateToolRow()
        
        
        
        //
        //if gApp
        
        
    }
    
    func updateToolRow() {
        if gApp.zoomMode {
            toolRow = toolRowZoom
        } else {
            if gApp.sceneMode == .edit {
                toolRow = toolRowEdit
            } else if gApp.sceneMode == .view {
                toolRow = toolRowView
            }
        }
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
                toolMenuContainer.bringSubview(toFront: _currentToolRow!)
            }
            
            
            //Initial case, snap everything into place.
            if _currentToolRow != nil && previousToolRow == nil {
                
                for tr in toolRows {
                    if tr !== _currentToolRow {
                        sendOffScreenLeft(tr)
                    }
                }
                sendOnScreen(_currentToolRow!)
                
            //Initial case, snap everything into place.
            } else if _currentToolRow == nil && previousToolRow != nil {
                print("***UNUSED CASE***)")
                print("***DISMISS ALL***)")
                
            //Usual case, animate them all pretty.
            } else if _currentToolRow != nil && previousToolRow != nil {
                
                if _currentToolRow!.index > previousToolRow!.index {
                    
                    sendOffScreenRight(_currentToolRow!)
                    sendOnScreen(previousToolRow!)
                    
                    _currentToolRow!.layoutIfNeeded()
                    previousToolRow!.layoutIfNeeded()
                    layoutIfNeeded()
                    
                    sendOffScreenLeft(previousToolRow!)
                    
                    
                } else {
                    sendOffScreenLeft(_currentToolRow!)
                    sendOnScreen(previousToolRow!)
                    
                    _currentToolRow!.layoutIfNeeded()
                    previousToolRow!.layoutIfNeeded()
                    layoutIfNeeded()
                    
                    sendOffScreenRight(previousToolRow!)
                }
                
                sendOnScreen(_currentToolRow!)
                
                UIView.animate(withDuration: 0.4, animations: {
                    [weakSelf = self] in
                    weakSelf._currentToolRow!.layoutIfNeeded()
                    previousToolRow!.layoutIfNeeded()
                    weakSelf.superview?.layoutIfNeeded()
                    }, completion: nil)
            }
            
            
            layoutIfNeeded()
        }
        
    }
    
    func updateToolRowConstraints() {
        //
        
        //_currentToolRow
    }
    
    func sendOnScreen(_ row:ToolView) {
        row.leftConstraint?.constant = 0
        row.setNeedsLayout()
    }
    
    func sendOffScreenLeft(_ row:ToolView) {
        row.leftConstraint?.constant = -gApp.width * 0.75
        row.setNeedsLayout()
    }
    
    func sendOffScreenRight(_ row:ToolView) {
        row.leftConstraint?.constant = gApp.width * 0.75
        row.setNeedsLayout()
    }
    
    
    func expand() {
        print("EXPAND")
        
        if expanded == false {
            expanded = true
            menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    func collapse() {
        print("COLLAPSE")
        if expanded == true {
            expanded = false
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}
