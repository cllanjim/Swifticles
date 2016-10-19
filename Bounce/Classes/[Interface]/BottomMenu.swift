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
    @IBOutlet weak internal var toolRowUnderlay: UIView! {
        didSet { toolRowUnderlay.backgroundColor = styleColorToolbarRow }
    }
    
    @IBOutlet weak internal var containerMain: ToolContainerBottomMain?
    
    @IBOutlet weak internal var accessoryRow: ToolRow?
    
    @IBOutlet weak internal var containerAccessory: ToolContainerBottomAccessory?
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerMainTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toolBarHeightConstraint: NSLayoutConstraint!
    
    
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
        
        toolBarHeightConstraint.constant = ApplicationController.shared.toolBarHeight
        
        if ApplicationController.shared.isSceneLandscape {
            layoutIfNeeded()
            
            containerAccessory!.isHidden = true
            removeConstraint(containerMainTopConstraint)
            
            let newTopConstraint = NSLayoutConstraint(item: containerMain!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
            addConstraint(newTopConstraint)
            
            setNeedsUpdateConstraints()
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
        containerMain!.updateToolRow()
        containerAccessory!.updateToolRow()
    }
    
    func expand() {
        if expanded == false {
            expanded = true
            
            /*
            menuHeightConstraint.constant = expandedHeight
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 3.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion: nil)
            */
            
            
            if let container = containerAccessory, container.isHidden == false {
                container.showToolsAnimated(withDelay: 0.0, withStagger: 0.5, withDirection: 1)
            }
            if let container = containerMain, container.isHidden == false {
                container.showToolsAnimated(withDelay: 1.0, withStagger: 0.5, withDirection: -1)
            }
            
        }
        
    }
    
    func collapse() {
        if expanded == true {
            expanded = false
            
            /*
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 3.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion: nil)
            */
            
            if let container = containerAccessory, container.isHidden == false {
                container.hideToolsAnimated(withDelay: 1.0, withStagger: 0.5, withDirection: -1)
            }
            if let container = containerMain, container.isHidden == false {
                container.hideToolsAnimated(withDelay: 0.0, withStagger: 0.5, withDirection: 1)
            }
            
            
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
