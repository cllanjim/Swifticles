//
//  BounceViewController.swift
//
//  Created by Nicholas Raptis on 8/7/16.
//

import UIKit
import GLKit
import OpenGLES

class BounceViewController : GLViewController, UIGestureRecognizerDelegate {
    
    let engine = BounceEngine()
    
    //internal var scene = BounceScene()
    
    var panRecognizer:UIPanGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    var rotRecognizer:UIRotationGestureRecognizer!;
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    var rotRecognizerTouchCount:Int = 0
    
    var zoomGestureCancelTimer:Int = 0
    
    var gestureTouchCenter:CGPoint = CGPoint.zero
    
    var screenTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenScale:CGFloat = 1.0
    
    var gestureStartTranslate:CGPoint = CGPoint.zero
    var gestureStartScale:CGFloat = 1.0
    
    var gestureStartScreenTouch:CGPoint = CGPoint.zero
    var gestureStartImageTouch:CGPoint = CGPoint.zero
    
    var screenRect:CGRect {
        return CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func setUpNew(image:UIImage, sceneRect:CGRect, portraitOrientation:Bool) {
        let scene = BounceScene()
        
        scene.imageName = gConfig.uniqueString
        scene.imagePath = String(scene.imageName) + ".png"
        FileUtils.saveImagePNG(image: image, filePath: FileUtils.getDocsPath(filePath: scene.imagePath))
        
        scene.image = image
        scene.size = sceneRect.size
        scene.isLandscape = !portraitOrientation
        
        setUp(scene: scene, screenRect: screenRect)
    }
    
    internal func setUp(scene:BounceScene, screenRect:CGRect) {
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            if scene.isLandscape == false {
                gDevice.setOrientation(orientation: .portrait)
            }
        } else {
            if scene.isLandscape {
                gDevice.setOrientation(orientation: .landscapeLeft)
            }
            
        }
        
        engine.setUp(scene: scene)
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(handleZoomModeChange),
                                                         name: NSNotification.Name(String(BounceNotification.ZoomModeChanged)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSceneModeChanged),
                                                         name: NSNotification.Name(String(BounceNotification.SceneModeChanged)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditModeChanged), name: NSNotification.Name(BounceNotification.EditModeChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewModeChanged),
                                                         name: NSNotification.Name(BounceNotification.ViewModeChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobSelectionChanged),
                                                         name: NSNotification.Name(BounceNotification.BlobSelectionChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobAdded),
                                                         name: NSNotification.Name(BounceNotification.BlobAdded), object: nil)
        */
        
        //...
        scene.image = nil
    }
    
    func handleZoomModeChange() {
        print("handleZoomModeChange()")
        cancelAllGesturesAndTouches()
    }
    
    func handleSceneModeChanged() {
        print("handleSceneModeChanged()")
        cancelAllGesturesAndTouches()
    }
    
    func handleEditModeChanged() {
        print("handleEditModeChanged()")
        cancelAllGesturesAndTouches()
    }
    
    func handleViewModeChanged() {
        print("handleViewModeChanged()")
        cancelAllGesturesAndTouches()
    }
    
    func handleBlobAdded() {
        print("handleBlobAdded()")
        //cancelAllGesturesAndTouches()
        
    }
    
    func handleBlobSelectionChanged() {
        print("handleBlobSelectionChanged()")
        //cancelAllGesturesAndTouches()
        
    }
    
    func cancelAllGesturesAndTouches() {
        print("cancelAllGesturesAndTouches()")
        engine.cancelAllTouches()
        cancelAllGestureRecognizers()
        engine.cancelAllGestures()
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if engine.scene.isLandscape {
            return [.landscapeRight, .landscapeLeft]
        } else {
            return [.portrait, .portraitUpsideDown]
        }
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        if engine.scene.isLandscape {
            return UIInterfaceOrientation.landscapeLeft
        } else {
            return UIInterfaceOrientation.portrait
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func load() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 2
        panRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        pinchRecognizer.delegate = self
        pinchRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(pinchRecognizer)
        
        rotRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotRecognizer.delegate = self
        rotRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(rotRecognizer)
    }
    
    override func update() {
        if zoomGestureCancelTimer > 0 {
            zoomGestureCancelTimer = zoomGestureCancelTimer - 1
            if zoomGestureCancelTimer <= 0 {
                panRecognizer.isEnabled = true
                pinchRecognizer.isEnabled = true
                rotRecognizer.isEnabled = true
            }
        }
        engine.update()
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let screenMat = Matrix.createOrtho(left: 0.0, right: Float(width), bottom: Float(height), top: 0.0, nearZ: -2048, farZ: 2048)
        
        gG.viewport(CGRect(x: 0.0, y: 0.0, width: screenRect.size.width * view.contentScaleFactor, height: screenRect.size.height * view.contentScaleFactor))
        
        gG.clip(clipRect: CGRect(x: 0.0, y: 0.0, width: screenRect.size.width * view.contentScaleFactor, height: screenRect.size.height * view.contentScaleFactor))
        
        gG.matrixProjectionSet(screenMat)
        gG.colorSet(r: 0.25, g: 0.15, b: 0.33)
        gG.rectDraw(x: 0.0, y: 0.0, width: Float(screenRect.size.width), height: Float(-screenRect.size.height))
        
        
        let viewMat = screenMat.clone()
        viewMat.translate(GLfloat(screenTranslation.x), GLfloat(screenTranslation.y), 0.0)
        viewMat.scale(Float(screenScale))
        gG.matrixProjectionSet(viewMat)
        
        
        
        //var m = Matrix()
        //gG.matrixModelViewSet(m)
        
        gG.blendEnable()
        gG.blendSetAlpha()
        
        gG.colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        gG.textureEnable()
        
        
        
        //background.drawCentered(pos: CGPoint(x: screenRect.midX, y: screenRect.midY))
        engine.draw()
        
        
        gG.matrixProjectionSet(screenMat)
    }
    
    func transformPointToImage(_ point:CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - screenTranslation.x) / screenScale, y: (point.y - screenTranslation.y) / screenScale)
    }
    
    func transformPointToScreen(_ point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x * screenScale + screenTranslation.x, y: point.y * screenScale + screenTranslation.y)
    }
    
    //MARK: Gesture stuff, pan, pinch, etc
    private var _allowZoomGestures:Bool {
        if zoomGestureCancelTimer > 0 {
            return false
        }
        return true
    }
    
    func updateTransform() {
        screenTranslation = CGPoint.zero
        let gestureStart = transformPointToScreen(gestureStartImageTouch)
        screenTranslation.x = (gestureTouchCenter.x - gestureStart.x)
        screenTranslation.y = (gestureTouchCenter.y - gestureStart.y)
    }
    
    func gestureBegan(_ pos:CGPoint) {
        gestureStartScreenTouch = pos
        gestureStartImageTouch = transformPointToImage(pos)
        pinchRecognizer.scale = 1.0
        panRecognizer.setTranslation(CGPoint.zero, in: view)
        gestureStartTranslate = CGPoint(x: screenTranslation.x, y: screenTranslation.y)
        gestureStartScale = screenScale
        rotRecognizer.rotation = 0.0
    }
    
    func didPanMainThread(_ gr:UIPanGestureRecognizer) -> Void {
        gestureTouchCenter = gr.location(in: self.view)
        if engine.zoomMode {
            if _allowZoomGestures == false {
                cancelAllGestureRecognizers()
                return
            }
            switch gr.state {
            case .began:
                gestureBegan(gestureTouchCenter)
                panRecognizerTouchCount = gr.numberOfTouches
                break
            case .changed:
                if panRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > panRecognizerTouchCount {
                        panRecognizerTouchCount = gr.numberOfTouches
                        gestureBegan(gestureTouchCenter)
                    }
                    else {
                        cancelAllGestureRecognizers()
                    }
                }
                break
            default:
                cancelAllGestureRecognizers()
                break
            }
            if _allowZoomGestures {
                updateTransform()
            }
        } else {
            let panPos = transformPointToImage(gestureTouchCenter)
            var panVelocity = gr.velocity(in: self.view)
            panVelocity = CGPoint(x: panVelocity.x / screenScale, y: panVelocity.y / screenScale)
            switch gr.state {
            case .began:
                panRecognizerTouchCount = gr.numberOfTouches
                engine.panBegin(pos: panPos)
                break
            case .changed:
                if panRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > panRecognizerTouchCount {
                        panRecognizerTouchCount = gr.numberOfTouches
                        engine.panBegin(pos: panPos)
                        engine.pan(pos: panPos)
                    }
                    else {
                        engine.panEnd(pos: panPos, velocity: CGPoint.zero)
                        engine.cancelAllGestures()
                    }
                } else {
                    engine.pan(pos: panPos)
                }
                break
            default:
                engine.panEnd(pos: panPos, velocity: CGPoint.zero)
                engine.cancelAllGestures()
                break
            }
        }
    }
    
    func didPinchMainThread(_ gr:UIPinchGestureRecognizer) -> Void {
        gestureTouchCenter = gr.location(in: self.view)
        if engine.zoomMode {
            if _allowZoomGestures == false {
                cancelAllGestureRecognizers()
                return
            }
            switch gr.state {
            case .began:
                gestureBegan(gestureTouchCenter)
                gestureStartScale = screenScale
                pinchRecognizerTouchCount = gr.numberOfTouches
                break
            case .changed:
                if pinchRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > pinchRecognizerTouchCount {
                        pinchRecognizerTouchCount = gr.numberOfTouches
                        gestureBegan(gestureTouchCenter)
                    }
                    else {
                        cancelAllGestureRecognizers()
                    }
                }
                break
            default:
                cancelAllGestureRecognizers()
                break
            }
            if _allowZoomGestures {
                screenScale = gestureStartScale * gr.scale
                updateTransform()
            }
        } else {
            let pinchPos = transformPointToImage(gestureTouchCenter)
            let pinchScale = gr.scale
            switch gr.state {
            case .began:
                pinchRecognizerTouchCount = gr.numberOfTouches
                engine.pinchBegin(pos: pinchPos, scale: pinchScale)
                break
            case .changed:
                if pinchRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > pinchRecognizerTouchCount {
                        pinchRecognizerTouchCount = gr.numberOfTouches
                        gr.scale = 1.0
                        engine.pinchBegin(pos: pinchPos, scale: 1.0)
                    }
                    else {
                        engine.pinchEnd(pos: pinchPos, scale: pinchScale)
                        engine.cancelAllGestures()
                        break
                    }
                } else {
                    engine.pinch(pos: pinchPos, scale: pinchScale)
                }
                break
            default:
                engine.pinchEnd(pos: pinchPos, scale: pinchScale)
                engine.cancelAllGestures()
                break
            }
        }
    }
    
    func didRotateMainThread(_ gr:UIRotationGestureRecognizer) -> Void {
        gestureTouchCenter = gr.location(in: self.view)
        if engine.zoomMode {
            if _allowZoomGestures == false {
                cancelAllGestureRecognizers()
                return
            }
            switch gr.state {
            case .began:
                gestureBegan(gestureTouchCenter)
                rotRecognizerTouchCount = gr.numberOfTouches
                break
            case .changed:
                if rotRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > rotRecognizerTouchCount {
                        rotRecognizerTouchCount = gr.numberOfTouches
                        gestureBegan(gestureTouchCenter)
                    }
                    else {
                        cancelAllGestureRecognizers()
                    }
                }
                break
            default:
                cancelAllGestureRecognizers()
                break
            }
            if _allowZoomGestures {
                updateTransform()
            }
        } else {
            let rotPos = transformPointToImage(gestureTouchCenter)
            let rot = gr.rotation
            switch gr.state {
            case .began:
                rotRecognizerTouchCount = gr.numberOfTouches
                engine.rotateBegin(pos: rotPos, radians: rot)
                break
            case .changed:
                if rotRecognizerTouchCount != gr.numberOfTouches {
                    if gr.numberOfTouches > rotRecognizerTouchCount {
                        rotRecognizerTouchCount = gr.numberOfTouches
                        gr.rotation = 0.0
                        engine.rotateBegin(pos: rotPos, radians: 0.0)
                    }
                    else {
                        engine.rotateEnd(pos: rotPos, radians: rot)
                        engine.cancelAllGestures()
                        break
                    }
                } else {
                    engine.rotate(pos: rotPos, radians: rot)
                }
                break
            default:
                engine.rotateEnd(pos: rotPos, radians: rot)
                engine.cancelAllGestures()
                gr.rotation = 0.0
                break
            }
        }
    }
    
    func cancelAllGestureRecognizers() {
        zoomGestureCancelTimer = 3
        panRecognizer.isEnabled = false
        pinchRecognizer.isEnabled = false
        rotRecognizer.isEnabled = false
    }
    
    func didPan(_ gr:UIPanGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(ImageImportViewController.didPanMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func didPinch(_ gr:UIPinchGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(didPinchMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func didRotate(_ gr:UIRotationGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(didRotateMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .began {
                    let location = touch.location(in: view)
                    engine.touchDown(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .moved {
                    let location = touch.location(in: view)
                    engine.touchMove(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .ended || touch.phase == .cancelled {
                    let location = touch.location(in: view)
                    engine.touchUp(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    
    
    func saveScene() {
        print("************\nBounceEngine.save()")
        
        if engine.scene.scenePath == nil {
            engine.scene.scenePath = engine.scene.imageName + "_info.json"
        }
        
        saveScene(filePath: engine.scene.scenePath)
        
        
        
        
    }
    
    func loadScene() {
        print("************\nBounceEngine.load()")
        
        
    }
    
    
    func saveScene(filePath:String?) {
        print("************\nBounceEngine.save(\(filePath))")
        
        if let path = filePath , path.characters.count > 0 {
            
            var info = [String:AnyObject]()
            
            info["scene"] = engine.scene.save() as AnyObject?
            info["engine"] = engine.save() as AnyObject?
            
            info["test_1"] = "t-1" as AnyObject?
            info["test_2"] = "t-2" as AnyObject?
            
            print("Save\(info)")
            
            do {
                var fileData:Data?
                try fileData = JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
                if fileData != nil {
                    FileUtils.saveData(data: &fileData, filePath: FileUtils.getDocsPath(filePath: path))
                }
            } catch {
                print("Unable to save Data [\(filePath)]")
            }
        }
        
        
        
        
    }
    
    func loadScene(filePath:String?) {
        print("************\nBounceEngine.load()")
        
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
                
                
                //if let info = NSKeyedUnarchiver.unarchiveObjectWithData(fileData) as? [String:AnyObject] {
                
                print("Loaded [\(info)]")
                
                var scene = BounceScene()
                
                if let sceneInfo = info["scene"] as? [String:AnyObject] {
                    scene.load(info: sceneInfo)
                    
                    if let imagePath = FileUtils.findAbsolutePath(filePath: scene.imagePath) {
                        scene.image = UIImage(contentsOfFile: imagePath)
                    }
                }
                
                setUp(scene: scene, screenRect: screenRect)
                
                print("______")
                print(info["engine"])
                print("______")
                
                if let engineInfo = info["engine"] as? [String:AnyObject] {
                    
                    engine.load(info: engineInfo)
                    
                }
            }
        }
    }
    
    
    
    deinit {
        print("Deinit \(self)")
    }

}
