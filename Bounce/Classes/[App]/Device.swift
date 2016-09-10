//
//  Device.swift
//
//  Created by Nicholas Raptis on 9/19/15.
//

import UIKit

class Device
{
    var width:CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var height:CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    //if(updateTimer != nil){updateTimer.invalidate();}
    //self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
    //NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
    
    
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    var scale:CGFloat {
        return UIScreen.main.scale
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
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print(text)
            return text
        }
        return "8.0"
    }
    
    var statusBarHeight:CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    var isPortrait: Bool {
        let device = UIDevice.current
        return device.orientation == .portrait || device.orientation == .portraitUpsideDown
    }
    
    var isLandscape: Bool {
        let device = UIDevice.current
        return device.orientation == .landscapeLeft || device.orientation == .landscapeRight
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
    
}

let gDevice = Device()


