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
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.065) { [weak weakSelf = self] in
        //    weakSelf?.setUp()
        //}
        //setUp()
    }
    
    func setUp() {
        addObserver(selector: #selector(handleSceneReady), notification: .SceneReady)
        addObserver(selector: #selector(handleZoomModeChange), notification: .ZoomModeChanged)
        addObserver(selector: #selector(handleSceneModeChanged), notification: .SceneModeChanged)
        addObserver(selector: #selector(handleEditModeChanged), notification: .EditModeChanged)
        addObserver(selector: #selector(handleViewModeChanged), notification: .ViewModeChanged)
        addObserver(selector: #selector(handleBlobSelectionChanged), notification: .BlobSelectionChanged)
        
        for view in subviews {
            if view.responds(to: #selector(setUp)) {
                view.perform(#selector(setUp))
            }
            view.setNeedsDisplay()
        }
        setNeedsDisplay()
    }
    
    func addObserver(selector:Selector, notification:BounceNotification) {
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: NSNotification.Name(notification.rawValue),
                                               object: nil)
    }
    
    deinit {
        
    }
    
    func handleSceneReady() { }
    func handleZoomModeChange() { }
    func handleSceneModeChanged() { }
    func handleEditModeChanged() { }
    func handleViewModeChanged() { }
    func handleBlobAdded() { }
    func handleBlobSelectionChanged() { }
}

