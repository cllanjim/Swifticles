//
//  ToolContainerTopAccessory.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolContainerTopAccessory : ToolRowContainer
{
    
    @IBOutlet weak internal var toolRowEditAffine: ToolRowAccessoryTopEditAffine! {
        didSet { toolRows.append(toolRowEditAffine) }
    }
    
    @IBOutlet weak internal var toolRowEditShape: ToolRowAccessoryTopEditShape! {
        didSet { toolRows.append(toolRowEditShape) }
    }
    
    @IBOutlet weak internal var toolRowEditWeight: ToolRowAccessoryTopEditWeight! {
        didSet { toolRows.append(toolRowEditWeight) }
    }
    
    @IBOutlet weak internal var toolRowView: ToolRowAccessoryTopView! {
        didSet { toolRows.append(toolRowView) }
    }
    
    func updateToolRow() {
        guard isHidden == false else { return }
        
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
