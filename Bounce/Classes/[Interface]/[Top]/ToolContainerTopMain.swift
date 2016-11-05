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
    @IBOutlet weak internal var toolRowEditAffine: ToolRowTopEditAffine! {
        didSet { toolRows.append(toolRowEditAffine) }
    }
    
    @IBOutlet weak internal var toolRowEditShape: ToolRowTopEditShape! {
        didSet { toolRows.append(toolRowEditShape) }
    }
    
    @IBOutlet weak internal var toolRowEditWeight: ToolRowTopEditWeight! {
        didSet { toolRows.append(toolRowEditWeight) }
    }
    
    @IBOutlet weak internal var toolRowView: ToolRowTopView! {
        didSet { toolRows.append(toolRowView); toolRowView.backgroundColor = UIColor.clear }
    }
    
    func updateToolRow() {
        if ApplicationController.shared.sceneMode == .edit {
            if ApplicationController.shared.editMode == .distribution {
                toolRow = toolRowEditWeight
            } else if ApplicationController.shared.editMode == .shape {
                toolRow = toolRowEditShape
            } else {
                toolRow = toolRowEditAffine
            }
        } else if ApplicationController.shared.sceneMode == .view {
            toolRow = toolRowView
        }
    }
    
    override func setUp() {
        
        super.setUp()
    }
    
    deinit { }
    
}


