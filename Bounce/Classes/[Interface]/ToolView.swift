//
//  ToolView.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolView: UIView
{
    var index: Int = 0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = false
        isMultipleTouchEnabled = false
    }
    
    func setUp() {
        
        
        //zoomModeChangedForced
        
        //Propogate setup to subviews.
        for subview1 in subviews {
            if subview1.responds(to: #selector(setUp)) {
                subview1.perform(#selector(setUp))
            } else {
                for subview2 in subview1.subviews {
                    if subview2.responds(to: #selector(setUp)) {
                        subview2.perform(#selector(setUp))
                    } else {
                        for subview3 in subview2.subviews {
                            if subview3.responds(to: #selector(setUp)) {
                                subview3.perform(#selector(setUp))
                            } else {
                                for subview4 in subview3.subviews {
                                    if subview4.responds(to: #selector(setUp)) {
                                        subview4.perform(#selector(setUp))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        //Hide all of the setup / test background colors..
        // /*
        for subview1 in subviews {
            if ToolView.isToolElement(view: subview1) == false {
                subview1.backgroundColor = UIColor.clear
                for subview2 in subview1.subviews {
                    if ToolView.isToolElement(view: subview2) == false {
                        subview2.backgroundColor = UIColor.clear
                        for subview3 in subview2.subviews {
                            if ToolView.isToolElement(view: subview3) == false {
                                subview3.backgroundColor = UIColor.clear
                            }
                        }
                    }
                }
            }
        }
        // */
        
        refreshUI()
        
        setNeedsDisplay()
    }
    
    func addObserver(selector:Selector, notification:BounceNotification) {
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: NSNotification.Name(notification.rawValue),
                                               object: nil)
    }
    
    class func isToolElement(view: UIView) -> Bool {
        if view is TBButton { return true }
        if view is TBSegment { return true }
        if view is TBCheckBox { return true }
        return false
    }
    
    func refreshUI() {
        
    }
    
    deinit {
        
    }
    
    
    
}

