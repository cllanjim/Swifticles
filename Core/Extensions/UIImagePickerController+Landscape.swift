//
//  UIImagePickerController+Landscape.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/14/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

extension UIImagePickerController
{
    //public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        var mask = UIInterfaceOrientationMask(rawValue: 0)
        mask = mask.union(.portrait)
        mask = mask.union(.portraitUpsideDown)
        mask = mask.union(.landscapeLeft)
        mask = mask.union(.landscapeRight)
        return mask
    }
}
