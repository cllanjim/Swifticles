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
        
        if ApplicationController.shared.isSceneLandscape == false {
            if let lc = leftContainer {
                if let con = leftContainerWidthConstraint, constraints.contains(con) {
                    removeConstraint(con)
                }
                let newWidthConstraint = NSLayoutConstraint(item: lc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 5)
                addConstraint(newWidthConstraint)
            }
            
            if let rc = rightContainer {
                if let con = rightContainerWidthConstraint, constraints.contains(con) {
                    removeConstraint(con)
                }
                let newWidthConstraint = NSLayoutConstraint(item: rc, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 5.0)
                addConstraint(newWidthConstraint)
            }
            setNeedsUpdateConstraints()
        }
    }
    
    func hideToolsAnimated(withDelay delay: CGFloat, withStagger stagger: CGFloat, withDirection direction: Int) {
        
        var tools = getTools()
        if direction == -1 { tools = tools.reversed() }
        
        var wait = delay
        for i in 0..<tools.count {
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(wait), options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                tools[i].alpha = 0.0
                
                }, completion: { (finished:Bool) in
                
            })
            
            
            wait += stagger
        }
        
        
    }
    
    func showToolsAnimated(withDelay delay: CGFloat, withStagger stagger: CGFloat, withDirection direction: Int) {
        
        var tools = getTools()
        if direction == -1 { tools = tools.reversed() }
        
        
        var wait = delay
        for i in 0..<tools.count {
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(wait), options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                tools[i].alpha = 1.0
                
                }, completion: { (finished:Bool) in
                    
            })
            
            
            wait += stagger
        }
        
    }
    
    private func getTools() -> [UIView] {
        var result = [UIView]()
        for view in subviews {
            result.append(view)
        }
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


