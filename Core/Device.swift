//
//  Device.swift
//
//  Created by Nicholas Raptis on 9/19/15.
//

import UIKit

class Device
{
    class var width:CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var height:CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    class var scale:CGFloat {
        return UIScreen.main.scale
    }
    
    class var portraitWidth:CGFloat {
        let checkWidth = width, checkHeight = height
        return checkWidth > checkHeight ? checkHeight : checkWidth
    }
    
    class var portraitHeight:CGFloat {
        let checkWidth = width, checkHeight = height
        return checkWidth > checkHeight ? checkWidth : checkHeight
    }

    class var landscapeWidth:CGFloat {
        return portraitHeight
    }
    
    class var landscapeHeight:CGFloat {
        return portraitWidth
    }
    
    class var isTablet:Bool {
        return width > 759.0 ? true : false
    }
    
    class var isPhone:Bool {
        return !isTablet
    }
    
    class var versionString:String {
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print(text)
            return text
        }
        return "8.0"
    }
    
    class var statusBarHeight:CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    class var orientation:UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
        set {
            UIDevice.current.setValue(newValue.rawValue, forKey: "orientation")
        }
    }
    
    class var isPortrait: Bool {
        let ori = orientation
        if ori == .portrait || ori == .portraitUpsideDown { return true }
        return false
    }
    
    class var isLandscape: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight { return true }
        return false
    }
}
