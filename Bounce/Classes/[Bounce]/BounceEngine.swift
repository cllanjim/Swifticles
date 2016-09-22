//
//  BounceEngine.swift
//
//  Created by Raptis, Nicholas on 8/24/16.
//

import UIKit

import Foundation

enum BounceNotification:String {
    case SceneReady = "BounceNotification.SceneReady"
    case ZoomModeChanged = "BounceNotification.ZoomModeChanged"
    case SceneModeChanged = "BounceNotification.SceneModeChanged"
    case EditModeChanged = "BounceNotification.EditModeChanged"
    case ViewModeChanged = "BounceNotification.ViewModeChanged"
    case BlobAdded = "BounceNotification.BlobAdded"
    case BlobSelectionChanged = "BounceNotification.BlobSelectionChanged"
    case HistoryStackChanged = "BounceNotification.HistoryStackChanged"
}

enum SceneMode: UInt32 { case edit = 1, view = 2 }
enum EditMode: UInt32 { case affine = 1, shape = 2 }
enum ViewMode: UInt32 { case standard = 1, animation = 2 }

class BounceEngine {
    
    required init() {
        ApplicationController.shared.engine = self
    }
    
    deinit {
        ApplicationController.shared.engine = nil
    }
    
    var zoomMode:Bool = false {
        didSet {
            BounceEngine.postNotification(BounceNotification.ZoomModeChanged)
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
                BounceEngine.postNotification(BounceNotification.BlobSelectionChanged, object: selectedBlob)
            }
            if let blob = selectedBlob {
                blob.selected = true
            }
        }
    }
    
    func deleteAllBlobs() {
        var temp = [Blob]()
        for blob:Blob in blobs { temp.append(blob) }
        for blob:Blob in temp { deleteBlob(blob) }
    }
    
    //For the affine transformations only..
    weak var affineSelectedBlob:Blob?
    weak var affineSelectionTouch:UITouch?
    var affineGestureStartCenter:CGPoint = CGPoint.zero
    var affineGestureCenter:CGPoint = CGPoint.zero
    var affineSelectionStartCenter:CGPoint = CGPoint.zero
    var affineSelectionStartScale:CGFloat = 1.0
    var affineSelectionStartRotation:CGFloat = 0.0
    
    
    weak var shapeSelectedBlob:Blob?
    weak var shapeSelectionTouch:UITouch?
    var shapeSelectionOffset:CGPoint = CGPoint.zero
    var shapeSelectionControlPointIndex:Int?
    
    
    var scene = BounceScene()
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
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
            handleModeChange()
            BounceEngine.postNotification(BounceNotification.SceneModeChanged)
        }
    }
    
    //internal var previousEditMode:EditMode = .affine
    var editMode:EditMode = .affine {
        didSet {
            handleModeChange()
            BounceEngine.postNotification(BounceNotification.EditModeChanged)
        }
    }
    
    var deletedBlobs = [Blob]()
    func deleteBlob(_ blob:Blob?) {
        
        if let deleteBlob = blob {
            
            deletedBlobs.append(deleteBlob)
            
            if affineSelectedBlob === deleteBlob {
                affineSelectedBlob = nil
                affineSelectionTouch = nil
            }
            if shapeSelectedBlob === deleteBlob {
                shapeSelectedBlob = nil
                shapeSelectionTouch = nil
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
        
        affineSelectedBlob = nil
        shapeSelectedBlob = nil
    }
    
    func setUp(scene:BounceScene) {//, screenRect:CGRect) {
        self.scene = scene
        let screenSize = scene.isLandscape ? CGSize(width: Device.shared.landscapeWidth, height: Device.shared.landscapeHeight) : CGSize(width: Device.shared.portraitWidth, height: Device.shared.portraitHeight)
        
        if let image = scene.image , image.size.width > 32 && image.size.height > 32 {
            
            
            //If the image is too large for the device, shrink it down.
            let widthRatio = (Double(screenSize.width) * Double(Device.shared.scale)) / Double(image.size.width)
            let heightRatio = (Double(screenSize.height) * Double(Device.shared.scale)) / Double(image.size.height)
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
        
        _ = addBlob()
    }
    
    
    func update() {
        
        for blob:Blob in blobs {
            if blob.enabled { blob.update() }
        }
    }
    
    func draw() {
        
        let screenSize = scene.isLandscape ? CGSize(width: Device.shared.landscapeWidth, height: Device.shared.landscapeHeight) : CGSize(width: Device.shared.portraitWidth, height: Device.shared.portraitHeight)
        
        Graphics.shared.colorSet(r: 0.44, g: 0.44, b: 0.44)
        Graphics.shared.rectDraw(x: 0.0, y: 0.0, width: Float(screenSize.width), height: Float(screenSize.height))
        
        Graphics.shared.colorSet(a: 0.35)
        background.draw()
        Graphics.shared.colorSet()
        
        Graphics.shared.colorSet(r: 1.0, g: 0.2, b: 0.2)
        Graphics.shared.pointDraw(point: CGPoint(x: background.startX, y: background.startY))
        Graphics.shared.pointDraw(point: CGPoint(x: background.startX, y: background.endY))
        Graphics.shared.pointDraw(point: CGPoint(x: background.endX, y: background.startY))
        Graphics.shared.pointDraw(point: CGPoint(x: background.endX, y: background.endY))
        
        
        
        Graphics.shared.colorSet()
        
        for blob:Blob in blobs {
            if blob.enabled {
                blob.draw()
            }
        }
        
        Graphics.shared.colorSet(r: 0.6, g: 0.8, b: 0.25)
        Graphics.shared.pointDraw(point: touchPoint)
        
        Graphics.shared.colorSet()
    }
    
    func touchDown(_ touch:inout UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
        
        //selectedBlob
        let touchBlob = selectBlobAtPoint(point)
        
        if sceneMode == .edit && editMode == .affine {
            if affineSelectedBlob == nil {
                affineSelectedBlob = touchBlob
                if let checkAffineSelectedBlob = affineSelectedBlob {
                    selectedBlob = checkAffineSelectedBlob
                    affineSelectionTouch = touch
                    affineSelectionStartCenter = checkAffineSelectedBlob.center
                    affineSelectionStartScale = checkAffineSelectedBlob.scale
                    affineSelectionStartRotation = checkAffineSelectedBlob.rotation
                } else {
                    affineSelectedBlob = nil
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
            
            if let blob = editBlob , shapeSelectedBlob == nil {
                selectedBlob = blob
                if closest!.distance < 80.0 {
                    shapeSelectedBlob = blob
                    shapeSelectionTouch = touch
                    shapeSelectionControlPointIndex = closest!.index
                    shapeSelectionOffset = offset
                }
            }
        }
    }
    
    func touchMove(_ touch:inout UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
        if sceneMode == .edit && editMode == .shape {
            if let blob = shapeSelectedBlob , touch === shapeSelectionTouch {
                if let index = shapeSelectionControlPointIndex {
                    //let pointInBlob = blob.untransformPoint(point: point)
                    let pointInBlob = blob.untransformPoint(point: CGPoint(x: point.x + shapeSelectionOffset.x, y: point.y + shapeSelectionOffset.y))
                    
                    blob.spline.set(index, x: pointInBlob.x, y: pointInBlob.y)
                    blob.setNeedsComputeShape()
                }
            }
        }
    }
    
    func touchUp(_ touch:inout UITouch, point:CGPoint) {
        if touch === affineSelectionTouch {
            affineSelectionTouch = nil
            affineSelectedBlob = nil
        }
        if touch === shapeSelectionTouch {
            shapeSelectionTouch = nil
            shapeSelectedBlob = nil
        }
    }
    
    //this may be called extremely frequently.
    func cancelAllTouches() {
        affineSelectedBlob = nil
        affineSelectionTouch = nil
        
        shapeSelectionTouch = nil
        shapeSelectedBlob = nil
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
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectedBlob {
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
        
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectedBlob {
                affineGestureStartCenter = blob.untransformPoint(point: pos)
            }
            gestureUpdateAffine()
        }
    }
    
    func pinch(pos:CGPoint, scale:CGFloat) {
        guard isPinching else { return }
        pinchPos = pos
        pinchScale = scale
        affineGestureCenter = pos
        if sceneMode == .edit && editMode == .affine { gestureUpdateAffine() }
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
        if sceneMode == .edit && editMode == .affine {
            if let blob = affineSelectedBlob {
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
        affineSelectedBlob = nil
        affineSelectionTouch = nil
    }
    
    class func postNotification(_ notificationName: BounceNotification) {
        let notification = Notification(name: Notification.Name(notificationName.rawValue), object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    class func postNotification(_ notificationName: BounceNotification, object: AnyObject?) {
        let notification = Notification(name: Notification.Name(notificationName.rawValue), object: object, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func addBlob() {
        let blob = Blob()
        blobs.append(blob)
        selectedBlob = blob
        blob.center.x = sceneRect.origin.x + 50
        blob.center.y = sceneRect.origin.y + sceneRect.size.height / 2.0
        BounceEngine.postNotification(.BlobAdded)
    }
    
    func blobClosestToPoint(_ pos:CGPoint) -> Blob? {
        var result:Blob?
        var bestDist:CGFloat?
        for blob:Blob in blobs {
            if blob.selectable {
                let dist = Math.dist(p1:pos, p2: blob.center)
                if let checkBestDist = bestDist {
                    if dist < checkBestDist {
                        result = blob
                        bestDist = dist
                    }
                } else {
                    result = blob
                    bestDist = dist
                }
            }
        }
        return result
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
        return result
    }
    
    func gestureUpdateAffine() {
        if let blob = affineSelectedBlob , sceneMode == .edit && editMode == .affine {
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
