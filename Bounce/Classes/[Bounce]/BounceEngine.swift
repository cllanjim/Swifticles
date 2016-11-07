//
//  BounceEngine.swift
//
//  Created by Raptis, Nicholas on 8/24/16.
//

import UIKit

import Foundation

enum BounceNotification:String {
    case sceneReady = "BounceNotification.sceneReady"
    case zoomModeChanged = "BounceNotification.zoomModeChanged"
    case zoomModeChangedForced = "BounceNotification.zoomModeChangedForced"
    case zoomScaleChanged = "BounceNotification.zoomScaleChanged"
    case sceneModeChanged = "BounceNotification.sceneModeChanged"
    case editModeChanged = "BounceNotification.editModeChanged"
    case viewModeChanged = "BounceNotification.viewModeChanged"
    case blobAdded = "BounceNotification.vlobAdded"
    case blobSelectionChanged = "BounceNotification.blobSelectionChanged"
    case historyChanged = "BounceNotification.historyStackChanged"
}

enum SceneMode: UInt32 { case edit = 1, view = 2 }
enum EditMode: UInt32 { case affine = 1, shape = 2, distribution = 3 }
enum ViewMode: UInt32 { case grab = 1, animation = 2 }

class BounceEngine {
    
    required init() {
        ApplicationController.shared.engine = self
    }
    
    deinit {
        ApplicationController.shared.engine = nil
    }
    
    class var shared:BounceEngine? {
        return ApplicationController.shared.engine
    }
    
    private var _zoomMode:Bool = false
    var zoomMode:Bool {
        get {
            return _zoomMode
        }
        set {
            if newValue != _zoomMode {
                _zoomMode = newValue
                BounceEngine.postNotification(BounceNotification.zoomModeChanged)
            }
        }
    }
    
    var zoomModeForced:Bool {
        get {
            return _zoomMode
        }
        set {
            if newValue != _zoomMode {
                _zoomMode = newValue
                BounceEngine.postNotification(BounceNotification.zoomModeChangedForced)
            }
        }
    }
    
    var historyStack = [HistoryState]()
    var historyIndex: Int = 0
    var historyLastActionUndo: Bool = false
    var historyLastActionRedo: Bool = false
    
    private var _stereoscopic: Bool = false
    var stereoscopic: Bool {
        get {
            
            if _stereoscopic && sceneMode == .view {
            if let bounce = ApplicationController.shared.bounce {
                if fabs(bounce.screenTranslation.x) < 0.1 && fabs(bounce.screenTranslation.y) < 0.1 && fabs(bounce.screenScale - 1.0) < 0.05 {
                    
                    return true
                }
            }
            }
            
            return false
            
        }
        set {
            _stereoscopic = newValue
        }
    }
    
    var stereoscopicHD: Bool = false
    
    private var _gyro: Bool = true
    var gyro: Bool {
        get {
            return _gyro// && sceneMode == .view
        }
        set {
            _gyro = newValue
        }
    }
    
    var stereoscopicChannel: Bool = false
    
    //Good # = 16.0
    private var _stereoscopicSpreadOffset: CGFloat = 16.0
    var stereoscopicSpreadOffset: CGFloat {
        if stereoscopicChannel {
            return -_stereoscopicSpreadOffset
        } else {
            return _stereoscopicSpreadOffset
        }
    }
    
    //Good # = 1.6
    private var _stereoscopicSpreadBase:CGFloat = 1.6
    var stereoscopicSpreadBase: CGFloat {
        if stereoscopicChannel {
            return _stereoscopicSpreadBase
        } else {
            return -_stereoscopicSpreadBase
        }
    }
    
    
    
    var blobs = [Blob]()
    
    internal var previousSelectedBlob:Blob?
    var selectedBlob:Blob? {
        willSet {
            previousSelectedBlob = selectedBlob
            if let blob = previousSelectedBlob {
                blob.selected = false
            }
            
            //selected
            
        }
        didSet {
            if previousSelectedBlob !== selectedBlob {
                BounceEngine.postNotification(BounceNotification.blobSelectionChanged, object: selectedBlob)
            }
            if let blob = selectedBlob {
                blob.selected = true
            }
        }
    }
    
    func reset() {
        historyClear()
        deleteAllBlobs()
    }
    
    func deleteAllBlobs() {
        var temp = [Blob]()
        for blob:Blob in blobs { temp.append(blob) }
        for blob:Blob in temp { deleteBlob(blob) }
    }
    
    
    func freeze() {
        
        stereoscopicBlendBackgroundData = nil
        stereoscopicBlendBackground.clear()
        stereoscopicBlendTexture.clear()
        
        cancelAllTouches()
        cancelAllGestures()
    }
    
    func unfreeze() {
        
    }
    
    var editShowEdgeWeight: Bool = false
    var editShowCenterWeight: Bool = true
    
    //For the affine transformations only..
    weak var _affineSelectionBlob:Blob?
    var affineSelectionBlob:Blob? {
        
        get {
            return _affineSelectionBlob
        }
        
        set {
            let blob = _affineSelectionBlob
            _affineSelectionBlob = newValue
            
            if blob !== newValue && blob !== nil && affineSelectionDidChange == true {
                affineSelectionDidChange = false
                
                let historyState = HistoryStateChangeAffine()
                historyState.blobIndex = indexOf(blob: blob!)
                historyState.startPos = affineSelectionStartCenter
                historyState.startScale = affineSelectionStartScale
                historyState.startRotation = affineSelectionStartRotation
                historyState.endPos = blob!.center
                historyState.endScale = blob!.scale
                historyState.endRotation = blob!.rotation
                historyAdd(withState: historyState)
            }
        }
    }
    weak var affineSelectionTouch:UITouch?
    var historyStateAffine:HistoryStateChangeAffine?
    var affineGestureStartCenter:CGPoint = CGPoint.zero
    var affineGestureCenter:CGPoint = CGPoint.zero
    var affineSelectionStartCenter:CGPoint = CGPoint.zero
    var affineSelectionStartScale:CGFloat = 1.0
    var affineSelectionStartRotation:CGFloat = 0.0
    var affineSelectionDidChange: Bool = false
    
    
    
    weak var _shapeSelectionBlob:Blob?
    var shapeSelectionBlob:Blob? {
        get {
            return _shapeSelectionBlob
        }
        
        set {
            let blob = _shapeSelectionBlob
            _shapeSelectionBlob = newValue
            
            if blob !== newValue && blob !== nil && shapeSelectionDidChange == true {
                shapeSelectionDidChange = false
                
                let historyState = HistoryStateChangeShape()
                historyState.blobIndex = indexOf(blob: blob!)
                historyState.startSplineData = shapeSelectionStartSpline.save()
                historyState.endSplineData = blob!.spline.save()
                historyAdd(withState: historyState)
            }
        }
    }
    weak var shapeSelectionTouch:UITouch?
    var shapeSelectionOffset:CGPoint = CGPoint.zero
    var shapeSelectionControlPointIndex:Int?
    var shapeSelectionStartSpline = CubicSpline()
    var shapeSelectionDidChange: Bool = false
    
    
    
    
    weak var _weightSelectionBlob:Blob?
    var weightSelectionBlob:Blob? {
        
        get {
            return _weightSelectionBlob
        }
        
        set {
            let blob = _weightSelectionBlob
            _weightSelectionBlob = newValue
            
            if blob !== newValue && blob !== nil && affineSelectionDidChange == true {
                weightSelectionDidChange = false
                
                /*
                 let historyState = HistoryStateChangeAffine()
                 historyState.blobIndex = indexOf(blob: blob!)
                 historyState.startPos = affineSelectionStartCenter
                 historyState.startScale = affineSelectionStartScale
                 historyState.startRotation = affineSelectionStartRotation
                 historyState.endPos = blob!.center
                 historyState.endScale = blob!.scale
                 historyState.endRotation = blob!.rotation
                 historyAdd(withState: historyState)
                 */
            }
        }
    }
    weak var weightSelectionTouch:UITouch?
    //var historyStateWeight:HistoryStateChangeAffine?
    
    var weightSelectionStartCenter:CGPoint = CGPoint.zero
    var weightSelectionStartTouch:CGPoint = CGPoint.zero
    var weightSelectionStartScale:CGFloat = 1.0
    var weightSelectionStartRotation:CGFloat = 0.0
    var weightSelectionDidChange: Bool = false
    
    
    
    var scene = BounceScene()
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    func setStereoscopicBlendBackground(stereoscopicImage: UIImage?) {
        if let image = stereoscopicImage {
            var textureWidth:GLsizei = 0
            var textureHeight:GLsizei = 0
            var scaledWidth:GLsizei = 0
            var scaledHeight:GLsizei = 0
            if stereoscopicBlendTexture.bindIndex == nil || stereoscopicBlendBackgroundData == nil {
                stereoscopicBlendBackgroundData = Texture.Load(image: image, textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
                stereoscopicBlendTexture.Load(data: &(stereoscopicBlendBackgroundData!), textureWidth: Int(textureWidth), textureHeight: Int(textureHeight), scaledWidth: Int(scaledWidth), scaledHeight: Int(scaledHeight))
                stereoscopicBlendBackground.load(texture: stereoscopicBlendTexture)
                stereoscopicBlendBackground.startX = 0.0
                stereoscopicBlendBackground.startY = 0.0
                stereoscopicBlendBackground.endX = ApplicationController.shared.bounce!.screenFrame.size.width
                stereoscopicBlendBackground.endY = ApplicationController.shared.bounce!.screenFrame.size.height
            } else {
                Texture.LoadOver(image: image, data: &(stereoscopicBlendBackgroundData!), textureWidth: &textureWidth, textureHeight: &textureHeight, scaledWidth: &scaledWidth, scaledHeight: &scaledHeight)
                stereoscopicBlendTexture.loadOver(imageData: &(stereoscopicBlendBackgroundData!))
            }
        }
    }
    
    //stereoscopicBlendTex
    
    //var stereoscopicImage: UIImage
    var stereoscopicBlendBackgroundData:UnsafeMutableRawPointer?
    var stereoscopicBlendTexture = Texture()
    var stereoscopicBlendBackground = Sprite()
    
    
    
    var touchPoint:CGPoint = CGPoint.zero
    
    var sceneRect:CGRect = CGRect.zero {
        didSet {
            background.startX = sceneRect.origin.x
            background.startY = sceneRect.origin.y
            background.endX = (sceneRect.origin.x + sceneRect.size.width)
            background.endY = (sceneRect.origin.y + sceneRect.size.height)
        }
    }
    
    var sceneMode:SceneMode = .edit {
        
        willSet {
            if sceneMode != newValue {
                if newValue == .edit {
                    ApplicationController.shared.bounce?.animateScreenTransformToEdit()
                } else if newValue == .view {
                    ApplicationController.shared.bounce?.animateScreenTransformToIdentity()
                }
            }
        }
        
        didSet {
            zoomModeForced = false
            handleModeChange()
            BounceEngine.postNotification(BounceNotification.sceneModeChanged)
        }
    }
    
    //internal var previousEditMode:EditMode = .affine
    var editMode:EditMode = .affine {
        didSet {
            handleModeChange()
            BounceEngine.postNotification(BounceNotification.editModeChanged)
        }
    }
    
    var deletedBlobs = [Blob]()
    func deleteBlob(_ blob:Blob?) {
        
        if let deleteBlob = blob {
            
            deletedBlobs.append(deleteBlob)
            
            if affineSelectionBlob === deleteBlob {
                affineSelectionBlob = nil
                affineSelectionTouch = nil
            }
            if shapeSelectionBlob === deleteBlob {
                shapeSelectionBlob = nil
                shapeSelectionTouch = nil
            }
            if weightSelectionBlob === deleteBlob {
                weightSelectionBlob = nil
                weightSelectionTouch = nil
            }
            
            var deleteIndex:Int?
            for i in 0..<blobs.count {
                if blobs[i] === deleteBlob {
                    deleteIndex = i
                }
            }
            if let index = deleteIndex {
                blobs.remove(at: index)
            }
        }
    }
    
    func handleModeChange() {
        cancelAllTouches()
        cancelAllGestures()
        
    }
    
    func setUp(scene:BounceScene) {//, appFrame:CGRect) {
        self.scene = scene
        let screenSize = scene.isLandscape ? CGSize(width: Device.landscapeWidth, height: Device.landscapeHeight) : CGSize(width: Device.portraitWidth, height: Device.portraitHeight)
        
        if let image = scene.image , image.size.width > 32 && image.size.height > 32 {
            
            
            //If the image is too large for the device, shrink it down.
            let widthRatio = (Double(screenSize.width) * Double(Device.scale)) / Double(image.size.width)
            let heightRatio = (Double(screenSize.height) * Double(Device.scale)) / Double(image.size.height)
            let ratio = min(widthRatio, heightRatio)
            if ratio < 0.999 {
                //This basically means that we've imported an image from
                //a different device.
                
                let importWidth = CGFloat(Int(Double(image.size.width) * ratio + 0.5))
                let importHeight = CGFloat(Int(Double(image.size.height) * ratio + 0.5))
                print("Import Resized [\(image.size.width) x \(image.size.height)] ->\n[\(importWidth) x \(importHeight)]")
                scene.image = image.resize(CGSize(width: importWidth, height: importHeight))
                
                //TODO: Re-save the image here?
                //scene.imageName = Config.shared.uniqueString
                //scene.imagePath = String(scene.imageName).stringByAppendingString(".png")
                //FileUtils.saveImagePNG(image: image, filePath: FileUtils.getDocsPath(filePath: scene.imagePath))
            }
            
            backgroundTexture.load(image: scene.image)
            background.load(texture: backgroundTexture)
            
            //Center the image on the screen,
            if screenSize.width > 64 && screenSize.height > 64 && image.size.width > 64 && image.size.height > 64 {
                let widthRatio = Double(screenSize.width) / Double(image.size.width)
                let heightRatio = Double(screenSize.height) / Double(image.size.height)
                let ratio = min(widthRatio, heightRatio)
                let sceneWidth = CGFloat(Int(Double(image.size.width) * ratio + 0.5))
                let sceneHeight = CGFloat(Int(Double(image.size.height) * ratio + 0.5))
                let sceneX = CGFloat(Int(screenSize.width / 2.0 - sceneWidth / 2.0 + 0.25))
                let sceneY = CGFloat(Int(screenSize.height / 2.0 - sceneHeight / 2.0 + 0.25))
                self.sceneRect = CGRect(x: sceneX, y: sceneY, width: sceneWidth, height: sceneHeight)
            }
        }
    }
    
    func update() {
        for blob:Blob in blobs {
            if blob.enabled { blob.update() }
        }
    }
    
    func draw() {
        
        if stereoscopic {
            
            let holdMat = ShaderProgramMesh.shared.matrixProjectionGet()
            let mat = Matrix(holdMat)
            mat.translate(stereoscopicSpreadBase, 0.0, 0.0)
            ShaderProgramMesh.shared.matrixProjectionSet(mat)
            if stereoscopicChannel {
                background.setColor(0.0, 1.0, 1.0, 1.0)
            } else {
                background.setColor(1.0, 0.0, 0.0, 1.0)
            }
            background.draw()
            ShaderProgramMesh.shared.matrixProjectionSet(holdMat)
        } else {
            background.setColor(1.0, 1.0, 1.0, 1.0)
            background.draw()
        }
        
        
        
        
        
        
        
        ShaderProgramMesh.shared.colorSet()
        
        if sceneMode == .view {
            Graphics.depthEnable()
            Graphics.depthClear()
        }
        
        for blob:Blob in blobs {
            if blob.enabled {
                blob.drawMesh()
            }
        }
        
        Graphics.depthClear()
        Graphics.depthDisable()
        
        for blob:Blob in blobs {
            if blob.enabled {
                blob.drawMarkers()
            }
        }
        
        ShaderProgramMesh.shared.colorSet()
        
        if stereoscopic && stereoscopicChannel == true && stereoscopicBlendBackground.texture != nil {
            Graphics.blendEnable()
            Graphics.blendSetAdditive()
            stereoscopicBlendBackground.draw()
            Graphics.blendSetAlpha()
        }
    }
    
    func touchDown(_ touch:inout UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
        
        //selectedBlob
        let touchBlob = selectBlobAtPoint(point)
        
        if sceneMode == .view {
            
            //TODO: Find better way to handle multi-touch overlapping blobs here.
            if let blob = touchBlob {
                
                if blob.grabSelectionTouch === nil {
                    blob.grabSelectionTouch = touch
                    blob.grabSelection = touchPoint
                    blob.grabAnimationGuideOffsetStart = blob.animationGuideOffset
                    blob.grabAnimationGuideTouchStart = touchPoint
                }
            }
            
            //weak var grabSelectionTouch:UITouch?
            //var grabAnimationGuideOffsetStart:CGPoint = CGPoint(x: 0.0, y: 0.0)
            
            
        }
        
        if sceneMode == .edit && editMode == .affine {
            if affineSelectionTouch === nil {
                affineSelectionBlob = touchBlob
                if let checkAffineSelectedBlob = affineSelectionBlob {
                    affineSelectionDidChange = false
                    selectedBlob = checkAffineSelectedBlob
                    affineSelectionTouch = touch
                    affineSelectionStartCenter = checkAffineSelectedBlob.center
                    affineSelectionStartScale = checkAffineSelectedBlob.scale
                    affineSelectionStartRotation = checkAffineSelectedBlob.rotation
                } else {
                    
                    // Touch outside all blobs = deselect
                    if affineSelectionTouch === nil && touchBlob === nil {
                        selectedBlob = nil
                    }
                    
                    affineSelectionDidChange = false
                    affineSelectionBlob = nil
                    affineSelectionTouch = nil
                }
            }
        }
        
        if sceneMode == .edit && editMode == .shape {
            var closest:(index:Int, distance:CGFloat)?
            var editBlob:Blob?
            var offset:CGPoint = CGPoint.zero
            for blob:Blob in blobs {
                if blob.selectable {
                    let pointInBlob = blob.untransformPoint(point: point)
                    if let c = blob.spline.getClosestControlPoint(point: pointInBlob) {
                        var pick:Bool = false
                        if closest == nil {
                            pick = true
                        } else if c.distance < closest!.distance {
                            pick = true
                        }
                        if pick {
                            closest = c
                            editBlob = blob
                            var controlPoint = blob.spline.getControlPoint(c.index)
                            controlPoint = blob.transformPoint(point: controlPoint)
                            offset.x = controlPoint.x - point.x
                            offset.y = controlPoint.y - point.y
                        }
                    }
                }
            }
            
            if let blob = editBlob , shapeSelectionTouch === nil {
                selectedBlob = blob
                
                if closest!.distance < ApplicationController.shared.pointSelectDist {
                    shapeSelectionDidChange = false
                    shapeSelectionBlob = blob
                    shapeSelectionStartSpline = blob.spline.clone()
                    shapeSelectionTouch = touch
                    shapeSelectionControlPointIndex = closest!.index
                    shapeSelectionOffset = offset
                } else {
                    if shapeSelectionTouch === nil && touchBlob === nil {
                        selectedBlob = nil
                    }
                }
            }
        }
        
        
        if sceneMode == .edit && editMode == .distribution {
            
            //for
            
            var pickBlob: Blob?
            var bestDist: CGFloat?
            
            for i in stride(from: blobs.count - 1, to: -1, by: -1) {
                let blob = blobs[i]
                if blob.selectable {
                    let weightCenter = blob.weightCenter
                    let diffX = weightCenter.x - point.x
                    let diffY = weightCenter.y - point.y
                    let dist = diffX * diffX + diffY * diffY
                    if bestDist == nil {
                        bestDist = dist
                        pickBlob = blob
                    } else {
                        if bestDist! > dist {
                            pickBlob = blob
                            bestDist = dist
                        }
                    }
                }
            }
            
            if bestDist != nil {
                if bestDist! > Math.epsilon {
                    bestDist = CGFloat(sqrtf(Float(bestDist!)))
                }
                if bestDist! > ApplicationController.shared.pointSelectDist {
                    pickBlob = nil
                }
            }
            
            //
            
            //if pickBlob === nil {
            //    pickBlob = touchBlob
            //}
            
            
            
            if pickBlob != nil && weightSelectionBlob === nil && weightSelectionTouch === nil {
                selectedBlob = pickBlob
                weightSelectionBlob = pickBlob
                weightSelectionTouch = touch
                weightSelectionStartCenter = pickBlob!.weightCenter
                weightSelectionStartTouch = point
                weightSelectionStartScale = pickBlob!.weightScale
            } else {
                if weightSelectionTouch === nil {
                    selectedBlob = touchBlob
                }
            }
            
            /*
             if affineSelectionBlob == nil {
             affineSelectionBlob = touchBlob
             if let checkAffineSelectedBlob = affineSelectionBlob {
             affineSelectionDidChange = false
             selectedBlob = checkAffineSelectedBlob
             affineSelectionTouch = touch
             affineSelectionStartCenter = checkAffineSelectedBlob.center
             affineSelectionStartScale = checkAffineSelectedBlob.scale
             affineSelectionStartRotation = checkAffineSelectedBlob.rotation
             } else {
             affineSelectionDidChange = false
             affineSelectionBlob = nil
             affineSelectionTouch = nil
             }
             }
             */
            
            
            
            
        }
        
        //distributionCenter
        
        
    }
    
    func touchMove(_ touch:inout UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
        
        if sceneMode == .view {
            
            for blob in blobs {
                if blob.grabSelectionTouch === touch {
                    
                    let diffX = touchPoint.x - blob.grabAnimationGuideTouchStart.x
                    let diffY = touchPoint.y - blob.grabAnimationGuideTouchStart.y
                    
                    blob.grabSelection = touchPoint
                    blob.animationGuideOffset.x = blob.grabAnimationGuideOffsetStart.x + diffX
                    blob.animationGuideOffset.y = blob.grabAnimationGuideOffsetStart.y + diffY
                    
                }
            }
        }
        
        if sceneMode == .edit && editMode == .shape {
            if let blob = shapeSelectionBlob , touch === shapeSelectionTouch {
                if let index = shapeSelectionControlPointIndex {
                    
                    shapeSelectionDidChange = true
                    
                    //let pointInBlob = blob.untransformPoint(point: point)
                    let pointInBlob = blob.untransformPoint(point: CGPoint(x: point.x + shapeSelectionOffset.x, y: point.y + shapeSelectionOffset.y))
                    
                    blob.spline.set(index, x: pointInBlob.x, y: pointInBlob.y)
                    blob.setNeedsComputeShape()
                }
            }
        }
        
        if sceneMode == .edit && editMode == .distribution {
            if let blob = weightSelectionBlob , touch === weightSelectionTouch {
                let offset = CGPoint(x: point.x - weightSelectionStartTouch.x, y: point.y - weightSelectionStartTouch.y)
                blob.weightCenter = CGPoint(x: weightSelectionStartCenter.x + offset.x, y: weightSelectionStartCenter.y + offset.y)
            }
        }
        
    }
    
    func touchUp(_ touch:inout UITouch, point:CGPoint) {
        
        
        for blob in blobs {
            if blob.grabSelectionTouch === touch {
                blob.releaseGrabFling()
                blob.grabSelectionTouch = nil
            }
        }
        
        
        
        if touch === affineSelectionTouch {
            affineSelectionTouch = nil
            affineSelectionBlob = nil
        }
        if touch === shapeSelectionTouch {
            shapeSelectionTouch = nil
            shapeSelectionBlob = nil
        }
        
        if touch === weightSelectionTouch {
            weightSelectionTouch = nil
            weightSelectionBlob = nil
        }
    }
    
    //this may be called extremely frequently.
    func cancelAllTouches() {
        affineSelectionBlob = nil
        affineSelectionTouch = nil
        
        shapeSelectionTouch = nil
        shapeSelectionBlob = nil
        shapeSelectionControlPointIndex = nil
        
        weightSelectionBlob = nil
        weightSelectionTouch = nil
        
        affineSelectionDidChange = false
        shapeSelectionDidChange = false
        weightSelectionDidChange = false
    }
    
    
    var isPanning:Bool = false
    var panStartPos:CGPoint = CGPoint.zero
    var panPos:CGPoint = CGPoint.zero
    
    func panBegin(pos:CGPoint) {
        if isPanning {
            panEnd(pos: pos, velocity: CGPoint.zero)
        }
        isPanning = true
        panStartPos = pos
        panPos = pos
        affineGestureCenter = pos
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectionBlob {
                affineSelectionStartCenter = blob.center
                affineGestureStartCenter = blob.untransformPoint(point: pos)
            }
            gestureUpdateAffine()
        }
    }
    
    func pan(pos:CGPoint) {
        guard isPanning else { return }
        panPos = pos
        affineGestureCenter = pos
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine { gestureUpdateAffine() }
    }
    
    func panEnd(pos:CGPoint, velocity:CGPoint) {
        guard isPanning else { return }
        panPos = pos
        isPanning = false
    }
    
    var isPinching:Bool = false
    var pinchScale:CGFloat = 1.0
    var pinchStartPos:CGPoint = CGPoint.zero
    var pinchPos:CGPoint = CGPoint.zero
    func pinchBegin(pos:CGPoint, scale:CGFloat) {
        if isPinching {
            pinchEnd(pos: pos, scale: pinchScale)
            isPinching = false
        }
        isPinching = true
        pinchStartPos = pos
        pinchPos = pos
        affineGestureCenter = pos
        pinchScale = scale
        
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectionBlob {
                affineGestureStartCenter = blob.untransformPoint(point: pos)
            }
            gestureUpdateAffine()
        }
        
        if sceneMode == .edit && editMode == .distribution {
            if let blob = weightSelectionBlob {
                weightSelectionStartScale = blob.weightScale
            }
        }
        
        
    }
    
    func pinch(pos:CGPoint, scale:CGFloat) {
        guard isPinching else { return }
        pinchPos = pos
        pinchScale = scale
        affineGestureCenter = pos
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine { gestureUpdateAffine() }
        
        if sceneMode == .edit && editMode == .distribution {
            if let blob = weightSelectionBlob {
                blob.weightScale = weightSelectionStartScale * scale
            }
        }
        
        
    }
    
    func pinchEnd(pos:CGPoint, scale:CGFloat) {
        guard isPinching else { return }
        pinchPos = pos
        pinchScale = scale
        isPinching = false
    }
    
    var isRotating:Bool = false
    var rotation:CGFloat = 0.0
    var rotationStartPos:CGPoint = CGPoint.zero
    var rotationPos:CGPoint = CGPoint.zero
    func rotateBegin(pos:CGPoint, radians:CGFloat) {
        if isRotating {
            rotateEnd(pos: pos, radians: radians)
            isRotating = false
        }
        isRotating = true
        rotationStartPos = pos
        rotationPos = pos
        rotation = radians
        affineGestureCenter = pos
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectionBlob {
                affineGestureStartCenter = blob.untransformPoint(point: pos)
            }
            gestureUpdateAffine()
        }
    }
    
    func rotate(pos:CGPoint, radians:CGFloat) {
        guard isRotating else { return }
        rotationPos = pos
        rotation = radians
        affineGestureCenter = pos
        if affineSelectionBlob != nil {
            affineSelectionDidChange = true
        }
        if sceneMode == .edit && editMode == .affine { gestureUpdateAffine() }
    }
    
    func rotateEnd(pos:CGPoint, radians:CGFloat) {
        guard isRotating else { return }
        rotationPos = pos
        rotation = radians
        isRotating = false
    }
    
    func cancelAllGestures() {
        isPanning = false
        isPinching = false
        isRotating = false
        affineSelectionBlob = nil
        affineSelectionTouch = nil
        affineSelectionDidChange = false
    }
    
    
    
    class func postNotification(_ notificationName: BounceNotification) {
        let notification = Notification(name: Notification.Name(notificationName.rawValue), object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    class func postNotification(_ notificationName: BounceNotification, object: AnyObject?) {
        let notification = Notification(name: Notification.Name(notificationName.rawValue), object: object, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func handleZoomModeChanged() {
        for blob in blobs {
            if blob.enabled { blob.handleZoomModeChanged() }
        }
    }
    
    func handleSceneModeChanged() {
        for blob in blobs {
            if blob.enabled { blob.handleSceneModeChanged() }
        }
    }
    
    func handleEditModeChanged() {
        for blob in blobs {
            if blob.enabled { blob.handleEditModeChanged() }
        }
    }
    
    func handleViewModeChanged() {
        for blob in blobs {
            if blob.enabled { blob.handleViewModeChanged() }
        }
    }
    
    func handleHistoryChanged() {
        
        
    }
    
    func addBlob() {
        
        if blobs.count >= 8 {
            //LOL
            return
        }
        
        let blob = Blob()
        
        blob.center.x = sceneRect.origin.x + 50
        blob.center.y = sceneRect.origin.y + sceneRect.size.height / 2.0
        
        while anyBlobOnPoint(blob.center) {
            blob.center.x += 30.0
        }
        
        addBlob(blob)
    }
    
    func addBlob(_ blob: Blob) {
        blobs.append(blob)
        selectedBlob = blob
        if let checkBlob = selectedBlob {
            let historyState = HistoryStateAddBlob()
            historyState.blobIndex = indexOf(blob: checkBlob)
            historyState.blobData = checkBlob.save()
            historyAdd(withState: historyState)
        }
        BounceEngine.postNotification(.blobAdded)
    }
    
    func cloneSelectedBlob() {
        if selectedBlob != nil {
            let blob = Blob()
            blob.load(info: selectedBlob!.save())
            while anyBlobOnPoint(blob.center) {
                blob.center.x += 30.0
            }
            addBlob(blob)
        }
    }
    
    func deleteSelectedBlob() {
        if let blob = selectedBlob {
            let historyState = HistoryStateDeleteBlob()
            historyState.blobIndex = indexOf(blob: blob)
            historyState.blobData = blob.save()
            historyAdd(withState: historyState)
            
            deleteBlob(blob)
        }
    }
    
    
    func indexOf(blob: Blob?) -> Int? {
        if blob != nil {
            for i in 0..<blobs.count {
                if blobs[i] === blob {
                    return i
                }
            }
        }
        return nil
    }
    
    func anyBlobOnPoint(_ pos:CGPoint) -> Bool {
        
        if blobs.count <= 0 {
            return false
        } else {
            if closestBlobCenterDistanceSquared(pos) <= 10.0 * 10.0 {
                return true
            }
        }
        return false
    }
    
    func closestBlobCenterDistanceSquared(_ pos:CGPoint) -> CGFloat {
        
        var hit:Bool = false
        var bestDist: CGFloat = 0.0
        
        for i in 0..<blobs.count {
            let blob = blobs[i]
            
            
            let dist = Math.distSquared(p1: blob.center, p2: pos)
            
            if hit == false {
                hit = true
                bestDist = dist
            } else {
                if dist < bestDist {
                    bestDist = dist
                }
            }
        }
        return bestDist
    }
    
    func selectBlobAtPoint(_ pos:CGPoint) -> Blob? {
        var result:Blob?
        
        for i in stride(from: blobs.count - 1, to: -1, by: -1) {
            //for blob:Blob in blobs {
            let blob = blobs[i]
            if blob.selectable, blob.border.pointInside(point: pos) {
                result = blob
                break
            }
        }
        
        //If we weren't exactly inside of the blob, let's try to pick one that's near.
        if(result === nil) {
            var bestDist:CGFloat = (45.0 * 45.0)
            for i in 0..<blobs.count {
                let blob = blobs[i]
                if blob.selectable && blob.enabled {
                    if let c = blob.border.closestPointSquared(point: pos) {
                        if c.distanceSquared < bestDist {
                            bestDist = c.distanceSquared
                            result = blob
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func gestureUpdateAffine() {
        if let blob = affineSelectionBlob , sceneMode == .edit && editMode == .affine {
            if isPanning {
                let x = affineSelectionStartCenter.x + (panPos.x - panStartPos.x)
                let y = affineSelectionStartCenter.y + (panPos.y - panStartPos.y)
                blob.center = CGPoint(x: x, y: y)
            }
            if isPinching {
                blob.scale = affineSelectionStartScale * pinchScale
            }
            if isRotating {
                var newRotation = affineSelectionStartRotation + rotation
                while newRotation > Math.PI2 { newRotation -= Math.PI2 }
                while newRotation < 0.0 { newRotation += Math.PI2 }
                blob.rotation = newRotation
            }
            
            //Correction to the center of blob. "Pivot" effect..
            let startCenter = blob.transformPoint(point: affineGestureStartCenter)
            blob.center = CGPoint(x: blob.center.x + (affineGestureCenter.x - startCenter.x),
                                  y: blob.center.y + (affineGestureCenter.y - startCenter.y))
        }
    }
    
    class func transformPoint(point:CGPoint, scale: CGFloat, rotation:CGFloat) -> CGPoint {
        var x = point.x
        var y = point.y
        if scale != 1.0 {
            x *= scale
            y *= scale
        }
        if rotation != 0 {
            var dist = x * x + y * y
            if dist > 0.01 {
                dist = CGFloat(sqrtf(Float(dist)))
                x /= dist
                y /= dist
            }
            let pivotRotation = rotation - CGFloat(atan2f(Float(-x), Float(-y)))
            x = CGFloat(sinf(Float(pivotRotation))) * dist
            y = CGFloat(-cosf(Float(pivotRotation))) * dist
        }
        return CGPoint(x: x, y: y)
    }
    
    class func transformPoint(point:CGPoint, translation:CGPoint, scale: CGFloat, rotation:CGFloat) -> CGPoint {
        var result = transformPoint(point: point, scale: scale, rotation: rotation)
        result = CGPoint(x: result.x + translation.x, y: result.y + translation.y)
        return result
    }
    
    class func untransformPoint(point:CGPoint, scale: CGFloat, rotation:CGFloat) -> CGPoint {
        return transformPoint(point: point, scale: 1.0 / scale, rotation: -rotation)
    }
    
    class func untransformPoint(point:CGPoint, translation:CGPoint, scale: CGFloat, rotation:CGFloat) -> CGPoint {
        var result = CGPoint(x: point.x - translation.x, y: point.y - translation.y)
        result = untransformPoint(point: result, scale: scale, rotation: rotation)
        return result
    }
    
    func historyPrint() {
        
        print("___HISTORY STACK [\(historyStack.count) items] Ind[\(historyIndex)]")
        
        for i in 0..<historyStack.count {
            
            let state = historyStack[i]
            
            var typeString = "Unknown"
            
            if state.type == .blobAdd {
                typeString = "Add Blob"
            }
            if state.type == .blobDelete {
                typeString = "Delete Blob"
            }
            if state.type == .blobChangeAffine {
                typeString = "Blob Change Affine"
            }
            if state.type == .blobChangeShape {
                typeString = "Blob Change Shape"
            }
            print("Hist [\(i) -> \(typeString) Ind(\(state.blobIndex))")
        }
        
        print("___END HISTORY STACK")
    }
    
    func historyClear() {
        historyStack.removeAll()
        historyIndex = 0
    }
    
    func historyAdd(withState state: HistoryState) -> Void {
        
        
        
        //print("PRE____")
        //historyPrint()
        
        
        //Case 0:
        //History stack has 0 items, we are at item nil.
        //[] index = nil
        //...
        //[NEW] index = 0
        
        //Case 1:
        //History stack has 4 items, we are at item 1.
        //[H0, H1, H2, H3] index = 1
        //...
        //[H0, H1, NEW] index = 2
        
        //Case 2:
        //History stack has 1 items, we are at item 0.
        //[H0] index = 0
        //...
        //[H0, NEW] index = 1
        
        var newHistoryStack = [HistoryState]()
        var index = historyIndex
        if historyLastActionUndo == false { index += 1 }
        if index > 0 {
            if index > historyStack.count { index = historyStack.count }
            for i in 0..<(index) {
                newHistoryStack.append(historyStack[i])
            }
        }
        
        newHistoryStack.append(state)
        historyIndex = newHistoryStack.count
        historyStack = newHistoryStack
        historyLastActionUndo = false
        historyLastActionRedo = false
        BounceEngine.postNotification(BounceNotification.historyChanged)
        
        
        //print("POST____")
        //historyPrint()
        
    }
    
    func canUndo() -> Bool {
        if zoomMode { return false }
        if historyStack.count > 0 {
            if historyLastActionRedo {
                return (historyIndex >= 0 && historyIndex < historyStack.count)
            } else {
                return (historyIndex > 0 && historyIndex <= historyStack.count)
            }
        }
        return false
    }
    
    func canRedo() -> Bool {
        if zoomMode { return false }
        if historyStack.count > 0 {
            if historyLastActionUndo {
                return (historyIndex >= 0 && historyIndex < historyStack.count)
            } else {
                return (historyIndex >= 0 && historyIndex < (historyStack.count - 1))
            }
        }
        return false
    }
    
    
    func undo() {
        
        print("Undo! Allow[\(canUndo())] -> Index = \(historyIndex)")
        
        if canUndo() {
            let index = historyLastActionRedo ? historyIndex : (historyIndex - 1)
            let state = historyStack[index]
            historyApplyUndo(withState: state)
            historyIndex = index
            historyLastActionUndo = true
            historyLastActionRedo = false
            BounceEngine.postNotification(BounceNotification.historyChanged)
        }
        
        print("Post Undo! Index = \(historyIndex)")
        
    }
    
    func redo() {
        if canRedo() {
            let index = historyLastActionUndo ? historyIndex : (historyIndex + 1)
            let state = historyStack[index]
            historyApplyRedo(withState: state)
            historyIndex = index
            historyLastActionUndo = false
            historyLastActionRedo = true
            BounceEngine.postNotification(BounceNotification.historyChanged)
        }
    }
    
    
    func historyApplyUndo(withState historyState: HistoryState) {
        if historyState.type == .blobAdd {
            if let state = historyState as? HistoryStateAddBlob {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    deleteBlob(blobs[index])
                }
            }
        } else if historyState.type == .blobChangeAffine {
            if let state = historyState as? HistoryStateChangeAffine {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    let blob = blobs[index]
                    blob.center = state.startPos
                    blob.scale = state.startScale
                    blob.rotation = state.startRotation
                }
            }
        } else if historyState.type == .blobChangeShape {
            if let state = historyState as? HistoryStateChangeShape {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    if let data = state.startSplineData {
                        let blob = blobs[index]
                        
                        blob.spline.load(info: data)
                        blob.computeShape()
                        
                    }
                }
            }
        } else if historyState.type == .blobDelete {
            if let state = historyState as? HistoryStateDeleteBlob {
                if let index = state.blobIndex, let data = state.blobData {
                    let blob = Blob()
                    blob.load(info: data)
                    if index >= 0 && index < blobs.count {
                        blobs.insert(blob, at: index)
                    } else {
                        blobs.append(blob)
                    }
                }
            }
        }
    }
    
    func historyApplyRedo(withState historyState: HistoryState) {
        if historyState.type == .blobAdd {
            if let state = historyState as? HistoryStateAddBlob {
                if let index = state.blobIndex, let data = state.blobData {
                    let blob = Blob()
                    blob.load(info: data)
                    if index >= 0 && index < blobs.count {
                        blobs.insert(blob, at: index)
                    } else {
                        blobs.append(blob)
                    }
                }
            }
        } else if historyState.type == .blobChangeAffine {
            if let state = historyState as? HistoryStateChangeAffine {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    let blob = blobs[index]
                    blob.center = state.endPos
                    blob.scale = state.endScale
                    blob.rotation = state.endRotation
                }
            }
        } else if historyState.type == .blobChangeShape {
            if let state = historyState as? HistoryStateChangeShape {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    if let data = state.endSplineData {
                        let blob = blobs[index]
                        blob.spline.load(info: data)
                        blob.computeShape()
                    }
                }
            }
        } else if historyState.type == .blobDelete {
            if let state = historyState as? HistoryStateDeleteBlob {
                if let index = state.blobIndex, index >= 0 && index < blobs.count {
                    deleteBlob(blobs[index])
                }
            }
        }
    }
    
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        var blobData = [[String:AnyObject]]()
        for blob in blobs {
            blobData.append(blob.save())
        }
        info["blobs"] = blobData as AnyObject?
        return info
    }
    
    func load(info:[String:AnyObject]) {
        deleteAllBlobs()
        if let blobData = info["blobs"] as? [[String:AnyObject]] {
            for i in 0..<blobData.count {
                let blob = Blob()
                blob.load(info: blobData[i])
                blobs.append(blob)
            }
        }
    }
}
