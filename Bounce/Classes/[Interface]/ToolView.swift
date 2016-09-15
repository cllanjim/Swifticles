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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var leftConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func setUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleZoomModeChange),
                                               name: NSNotification.Name(BounceNotification.ZoomModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSceneModeChanged),
                                               name: NSNotification.Name(BounceNotification.SceneModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditModeChanged),
                                               name: NSNotification.Name(BounceNotification.EditModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewModeChanged),
                                               name: NSNotification.Name(BounceNotification.ViewModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobSelectionChanged),
                                               name: NSNotification.Name(BounceNotification.BlobSelectionChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobAdded),
                                               name: NSNotification.Name(BounceNotification.BlobAdded.rawValue), object: nil)
    }
    
    deinit {
        
    }
    
    func handleZoomModeChange() {
        print("handleZoomModeChange()")
        
    }
    
    func handleSceneModeChanged() {
        print("handleSceneModeChanged()")
        
    }
    
    func handleEditModeChanged() {
        print("handleEditModeChanged()")
    }
    
    func handleViewModeChanged() {
        print("handleViewModeChanged()")
    }
    
    func handleBlobAdded() {
        print("handleBlobAdded()")
    }
    
    func handleBlobSelectionChanged() {
        print("handleBlobSelectionChanged()")
    }
    
}

