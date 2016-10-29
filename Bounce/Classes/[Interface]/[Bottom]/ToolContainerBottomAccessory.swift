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
    
    @IBOutlet weak internal var toolRowEdit: ToolRowAccessoryBottomEdit! {
        didSet { toolRows.append(toolRowEdit);
            //toolRowEdit.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak internal var toolRowView: ToolRowAccessoryBottomView! {
        didSet { toolRows.append(toolRowView);
            //toolRowView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak internal var toolRowZoom: ToolRowAccessoryBottomZoom! {
        didSet { toolRows.append(toolRowZoom);
            //toolRowZoom.backgroundColor = UIColor.clear
        }
    }
    
    func updateToolRow() {
        guard isHidden == false else { return }
        
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
