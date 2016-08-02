//
//  JiggleConfig.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

enum DILayoutType : Int{case Any = 0, Fixed}

enum DILayoutAlignment : Int{case Center = 0, Left, Right}


class DILayoutItem : DSObject
{
    var mElement:DIElement! = nil;
    var mLayoutType:DILayoutType = DILayoutType.Any;
    
    required init(){super.init();}
    
    init(pElement:DIElement!)
    {
        super.init();
        self.setElement(pElement);
    }
    
    func setElement(pElement:DIElement!)
    {
        self.mElement = pElement;
    }
    
   
    
}