//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModel: DSObject
{
    required init()
    {
        super.init()
    }
    
    init(model pModel: DDataModel!)
    {
        super.init()
        self.copyFrom(model: pModel)
    }

    
    func copyFrom(model pModel: DDataModel!)
    {
        
    }
    
    override func destroy()
    {
        super.destroy();
    }
    
}
