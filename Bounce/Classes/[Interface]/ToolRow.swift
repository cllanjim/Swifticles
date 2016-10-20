//
//  ToolRow.swift
//  Bounce
//
//  Created by Nicholas Raptis on 10/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRow : ToolView
{
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint?
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var leftConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    //L/R Containers which are only visible in landscape mode.
    //(In portrait mode, their buttons exist in extra row)
    @IBOutlet weak var leftContainer: UIView? {
        didSet {
            leftContainer?.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var rightContainer: UIView? {
        didSet {
            rightContainer?.backgroundColor = UIColor.clear
        }
    }
    
    //Usually centered between the left and right containers.
    @IBOutlet weak var mainContainer: UIView? {
        didSet {
            mainContainer?.backgroundColor = UIColor.clear
        }
    }
    
    
    @IBOutlet weak var leftContainerWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightContainerWidthConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setUp() {
        super.setUp()
        
        if ApplicationController.shared.isSceneLandscape == false {
            if let lc = leftContainer {
                if let con = leftContainerWidthConstraint, constraints.contains(con) {
                    removeConstraint(con)
                }
                let newWidthConstraint = NSLayoutConstraint(item: lc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
                addConstraint(newWidthConstraint)
                lc.isHidden = true
            }
            
            if let rc = rightContainer {
                if let con = rightContainerWidthConstraint, constraints.contains(con) {
                    removeConstraint(con)
                }
                let newWidthConstraint = NSLayoutConstraint(item: rc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
                addConstraint(newWidthConstraint)
                rc.isHidden = true
            }
            setNeedsUpdateConstraints()
        }
    }
    
    func hideToolsAnimated(withDelay delay: CGFloat, withStagger stagger: CGFloat, withDirection direction: Int) {
        
        var tools = getTools()
        if direction == -1 { tools = tools.reversed() }
        
        var wait = delay
        for i in 0..<tools.count {
            
            UIView.animate(withDuration: 0.28, delay: TimeInterval(wait), options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                tools[i].alpha = 0.0
                
                }, completion: nil)
            wait += stagger
        }
    }
    
    func showToolsAnimated(withDelay delay: CGFloat, withStagger stagger: CGFloat, withDirection direction: Int) {
        
        var tools = getTools()
        if direction == -1 { tools = tools.reversed() }
        
        var wait = delay
        for i in 0..<tools.count {
            UIView.animate(withDuration: 0.28, delay: TimeInterval(wait), options: UIViewAnimationOptions.curveEaseOut, animations: {
                tools[i].alpha = 1.0
                }, completion: nil)
            wait += stagger
        }
    }
    
    func showTools() {
        let tools = getTools()
        for i in 0..<tools.count {
            tools[i].alpha = 1.0
        }
    }
    
    func hideTools() {
        let tools = getTools()
        for i in 0..<tools.count {
            tools[i].alpha = 0.0
        }
    }
    
    private func isToolElement(view: UIView) -> Bool {
        
        if view is TBButton { return true }
        if view is TBSegment { return true }
        if view is TBCheckBox { return true }
        
        return false
    }
    
    private func getTools() -> [UIView] {
        var result = [UIView]()
        for subview1 in subviews {
            if isToolElement(view: subview1) {
                result.append(subview1)
            } else {
                for subview2 in subview1.subviews {
                    if isToolElement(view: subview2) {
                        result.append(subview2)
                    } else {
                        for subview3 in subview2.subviews {
                            if isToolElement(view: subview3) {
                                result.append(subview3)
                            } else {
                                for subview4 in subview3.subviews {
                                    if isToolElement(view: subview4) {
                                        result.append(subview4)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        result.sort(by: { $0.frame.origin.x < $1.frame.origin.x})
        
        return result
    }
    
    deinit {
        
    }
    
    override func handleSceneReady() { super.handleSceneReady() }
    override func handleZoomModeChange() { super.handleZoomModeChange() }
    override func handleSceneModeChanged() { super.handleSceneModeChanged() }
    override func handleEditModeChanged() { super.handleEditModeChanged() }
    override func handleViewModeChanged() { super.handleViewModeChanged() }
    override func handleBlobAdded() { super.handleBlobAdded() }
    override func handleBlobSelectionChanged() { super.handleBlobSelectionChanged() }
    
}


