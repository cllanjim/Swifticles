//
//  ToolContainerTopMain.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolContainerTopMain : ToolRowContainer
{
    @IBOutlet weak internal var toolRowEdit: ToolRowTopEdit! {
        didSet { toolRows.append(toolRowEdit); toolRowEdit.backgroundColor = UIColor.clear }
    }
    
    @IBOutlet weak internal var toolRowView: ToolRowTopView! {
        didSet { toolRows.append(toolRowView); toolRowView.backgroundColor = UIColor.clear }
    }
    
    func updateToolRow() {
        //if ApplicationController.shared.zoomMode {
        //    toolRow = toolRowZoom
        //} else {
            if ApplicationController.shared.sceneMode == .edit {
                toolRow = toolRowEdit
            } else if ApplicationController.shared.sceneMode == .view {
                toolRow = toolRowView
            }
        //}
    }
    
    override func setUp() {
        
        super.setUp()
    }
    
    deinit { }
    
}


