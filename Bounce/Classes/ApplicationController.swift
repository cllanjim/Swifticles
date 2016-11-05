//
//  ApplicationController.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import CoreMotion

class ApplicationController
{
    
    static let shared = ApplicationController()
    private init() { }
    
    var storyboard:UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func getStoryboardVC(_ name:String) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    var appDelegate:AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    //weak internal var _navigationController:UINavigationController?
    var navigationController:UINavigationController? {
        
        if let nc = AppDelegate.root.currentViewController as? UINavigationController {
            return nc
        }
        return nil
        //if _navigationController != nil {
        //    return _navigationController!
        //} else {
            
            
            
            //_navigationController = appDelegate.window!.rootViewController as? UINavigationController
            //return _navigationController!
        //}
    }
    
    private var _actionBlockerCount: Int = 0
    
    private var _root: RootViewController?
    var root: RootViewController {
        set {
            _root = newValue
        }
        get {
            return _root!
        }
    }
    
    var motionManager: CMMotionManager {
        return root.motionManager
    }
    
    var gyroDir: CGPoint {
        var result = CGPoint.zero
        if let gyroData = ApplicationController.shared.motionManager.gyroData {
            var jerkX = CGFloat(gyroData.rotationRate.x)
            var jerkY = CGFloat(gyroData.rotationRate.y)
            let hold = jerkX
            if Device.orientation == .landscapeLeft {
                jerkX = -jerkX
            } else if Device.orientation == .landscapeRight {
                jerkY = -jerkY
            } else if Device.orientation == .portraitUpsideDown {
                jerkX = -jerkY
                jerkY = -hold
            } else {
                jerkX = jerkY
                jerkY = hold
            }
            result.x = jerkX
            result.y = jerkY
        }
        return result
    }
    
    var toolBarHeight: CGFloat {
        if Device.isTablet {
            if ApplicationController.shared.isSceneLandscape {
                return 64.0
            } else {
                return 64.0
            }
        } else {
            if ApplicationController.shared.isSceneLandscape {
                return 44.0
            } else {
                return 44.0
            }
        }
    }
    
    var tbStrokeWidth: CGFloat {
        if Device.isTablet {
            return 4.0
        } else {
            return 2.0
        }
    }
    
    var tbButtonHeight: CGFloat {
        if Device.isTablet {
            if ApplicationController.shared.isSceneLandscape {
                return 52.0
            } else {
                return 52.0
            }
        } else {
            if ApplicationController.shared.isSceneLandscape {
                return 36.0
            } else {
                return 36.0
            }
        }
    }
    
    var pointSelectDist: CGFloat {
        if Device.isTablet {
            return 62.0
        } else {
            return 48.0
        }
    }
    
    var importScale:CGFloat {
        var result = Device.scale * 2.0
        if result > 4.0 {
            result = 4.0
        }
        return result
    }
    
    weak internal var _bounce:BounceViewController?
    var bounce:BounceViewController? {
        get {
            return _bounce
        }
        set {
            _bounce = newValue
        }
    }
    
    
    private var _isSceneLandscape:Bool = false
    var isSceneLandscape:Bool {
        get {
            return _isSceneLandscape
        }
        set {
            _isSceneLandscape = newValue
        }
    }
    
    var sceneMode:SceneMode {
        get {
            if let mode = engine?.sceneMode { return mode }
            return .edit
        }
        set {
            engine?.sceneMode = newValue
        }
    }
    
    var editMode:EditMode {
        get {
            if let mode = engine?.editMode { return mode }
            return .affine
        }
        set {
            engine?.editMode = newValue
        }
    }
    
    var zoomMode:Bool {
        get {
            if engine != nil { return engine!.zoomMode }
            return true
        }
        set {
            if engine != nil { engine!.zoomMode = newValue }
        }
    }
    
    var width:CGFloat {
        if let result = bounce?.appFrame.size.width { return result }
        if Device.isLandscape {
            return Device.landscapeWidth
        } else {
            return Device.portraitWidth
        }
    }
    
    var height:CGFloat {
        if let result = bounce?.appFrame.size.height { return result }
        if Device.isLandscape {
            return Device.landscapeHeight
        } else {
            return Device.portraitHeight
        }
    }
    
    var zoomMin:CGFloat {
        if Device.isTablet {
            return 0.60
        } else {
            return 0.75
        }
    }
    
    var zoomMax:CGFloat {
        if Device.isTablet {
            return 3.5
        } else {
            return 4.25
        }
    }
    
    
    var importZoomMin:CGFloat {
        if Device.isTablet {
            return 0.5 / importScale
        } else {
            return 0.60 / importScale
        }
    }
    
    var importZoomMax:CGFloat {
        if Device.isTablet {
            return 4.0 / importScale
        } else {
            return 5.0 / importScale
        }
    }
    
    
    class var tick: Int {
        return Int(Date().timeIntervalSince1970 * 100.0)
    }
    
    class var uuid:String {
        return UUID().uuidString
    }
    
    weak internal var _engine:BounceEngine?
    var engine:BounceEngine? {
        get {
            return _engine
        }
        set {
            _engine = newValue
        }
    }
    
    var selectedBlob:Blob? {
        return engine?.selectedBlob
    }
    
    var bottomMenu:BottomMenu? {
        return bounce?.bottomMenu
    }
    
    var topMenu:TopMenu? {
        return bounce?.topMenu
    }
    
    func preloadScene(withFile filePath: String) {
        //Basically, just preload the file and figure out if it's landscape or portrait.
        if let fileData = FileUtils.loadData(filePath) {
            var parsedInfo:[String:AnyObject]?
            do {
                var jsonData:Any?
                jsonData = try JSONSerialization.jsonObject(with: fileData, options:.mutableLeaves)
                parsedInfo = jsonData as? [String:AnyObject]
            }
            catch {
                print("Unable to parse data [\(filePath)]")
            }
            if let info = parsedInfo {
                let scene = BounceScene()
                if let sceneInfo = info["scene"] as? [String:AnyObject] {
                    scene.load(info: sceneInfo)
                    isSceneLandscape = scene.isLandscape
                }
            }
        }
    }
    
    func preloadScene(withLandscape landscape: Bool) {
        isSceneLandscape = landscape
    }
    
    func canUndo() -> Bool {
        if let eng = engine {
            return eng.canUndo()
        }
        return false
    }
    
    func canRedo() -> Bool {
        if let eng = engine {
            return eng.canRedo()
        }
        return false
    }
    
    
    func allowInterfaceAction() -> Bool {
        
        
        
        return _actionBlockerCount == 0
    }
    
    func addActionBlocker() {
        _actionBlockerCount += 1
    }
    
    func removeActionBlocker() {
        _actionBlockerCount -= 1
        if _actionBlockerCount < 0 { _actionBlockerCount = 0 }
    }
    
}
