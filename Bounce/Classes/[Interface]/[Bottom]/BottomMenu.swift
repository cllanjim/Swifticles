//
//  TopMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BottomMenu: ToolRow
{
    @IBOutlet weak internal var toolRowUnderlay: UIView!
    
    @IBOutlet weak internal var containerMain: ToolContainerBottomMain?
    @IBOutlet weak internal var accessoryRow: ToolRow?
    @IBOutlet weak internal var containerAccessory: ToolContainerBottomAccessory?
    
    @IBOutlet weak internal var shadowTop: UIImageView!
    @IBOutlet weak internal var shadowMiddleToolbar: UIImageView!
    @IBOutlet weak internal var shadowMiddleMainRow: UIImageView!
    
    @IBOutlet weak var shadowTopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowMiddleToolbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowMiddleMainRowHeightConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    //@IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerMainTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarHeightConstraint: NSLayoutConstraint!
    
    
    //Expanded = Bottom row visible, top rows hidden.
    var expanded:Bool = true
    
    //Showing = fully visible, now showing = fully invisible..
    var showing:Bool = true
    
    
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
        backgroundColor = UIColor.clear
        
        toolBarHeightConstraint.constant = ApplicationController.shared.toolBarHeight
        
        if ApplicationController.shared.isSceneLandscape {
            layoutIfNeeded()
            
            shadowMiddleMainRow.isHidden = true
            
            containerAccessory!.isHidden = true
            removeConstraint(containerMainTopConstraint)
            
            let newTopConstraint = NSLayoutConstraint(item: containerMain!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
            addConstraint(newTopConstraint)
            
            setNeedsUpdateConstraints()
        }
        
        toolRowUnderlay.backgroundColor = styleColorToolbarRow
        toolBar.backgroundColor = styleColorToolbarMain
        
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
    
    override func handleZoomModeChanged() {
        updateToolRow()
    }
    
    func updateToolRow() {
        containerMain!.updateToolRow()
        containerAccessory!.updateToolRow()
    }
    
    func hideAnimated() {
        if showing == true {
            showing = false
            ApplicationController.shared.addActionBlocker()
            
            menuBottomConstraint.constant = -height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.52, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations:
                { [weak weakSelf = self] in
                    weakSelf?.superview?.layoutIfNeeded()
                    
                }, completion:
                { [weak weakSelf = self] (finished:Bool) in
                    weakSelf?.isHidden = true
                    ApplicationController.shared.removeActionBlocker()
                })
            UIView.animate(withDuration: 0.24, delay: 0.24, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations:
                { [weak weakSelf = self] in
                    weakSelf?.shadowTop.alpha = 0.0
                }, completion: nil)
        }
    }
    
    func showAnimated() {
        if showing == false {
            showing = true
            ApplicationController.shared.addActionBlocker()
            
            menuBottomConstraint.constant = 0.0
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            isHidden = false
            UIView.animate(withDuration: 0.52, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseIn, animations:
                { [weak weakSelf = self] in
                    weakSelf?.superview?.layoutIfNeeded()
                    weakSelf?.shadowTop.alpha = 1.0
                }, completion:
                { (finished:Bool) in
                    ApplicationController.shared.removeActionBlocker()
            })
        }
    }
    
    func expand() {
        if expanded == false {
            expanded = true
            
            ApplicationController.shared.addActionBlocker()
            
            containerMain?.showing = true
            containerAccessory?.showing = true
            
            menuHeightConstraint.constant = expandedHeight
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.36, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion:
                { (finished:Bool) in
                    ApplicationController.shared.removeActionBlocker()
                })
            
            var shadowDelay:CGFloat = 0.15
            if ApplicationController.shared.isSceneLandscape == false {
                shadowDelay = 0.3
                shadowMiddleMainRow.isHidden = false
                UIView.animate(withDuration: 0.28, delay: 0.15, options: .curveEaseOut, animations:
                    { [weak weakSelf = self] in
                        weakSelf?.shadowMiddleMainRow.alpha = 1.0
                        
                    }, completion:nil)
            }
            
            shadowMiddleToolbar.isHidden = false
            UIView.animate(withDuration: 0.28, delay: TimeInterval(shadowDelay), options: .curveEaseOut, animations:
                { [weak weakSelf = self] in
                    weakSelf?.shadowMiddleToolbar.alpha = 1.0
                    
                }, completion:nil)
            
            if let container = containerAccessory, container.isHidden == false {
                container.showToolsAnimated(withDelay: 0.0, withStagger: 0.0, withDirection: 1)
            }
            if let container = containerMain, container.isHidden == false {
                container.showToolsAnimated(withDelay: 0.20, withStagger: 0.0, withDirection: -1)
            }
        }
    }
    
    func collapse() {
        if expanded == true {
            expanded = false
            
            ApplicationController.shared.addActionBlocker()
            
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.40, delay: 0.2, options: .curveEaseIn, animations: {
                [weak weakSelf = self] in
                weakSelf?.superview?.layoutIfNeeded()
                }, completion: { [weak weakSelf = self] (finished:Bool) in
                    weakSelf?.containerMain?.showing = false
                    weakSelf?.containerAccessory?.showing = false
                    ApplicationController.shared.removeActionBlocker()
                })
            
            if ApplicationController.shared.isSceneLandscape == false {
                UIView.animate(withDuration: 0.28, delay: 0.30, options: .curveEaseIn, animations:
                    { [weak weakSelf = self] in
                        weakSelf?.shadowMiddleMainRow.alpha = 0.0
                        
                    }, completion:
                    { [weak weakSelf = self] (finished:Bool) in
                        weakSelf?.shadowMiddleMainRow.isHidden = false
                    })
            }
            
            UIView.animate(withDuration: 0.28, delay: 0.15, options: .curveEaseIn, animations:
                { [weak weakSelf = self] in
                    weakSelf?.shadowMiddleToolbar.alpha = 0.0
                    
                }, completion:
                { [weak weakSelf = self] (finished:Bool) in
                    weakSelf?.shadowMiddleToolbar.isHidden = false
                })
            
            if let container = containerAccessory, container.isHidden == false {
                container.hideToolsAnimated(withDelay: 0.240, withStagger: 0.0, withDirection: -1)
            }
            
            if let container = containerMain, container.isHidden == false {
                container.hideToolsAnimated(withDelay: 0.0, withStagger: 0.0, withDirection: 1)
            }
        }
    }
    
}
