//
//  CGSize+Extras.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/17/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

extension CGSize
{
    func getAspectFit(_ size: CGSize) -> (size: CGSize, scale: CGFloat) {
        var result = (size: CGSize(width: width, height: height), scale: CGFloat(1.0))
        if width > Math.epsilon && height > Math.epsilon && size.width > Math.epsilon && size.height > Math.epsilon {
            if (size.width / size.height) > (width / height) {
                result.scale = width / size.width
                result.size.width = width
                result.size.height = result.scale * size.height
            } else {
                result.scale = height / size.height
                result.size.width = result.scale * size.width
                result.size.height = height
            }
        }
        return result
    }
    
    func getAspectFill(_ size: CGSize) -> (size: CGSize, scale: CGFloat) {
        var result = (size: CGSize(width: width, height: height), scale: CGFloat(1.0))
        if width > Math.epsilon && height > Math.epsilon && size.width > Math.epsilon && size.height > Math.epsilon {
            if (size.width / size.height) < (width / height) {
                result.scale = width / size.width
                result.size.width = width
                result.size.height = result.scale * size.height
            } else {
                result.scale = height / size.height
                result.size.width = result.scale * size.width
                result.size.height = height
            }
        }
        return result
    }
}


