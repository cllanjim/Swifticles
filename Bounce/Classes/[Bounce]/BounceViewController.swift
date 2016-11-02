//
//  BounceViewController.swift
//
//  Created by Nicholas Raptis on 8/7/16.
//

import UIKit
import GLKit
import OpenGLES

class BounceViewController : GLViewController, UIGestureRecognizerDelegate, URLSessionDelegate {
    
    @IBOutlet weak var buttonShowHideAll:RRButton!
    @IBOutlet weak var bottomMenu:BottomMenu!
    @IBOutlet weak var topMenu:TopMenu!
    
    let engine = BounceEngine()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Make sure global reference is ready for setup.
        ApplicationController.shared.bounce = self
    }
    
    deinit {
        ApplicationController.shared.bounce = nil
    }
    
    class var shared:BounceViewController? {
        return ApplicationController.shared.bounce
    }
    
    var panRecognizer:UIPanGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    var rotRecognizer:UIRotationGestureRecognizer!
    var doubleTapRecognizer:UITapGestureRecognizer!
    
    var controlPoint = Sprite()
    var controlPointSelected = Sprite()
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    var rotRecognizerTouchCount:Int = 0
    
    var zoomGestureCancelTimer:Int = 0
    
    var gestureTouchCenter:CGPoint = CGPoint.zero
    
    var screenTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    
    private var previousScreenScale:CGFloat = 1.0
    var screenScale:CGFloat = 1.0 {
        willSet {
            previousScreenScale = screenScale
        }
        didSet {
            if previousScreenScale != screenScale {
                BounceEngine.postNotification(BounceNotification.zoomScaleChanged)
            }
        }
    }
    
    var screenEditTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenEditScale:CGFloat = 1.0
    
    var screenAnimStartTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenAnimStartScale:CGFloat = 1.0
    
    var screenAnimEndTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenAnimEndScale:CGFloat = 1.0
    
    var screenAnim:Bool = false
    var screenAnimTick:Int = 0
    var screenAnimTime:Int = 34
    
    var gestureStartTranslate:CGPoint = CGPoint.zero
    var gestureStartScale:CGFloat = 1.0
    
    var gestureStartScreenTouch:CGPoint = CGPoint.zero
    var gestureStartImageTouch:CGPoint = CGPoint.zero
    
    var appFrame:CGRect {
        return CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    var screenCenter: CGPoint {
        let fr = appFrame
        let center = CGPoint(x: fr.size.width / 2.0, y: fr.size.height / 2.0)
        return untransformPoint(center)
    }
    
    var screenFrame:CGRect {
        
        let sc = screenCenter
        let fr = appFrame
        
        let width = fr.size.width / screenScale
        let height = fr.size.height / screenScale
        
        return CGRect(x: sc.x - width / 2.0, y: sc.y - height / 2.0, width: width, height: height)
    }
    
    func setUpNew(image:UIImage, sceneRect:CGRect, portraitOrientation:Bool) {
        let scene = BounceScene()
        
        scene.imageName = Config.shared.uniqueString
        scene.imagePath = String(scene.imageName) + ".png"
        //TODO: Instead, copy this image over on 
        FileUtils.saveImagePNG(image: image, filePath: FileUtils.getDocsPath(filePath: scene.imagePath))
        
        scene.image = image
        scene.size = sceneRect.size
        scene.isLandscape = !portraitOrientation
        
        setUp(scene: scene, appFrame: appFrame)
        
        //No longer functions as an uploader mule.
        //var thumb = image.resize(CGSize(width: image.size.width * 0.16, height: image.size.height * 0.16))
        //var half = image.resize(CGSize(width: image.size.width * 0.5, height: image.size.height * 0.5))
        //Uploader.shared.upload(image: half!, thumb: thumb!, scene: scene)
        
        //http://www.froggystudios.com/bounce/upload_bounce.php
        
    }
    
    internal func setUp(scene:BounceScene, appFrame:CGRect) {
        
        
        
        
        
        //if scene.image
        
        engine.setUp(scene: scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleZoomModeChange),
                    name: NSNotification.Name(BounceNotification.zoomModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSceneModeChanged),
                    name: NSNotification.Name(BounceNotification.sceneModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditModeChanged),
                    name: NSNotification.Name(BounceNotification.editModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewModeChanged),
                    name: NSNotification.Name(BounceNotification.viewModeChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobSelectionChanged),
                    name: NSNotification.Name(BounceNotification.blobSelectionChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBlobAdded),
                    name: NSNotification.Name(BounceNotification.blobAdded.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHistoryChanged),
                    name: NSNotification.Name(BounceNotification.historyChanged.rawValue), object: nil)
        
        
        //
        
        
        
        
        
        /*
        //let oq = NSOperationQueue.mainQueue()
        let oq = OperationQueue()
        let saveOP = BlockOperation {
            
            print("saveOP...")

            
        }
        
        saveOP.completionBlock = {
            print("saveOP COMPLETE...")
        }
        oq.addOperations([saveOP], waitUntilFinished: false)
        */
        
        let recentImagePath = "recent.png"
        if scene.imageName != recentImagePath {
            FileUtils.saveImagePNG(image: scene.image, filePath: FileUtils.getDocsPath(filePath: recentImagePath))
        }
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            if scene.isLandscape == false {
                Device.orientation = .portrait
            }
        } else {
            if scene.isLandscape {
                Device.orientation = .landscapeLeft
            }
        }
        
        scene.image = nil
        
        
        
        bottomMenu?.setUp()
        topMenu?.setUp()
        
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
    
    /*
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        if engine.scene.isLandscape {
            return UIInterfaceOrientation.landscapeLeft
        } else {
            return UIInterfaceOrientation.portrait
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            BounceEngine.postNotification(BounceNotification.sceneReady)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveScene()
        saveRecentScene()
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
        
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.delegate = self
        doubleTapRecognizer.cancelsTouchesInView = false
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
        
        controlPoint.load(path: "control_point")
        controlPointSelected.load(path: "control_point_selected")
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
        
        if screenAnim {
            screenAnimTick += 1
            if screenAnimTick >= screenAnimTime {
                screenTranslation = CGPoint(x: screenAnimEndTranslation.x, y: screenAnimEndTranslation.y)
                screenScale = screenAnimEndScale
                screenAnim = false
                ApplicationController.shared.removeActionBlocker()
            } else {
                var percent = CGFloat(screenAnimTick) / CGFloat(screenAnimTime)
                percent = sin(percent * Math.PI_2)
                screenTranslation.x = screenAnimStartTranslation.x + (screenAnimEndTranslation.x - screenAnimStartTranslation.x) * percent
                screenTranslation.y = screenAnimStartTranslation.y + (screenAnimEndTranslation.y - screenAnimStartTranslation.y) * percent
                screenScale = screenAnimStartScale + (screenAnimEndScale - screenAnimStartScale) * percent
            }
        }
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let screenMat = Matrix.createOrtho(left: 0.0, right: Float(width), bottom: Float(height), top: 0.0, nearZ: -2048, farZ: 2048)
        Graphics.viewport(CGRect(x: 0.0, y: 0.0, width: appFrame.size.width * view.contentScaleFactor, height: appFrame.size.height * view.contentScaleFactor))
        Graphics.clip(clipRect: CGRect(x: 0.0, y: 0.0, width: appFrame.size.width * view.contentScaleFactor, height: appFrame.size.height * view.contentScaleFactor))
        ShaderProgramMesh.shared.matrixProjectionSet(screenMat)
        
        Graphics.clear(r: 0.15, g: 0.15, b: 0.18)
        //ShaderProgramMesh.shared.colorSet(r: 0.25, g: 0.15, b: 0.33)
        //ShaderProgramMesh.shared.rectDraw(x: 0.0, y: 0.0, width: Float(appFrame.size.width), height: Float(-appFrame.size.height))
        
        
        let viewMat = screenMat.clone()
        viewMat.translate(GLfloat(screenTranslation.x), GLfloat(screenTranslation.y), 0.0)
        viewMat.scale(Float(screenScale))
        ShaderProgramMesh.shared.matrixProjectionSet(viewMat)
        ShaderProgramMesh.shared.colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        Graphics.textureEnable()
        
        engine.draw()

        ShaderProgramMesh.shared.matrixProjectionSet(screenMat)
    }
    
    func handleZoomModeChange() {
        print("handleZoomModeChange()")
        engine.handleZoomModeChange()
        cancelAllGesturesAndTouches()
    }
    
    func handleSceneModeChanged() {
        print("handleSceneModeChanged()")
        engine.handleSceneModeChanged()
        cancelAllGesturesAndTouches()
    }
    
    func handleEditModeChanged() {
        
        print("handleEditModeChanged()")
        engine.handleEditModeChanged()
        cancelAllGesturesAndTouches()
    }
    
    func handleViewModeChanged() {
        print("handleViewModeChanged()")
        engine.handleViewModeChanged()
        cancelAllGesturesAndTouches()
    }
    
    func handleBlobAdded() {
        print("handleBlobAdded()")
        cancelAllGesturesAndTouches()
    }
    
    func handleBlobSelectionChanged() {
        print("handleBlobSelectionChanged()")
        
    }
    
    func handleHistoryChanged() {
        engine.handleHistoryChanged()
        cancelAllGesturesAndTouches()
    }
    
    func cancelAllGesturesAndTouches() {
        engine.cancelAllTouches()
        cancelAllGestureRecognizers()
        engine.cancelAllGestures()
    }
    
    func untransformPoint(_ point:CGPoint) -> CGPoint {
        return BounceEngine.untransformPoint(point: point, translation: screenTranslation, scale: screenScale, rotation: 0.0)
        //return CGPoint(x: (point.x - screenTranslation.x) / screenScale, y: (point.y - screenTranslation.y) / screenScale)
    }
    
    func transformPoint(_ point:CGPoint) -> CGPoint {
        return BounceEngine.transformPoint(point: point, translation: screenTranslation, scale: screenScale, rotation: 0.0)
        //return CGPoint(x: point.x * screenScale + screenTranslation.x, y: point.y * screenScale + screenTranslation.y)
    }
    
    //MARK: Gesture stuff, pan, pinch, etc
    private var _allowZoomGestures:Bool {
        if zoomGestureCancelTimer > 0 {
            return false
        }
        return true
    }
    
    /*
    var screenTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenScale:CGFloat = 1.0
    
    var screenEditTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenEditScale:CGFloat = 1.0
    
    var screenAnimStartTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenAnimStartScale:CGFloat = 1.0
    
    var screenAnimEndTranslation:CGPoint = CGPoint(x:0.0, y:0.0)
    var screenAnimEndScale:CGFloat = 1.0
    
    var :Bool = false
    var screenAnimTick:Int = 0
    var screenAnimTime:Int = 140
    */
    
    func animateScreenTransform(scale: CGFloat, translate: CGPoint) {
        
        if scale == screenScale && translate.equalTo(screenTranslation) {
            //Don't do anything
        } else {
            
            
            /*
            UIView.animate(withDuration: 0.4, animations: {
                [weak weakSelf = self] in
                
                weakSelf.screenScale = scale
                weakSelf.screenTranslation.x = translate.x
                weakSelf.screenTranslation.y = translate.y

                }, completion: {
                     didFinish  in
                    self.screenAnim = false
                })
            */
            
            
            ApplicationController.shared.addActionBlocker()
            
            screenAnim = true
            screenAnimTick = 0
            
            screenAnimStartScale = screenScale
            screenAnimStartTranslation = CGPoint(x: screenTranslation.x, y: screenTranslation.y)
            
            screenAnimEndScale = scale
            screenAnimEndTranslation = CGPoint(x: translate.x, y: translate.y)
        }
    }
    
    func animateScreenTransformToEdit() {
        animateScreenTransform(scale: screenEditScale, translate: screenEditTranslation)
    }
    
    func animateScreenTransformToIdentity() {
        animateScreenTransform(scale: 1.0, translate: CGPoint(x: 0.0, y: 0.0))
    }
    
    func setZoom(_ zoomScale: CGFloat) {
        //
        //Keep the screen centered as we zoom in...
        //
        let c = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height / 2.0)
        let prevCenter = untransformPoint(c)
        screenScale = zoomScale
        let newCenter = transformPoint(prevCenter)
        screenTranslation.x -= (newCenter.x - c.x)
        screenTranslation.y -= (newCenter.y - c.y)
    }
    
    func updateTransform() {
        
        
        if screenScale < ApplicationController.shared.zoomMin {
            screenScale = ApplicationController.shared.zoomMin
        } else if screenScale > ApplicationController.shared.zoomMax {
            screenScale = ApplicationController.shared.zoomMax
        }
        
        //
        //Keep the screen centered as we zoom/pan...
        //
        screenTranslation = CGPoint.zero
        let gestureStart = transformPoint(gestureStartImageTouch)
        screenTranslation.x = (gestureTouchCenter.x - gestureStart.x)
        screenTranslation.y = (gestureTouchCenter.y - gestureStart.y)
        
        //
        //... Keep bounds good.
        //
        
        
        
        screenEditScale = screenScale
        screenEditTranslation.x = screenTranslation.x
        screenEditTranslation.y = screenTranslation.y
    }
    
    func gestureBegan(_ pos:CGPoint) {
        gestureStartScreenTouch = pos
        gestureStartImageTouch = untransformPoint(pos)
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
            let panPos = untransformPoint(gestureTouchCenter)
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
            let pinchPos = untransformPoint(gestureTouchCenter)
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
            let rotPos = untransformPoint(gestureTouchCenter)
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
    
    func didDoubleTapMainThread(_ gr:UITapGestureRecognizer) -> Void {
        if ApplicationController.shared.allowInterfaceAction() {
            ToolActions.menusToggleShowing()
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
    
    func didDoubleTap(_ gr:UITapGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(didDoubleTapMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let pos = gestureRecognizer.location(in: view)
        if topMenu.frame.contains(pos) { return false }
        if bottomMenu.frame.contains(pos) { return false }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .began {
                    let location = touch.location(in: view)
                    engine.touchDown(&touch, point: untransformPoint(location))
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
                    engine.touchMove(&touch, point: untransformPoint(location))
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
                    engine.touchUp(&touch, point: untransformPoint(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    //embed_bottom_menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*
        if segue.identifier == "embed_bottom_menu" {
            if let bm = segue.destination as? BottomMenu {
                bottomMenu = bm
            }
        }
        */
        
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
        saveScene(filePath: filePath, scene: engine.scene)
    }
    
    @IBAction func clickShowHideAll(_ sender: RRButton) {
        ToolActions.menusToggleShowing()
    }
    
    func saveRecentScene() {
        let scene = engine.scene.clone
        scene.image = nil
        scene.imageName = "recent"
        scene.imagePath = String(scene.imageName) + ".png"
        saveScene(filePath: "recent_scene.json", scene:scene)
    }
    
    func saveScene(filePath: String?, scene: BounceScene) {
        if let path = filePath , path.characters.count > 0 {
            var info = [String:AnyObject]()
            
            info["scene"] = scene.save() as AnyObject?
            info["engine"] = engine.save() as AnyObject?
            
            do {
                var fileData:Data?
                try fileData = JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
                if fileData != nil {
                    _ = FileUtils.saveData(data: &fileData, filePath: FileUtils.getDocsPath(filePath: path))
                }
            } catch {
                print("Unable to save Data [\(filePath)]")
            }
        }
    }
    
    func loadScene(filePath:String?) {
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
                    
                    if let imagePath = FileUtils.findAbsolutePath(filePath: scene.imagePath) {
                        scene.image = UIImage(contentsOfFile: imagePath)
                    }
                }
                setUp(scene: scene, appFrame: appFrame)
                if let engineInfo = info["engine"] as? [String:AnyObject] {
                    engine.load(info: engineInfo)
                }
            }
        }
    }

}
