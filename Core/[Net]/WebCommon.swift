//
//  EdmundsCommon.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

enum WebResult: UInt32 {
    case pending = 0,
    success = 1,
    canceled = 2,
    error = 3,
    invalid = 4,
    timeout = 5 }
