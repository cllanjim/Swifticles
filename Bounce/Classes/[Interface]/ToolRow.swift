//
//  ToolRow.swift
//  Bounce
//
//  Created by Nicholas Raptis on 10/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolRow : ToolView, TBSegmentDelegate, TBCheckBoxDelegate
{
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint?
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var leftConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    //L/R Containers which are only visible in landscape mode.
    //(In portrait mode, their buttons exist in extra row)
    @IBOutlet weak var leftContainer: UIView?
    @IBOutlet weak var rightContainer: UIView?
    
    //Usually centered between the left and right containers.
    @IBOutlet weak var mainContainer: UIView?
    
    
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
        
        
        addObserver(selector: #selector(handleSceneReady), notification: .sceneReady)
        addObserver(selector: #selector(handleZoomModeChanged), notification: .zoomModeChanged)
        addObserver(selector: #selector(handleSceneModeChanged), notification: .sceneModeChanged)
        addObserver(selector: #selector(handleEditModeChanged), notification: .editModeChanged)
        addObserver(selector: #selector(handleViewModeChanged), notification: .viewModeChanged)
        addObserver(selector: #selector(handleBlobSelectionChanged), notification: .blobSelectionChanged)
        
        
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
    
    
    
    private func getTools() -> [UIView] {
        var result = [UIView]()
        for subview1 in subviews {
            if ToolView.isToolElement(view: subview1) {
                result.append(subview1)
            } else {
                for subview2 in subview1.subviews {
                    if ToolView.isToolElement(view: subview2) {
                        result.append(subview2)
                    } else {
                        for subview3 in subview2.subviews {
                            if ToolView.isToolElement(view: subview3) {
                                result.append(subview3)
                            } else {
                                for subview4 in subview3.subviews {
                                    if ToolView.isToolElement(view: subview4) {
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
    
    
    func segmentSelected(segment:TBSegment, index: Int) {
        
    }
    
    func checkBoxToggled(checkBox:TBCheckBox, checked: Bool) {
        
    }
    
    override func refreshUI() {
        super.refreshUI()
        
    }
    
    deinit {
        
    }
    
    func handleSceneReady() { }
    func handleZoomModeChanged() { }
    func handleSceneModeChanged() { }
    func handleEditModeChanged() { }
    func handleViewModeChanged() { }
    func handleBlobSelectionChanged() { }
    //func handleHistoryChanged() { }
    
    //override func handleSceneReady() { super.handleSceneReady() }
    //override func handleZoomModeChanged() { super.handleZoomModeChanged() }
    //override func handleSceneModeChanged() { super.handleSceneModeChanged() }
    //override func handleEditModeChanged() { super.handleEditModeChanged() }
    //override func handleViewModeChanged() { super.handleViewModeChanged() }
    //override func handleBlobSelectionChanged() { super.handleBlobSelectionChanged() }
    //override func handleHistoryChanged() { super.handleHistoryChanged() }
    
}


