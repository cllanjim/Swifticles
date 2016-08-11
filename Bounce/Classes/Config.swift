//
//  Config.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit



class Config
{
    
    
//    //if(updateTimer != nil){updateTimer.invalidate();}
//    //self.updateTimer = NSTimer(timeInterval: (1 / 60.0), target: self, selector: "update", userInfo: nil, repeats: true);
//    //NSRunLoop.mainRunLoop().addTimer(self.updateTimer, forMode: NSRunLoopCommonModes);
//    
//    
//    //let screenSize: CGRect = UIScreen.mainScreen().bounds
//    
//    
//    var scale:CGFloat {
//        return 2.0
//    }
//    
//    var importScale:CGFloat {
//        return scale * 2.0
//    }
//    
//    var portraitWidth:CGFloat {
//        
//        //let size = UIApplication.
//        
//        
//    }
    
    
    func fontName() -> String{return String("Arial")}
    func fontNameBold() -> String{return String("Arial-BoldMT")}
    
    func fontCellValue() -> UIFont! {
        return UIFont(name: fontName(), size: 16.0)
    }
    
    func fontCellSubtitle() -> UIFont! {
        return UIFont(name: fontName(), size: 11.0)
    }
    
    func fontCellHeaderBold() -> UIFont! {
        return UIFont(name: fontNameBold(), size: 22.0)
    }
    
    class var shared: Config {
        struct Static {
            static var cTokenOnce:dispatch_once_t = 0;
            static var cInstance: Config?;
        }
        dispatch_once(&Static.cTokenOnce) {
            Static.cInstance = Config()
        }
        return Static.cInstance!
    }
}

let gConfig = Config()//Config.shared;
