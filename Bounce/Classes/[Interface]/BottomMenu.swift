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
    /*
    var toolRows = [ToolView]()
    
    @IBOutlet weak internal var toolRowEdit: ToolRowBottomEdit! {
        didSet { toolRows.append(toolRowEdit); toolRowEdit.backgroundColor = UIColor.clear }
    }
    @IBOutlet weak internal var toolRowView: ToolRowBottomView! {
        didSet { toolRows.append(toolRowView); toolRowView.backgroundColor = UIColor.clear }
    }
    @IBOutlet weak internal var toolRowZoom: ToolRowBottomZoom! {
        didSet { toolRows.append(toolRowZoom); toolRowZoom.backgroundColor = UIColor.clear }
    }
    
     @IBOutlet weak var toolMenuContainer: UIView! {
     didSet { toolMenuContainer.backgroundColor = UIColor.clear }
     }
     
    */
    
    @IBOutlet weak internal var toolRowUnderlay: UIView! {
        didSet { toolRowUnderlay.backgroundColor = styleColorToolbarRow }
    }
    
    @IBOutlet weak internal var containerMain: ToolContainerBottomMain? {
        didSet { }
    }
    
    @IBOutlet weak internal var containerAccessory: ToolContainerBottomAccessory? {
        didSet { }
    }
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerMainTopConstraint: NSLayoutConstraint!
    
    
    var expanded:Bool = true
    
    @IBOutlet weak var toolBar: ToolBarBottom! {
        didSet { toolBar.backgroundColor = styleColorToolbarMain }
    }
    
    
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
        
        /*
        for i in 0..<toolRows.count {
            toolRows[i].index = i
        }
        */
        
        if ApplicationController.shared.isSceneLandscape {
            
            layoutIfNeeded()
            
            let shift = containerAccessory!.height
            print("SHIFT = \(shift)")
            
            containerAccessory!.isHidden = true
            containerMainTopConstraint.constant = -containerAccessory!.height
            containerAccessory!.setNeedsLayout()
            containerMain!.setNeedsLayout()
            setNeedsLayout()
        }
        
        
        updateToolRow()
        layoutIfNeeded()
        
    }
    
    override func handleSceneReady() {
        if expanded {
            menuHeightConstraint.constant = expandedHeight
        } else {
            menuHeightConstraint.constant = toolBar.height
        }
        setNeedsUpdateConstraints()
    }
    
    var expandedHeight: CGFloat {
        var h = toolBar.height
        if let containerHeight = containerMain?.height {
            h += containerHeight
        }
        if let containerHeight = containerAccessory?.height, !containerAccessory!.isHidden {
            h += containerHeight
        }
        return h
    }
    
    override func handleSceneModeChanged() {
        updateToolRow()
    }
    
    override func handleZoomModeChange() {
        updateToolRow()
    }
    
    func updateToolRow() {
        
        containerMain?.updateToolRow()
        
        /*
        if ApplicationController.shared.zoomMode {
            toolRow = toolRowZoom
        } else {
            if ApplicationController.shared.sceneMode == .edit {
                toolRow = toolRowEdit
            } else if ApplicationController.shared.sceneMode == .view {
                toolRow = toolRowView
            }
        }
        */
    }
    
    /*
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
                    [weak weakSelf = self] in
                    weakSelf._currentToolRow?.layoutIfNeeded()
                    previousToolRow?.layoutIfNeeded()
                    weakSelf.layoutIfNeeded()
                    weakSelf.superview?.layoutIfNeeded()
                    }, completion: { [weak weakSelf = self] (finished:Bool) in
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
        
        if row === toolRowEdit { print("EDIT - sendOnScreen") }
        if row === toolRowView { print("VIEW - sendOnScreen") }
        if row === toolRowZoom { print("ZOOM - sendOnScreen") }
        
        row.leftConstraint?.constant = 0.0
        row.setNeedsLayout()
    }
    
    func sendOffScreenLeft(_ row:ToolView) {
        
        if row === toolRowEdit { print("EDIT - sendOffScreenLeft") }
        if row === toolRowView { print("VIEW - sendOffScreenLeft") }
        if row === toolRowZoom { print("ZOOM - sendOffScreenLeft") }
        
        row.leftConstraint?.constant = CGFloat(-Int(ApplicationController.shared.width + 0.5))
        row.setNeedsLayout()
    }
    
    func sendOffScreenRight(_ row:ToolView) {
        
        if row === toolRowEdit { print("EDIT - sendOffScreenRight") }
        if row === toolRowView { print("VIEW - sendOffScreenRight") }
        if row === toolRowZoom { print("ZOOM - sendOffScreenRight") }
        
        row.leftConstraint?.constant = CGFloat(Int(ApplicationController.shared.width + 0.5))
        row.setNeedsLayout()
    }
    */
    
    func expand() {
        if expanded == false {
            expanded = true
            menuHeightConstraint.constant = expandedHeight
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    func collapse() {
        if expanded == true {
            expanded = false
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        return
        
        let toolBarTop = toolBar.y
        let toolBarHeight = toolBar.height
        let toolBarBottom = toolBarTop + toolBarHeight
        
        let rectTop = rect.origin.y
        let rectHeight = rect.size.height
        let rectBottom = rectTop + rectHeight
        
        var rectMain = CGRect(x: rect.origin.x, y: 0.0, width: rect.width, height: 0.0)
        var rectRow = CGRect(x: rect.origin.x, y: 0.0, width: rect.width, height: 0.0)
        
        /*
        if rectTop >= toolBarBottom {
            rectMain.origin.y = rectTop
            rectMain.size.height = rectHeight
        } else if rectBottom <= toolBarBottom {
            rectRow.origin.y = rectTop
            rectRow.size.height = rectHeight
        } else {
            
            rectRow.origin.y = rectTop
            rectRow.size.height = toolBarTop - rectTop
            
            rectMain.origin.y = rectRow.origin.y + rectRow.size.height
            rectMain.size.height = rectHeight - rectRow.size.height
        }
        */
        
        rectRow.origin.y = rectTop
        rectRow.size.height = toolBarTop - rectTop
        
        rectMain.origin.y = rectRow.origin.y + rectRow.size.height
        rectMain.size.height = rectHeight - rectRow.size.height

        
        
        
        //let  = UIColor(red: 0.01, green: 0.01, blue: 0.04, alpha: 0.96)
        //let styleColorToolbarRow = UIColor(red: 0.04, green: 0.04, blue: 0.06, alpha: 0.76)
        
        
        //let height = self.height
        
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        if rectRow.size.height > 0.0 {
            
            context.setFillColor(styleColorToolbarRow.cgColor)
            context.fill(rectRow)
            
        }
        
        if rectMain.size.height > 0.0 {
            
            context.setFillColor(styleColorToolbarMain.cgColor)
            context.fill(rectMain)
            
        }
        
        context.restoreGState()
        
        setNeedsDisplay()

        
    }
    
    
}
