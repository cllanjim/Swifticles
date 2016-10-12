//
//  TableCellType.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

enum TableCellType: UInt32 { case stat = 0, dealer = 1, mpg = 2, categories = 3, color = 4 }

typealias TableSection = (type:TableCellType, count:Int, id: String?)
