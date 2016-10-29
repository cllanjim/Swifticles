//
//  ToolContainerBottomMain.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/24/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolContainerBottomMain : ToolRowContainer
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
    
    func updateToolRow() {
        if ApplicationController.shared.zoomMode {
            toolRow = toolRowZoom
        } else {
            if ApplicationController.shared.sceneMode == .edit {
                toolRow = toolRowEdit
            } else if ApplicationController.shared.sceneMode == .view {
                toolRow = toolRowView
            }
        }
    }
    
    override func setUp() {
        
        super.setUp()
    }
    
    deinit { }
    
}

