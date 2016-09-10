//
//  Device.swift
//
//  Created by Nicholas Raptis on 9/19/15.
//

import UIKit

class Device
{
    var width:CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    var height:CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    //if(updateTimer != nil){updateTimer.invalidate();}
    //self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
    //NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    
    
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    var scale:CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    var importScale:CGFloat {
        var result = scale * 2.0
        if result > 4.0 {
            result = 4.0
        }
        return result
    }
    
    var portraitWidth:CGFloat {
        let checkWidth = width, checkHeight = height
        return checkWidth > checkHeight ? checkHeight : checkWidth
    }
    
    var portraitHeight:CGFloat {
        let checkWidth = width, checkHeight = height
        return checkWidth > checkHeight ? checkWidth : checkHeight
    }

    var landscapeWidth:CGFloat {
        return portraitHeight
    }
    
    var landscapeHeight:CGFloat {
        return portraitWidth
    }
    
    var tablet:Bool {
        return width > 759.0 ? true : false
    }
    
    
    //    if(updateTimer != nil){updateTimer.invalidate();}
    //    self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
    
    //    NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    
    
    var versionString:String {
        if let text = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            print(text)
            return text
        }
        return "8.0"
    }
    
    var statusBarHeight:CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    var isPortrait: Bool {
        let device = UIDevice.currentDevice()
        return device.orientation == .Portrait || device.orientation == .PortraitUpsideDown
    }
    
    var isLandscape: Bool {
        let device = UIDevice.currentDevice()
        return device.orientation == .LandscapeLeft || device.orientation == .LandscapeRight
    }
    
    func setOrientation(orientation orientation: UIInterfaceOrientation) {
        UIDevice.currentDevice().setValue(orientation.rawValue, forKey: "orientation")
    }
    
}

let gDevice = Device()


