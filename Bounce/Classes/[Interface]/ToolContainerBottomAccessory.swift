//
//  ToolContainerBottomAccessory.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/24/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolContainerBottomAccessory : ToolRowContainer
{
    
    @IBOutlet weak internal var toolRowEdit: ToolRowBottomEdit! {
        didSet { toolRows.append(toolRowEdit); toolRowEdit.backgroundColor = UIColor.clear }
    }
    @IBOutlet weak internal var toolRowView: ToolRowBottomView! {
        didSet { toolRows.append(toolRowView); toolRowView.backgroundColor = UIColor.clear }
    }
    @IBOutlet weak internal var toolRowZoom: ToolRowBottomZoom! {
        didSet { toolRows.append(toolRowZoom); toolRowZoom.backgroundColor = UIColor.clear }
    }
    
    override func setUp() {
        
        super.setUp()
        
        //addObserver(selector: #selector(handleSceneReady), notification: .SceneReady)
        //addObserver(selector: #selector(handleZoomModeChange), notification: .ZoomModeChanged)
        //addObserver(selector: #selector(handleSceneModeChanged), notification: .SceneModeChanged)
        //addObserver(selector: #selector(handleEditModeChanged), notification: .EditModeChanged)
        //addObserver(selector: #selector(handleViewModeChanged), notification: .ViewModeChanged)
        //addObserver(selector: #selector(handleBlobSelectionChanged), notification: .BlobSelectionChanged)
        
    }
    
    deinit { }
    
}
