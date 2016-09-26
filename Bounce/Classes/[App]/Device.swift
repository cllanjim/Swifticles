//
//  Device.swift
//
//  Created by Nicholas Raptis on 9/19/15.
//

import UIKit

class Device
{
    //static let shared = Device()
    //private init() { }
    
    
    class var width:CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var height:CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    //if(updateTimer != nil){updateTimer.invalidate();}
    //self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
    //NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    
    
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
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
    
    class var tablet:Bool {
        return width > 759.0 ? true : false
    }
    
    
    //    if(updateTimer != nil){updateTimer.invalidate();}
    //    self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
    
    //    NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    
    
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
            //setOrientation(orientation: newValue)
        }
    }
    
    class var isPortrait: Bool {
        let ori = orientation
        if ori == .portrait || ori == .portraitUpsideDown { return true }
        return false
        
        //let device = UIDevice.current
        //return device.orientation == .portrait || device.orientation == .portraitUpsideDown
    }
    
    class var isLandscape: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight { return true }
        return false
        
        //let device = UIDevice.current
        //return device.orientation == .landscapeLeft || device.orientation == .landscapeRight
    }
    
    //func setOrientation(orientation: UIInterfaceOrientation) {
    //    UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    //}
    
    
}

//let Device.shared = Device()



