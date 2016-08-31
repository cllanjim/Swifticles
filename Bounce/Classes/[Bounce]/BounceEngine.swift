//
//  BounceEngine.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/24/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

import Foundation

enum BounceNotification:String {
    case ZoomModeChanged = "BounceNotification.ZoomModeChanged"
    case SceneModeChanged = "BounceNotification.SceneModeChanged"
    case EditModeChanged = "BounceNotification.EditModeChanged"
    case ViewModeChanged = "BounceNotification.ViewModeChanged"
    case BlobAdded = "BounceNotification.BlobAdded"
    case BlobSelectionChanged = "BounceNotification.BlobSelectionChanged"
}

enum SceneMode: UInt32 { case Edit = 1, View = 2 }
enum EditMode: UInt32 { case Affine = 1, Shape = 2 }


class BounceEngine {
    
    var zoomMode:Bool = false {
        didSet {
            postNotification(BounceNotification.ZoomModeChanged)
        }
    }
    
    var blobs = [Blob]()
    
    internal var previousSelectedBlob:Blob?
    var selectedBlob:Blob? {
        willSet { previousSelectedBlob = selectedBlob }
        didSet {
            if previousSelectedBlob === selectedBlob {
                postNotification(BounceNotification.BlobSelectionChanged, object: selectedBlob)
            }
        }
    }
    
    
    //For the affine transformations only..
    weak var affineSelectedBlob:Blob?
    weak var affineSelectionTouch:UITouch?
    var affineSelectionStartCenter:CGPoint = CGPointZero
    var affineSelectionStartScale:CGFloat = 1.0
    var affineSelectionStartRotation:CGFloat = 0.0
    
    
    
    var scene = BounceScene()
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    var touchPoint:CGPoint = CGPointZero
    
    var sceneRect:CGRect = CGRectZero {
        didSet {
            background.startX = sceneRect.origin.x
            background.startY = sceneRect.origin.y
            background.endX = (sceneRect.origin.x + sceneRect.size.width)
            background.endY = (sceneRect.origin.y + sceneRect.size.height)
        }
    }
    
    var sceneMode:SceneMode = .Edit {
        didSet {
            handleModeChange()
            postNotification(BounceNotification.SceneModeChanged) }
    }
    var editMode:EditMode = .Affine {
        didSet {
            handleModeChange()
            postNotification(BounceNotification.EditModeChanged)
        }
    }
    
    func handleModeChange() {
        affineSelectedBlob = nil
    }
    
    func setUp(scene scene:BounceScene) {//, screenRect:CGRect) {
        self.scene = scene
        let screenSize = scene.isLandscape ? CGSize(width: gDevice.landscapeWidth, height: gDevice.landscapeHeight) : CGSize(width: gDevice.portraitWidth, height: gDevice.portraitHeight)
        
        if let image = scene.image where image.size.width > 32 && image.size.height > 32 {
            
            
            //If the image is too large for the device, shrink it down.
            let widthRatio = (Double(screenSize.width) * Double(gDevice.scale)) / Double(image.size.width)
            let heightRatio = (Double(screenSize.height) * Double(gDevice.scale)) / Double(image.size.height)
            let ratio = min(widthRatio, heightRatio)
            if ratio < 0.999 {
                let importWidth = CGFloat(Int(Double(image.size.width) * ratio + 0.5))
                let importHeight = CGFloat(Int(Double(image.size.height) * ratio + 0.5))
                print("Import Resized [\(image.size.width) x \(image.size.height)] ->\n[\(importWidth) x \(importHeight)]")
                scene.image = image.resize(CGSize(width: importWidth, height: importHeight))
                
                //TODO: Re-save the image here.
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
        
        let screenSize = scene.isLandscape ? CGSize(width: gDevice.landscapeWidth, height: gDevice.landscapeHeight) : CGSize(width: gDevice.portraitWidth, height: gDevice.portraitHeight)
        
        gG.colorSet(r: 0.2, g: 0.6, b: 0.6)
        
        gG.rectDraw(x: 0.0, y: 0.0, width: Float(screenSize.width), height: Float(screenSize.height))
        
        gG.colorSet()
        background.draw()
        
        gG.colorSet(r: 1.0, g: 0.2, b: 0.2)
        gG.pointDraw(point: CGPoint(x: background.startX, y: background.startY))
        gG.pointDraw(point: CGPoint(x: background.startX, y: background.endY))
        gG.pointDraw(point: CGPoint(x: background.endX, y: background.startY))
        gG.pointDraw(point: CGPoint(x: background.endX, y: background.endY))
        
        
        if isPanning {
            gG.colorSet(r: 1.0, g: 0.8, b: 0.11)
        } else {
            gG.colorSet(r: 0.0, g: 0.8, b: 0.55)
        }
        
        
        gG.pointDraw(point: panStartPos, size: 14)
        
        gG.lineDraw(p1: panStartPos, p2: panPos, thickness: 2.56325453424)
        
        
        
        
        
        gG.colorSet()
        
        for blob:Blob in blobs {
            if blob.enabled {
                blob.draw()
            }
        }
        
        gG.colorSet(r: 0.6, g: 0.8, b: 0.25)
        gG.pointDraw(point: touchPoint)
        
        gG.colorSet()
    }
    
    func touchDown(inout touch:UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
        
        //selectedBlob
        let touchBlob = selectBlobAtPoint(point)
        
        if sceneMode == .Edit && editMode == .Affine {
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
        
    }
    
    func touchMove(inout touch:UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
    }
    
    func touchUp(inout touch:UITouch, point:CGPoint) {
        
        if touch === affineSelectionTouch {
            affineSelectionTouch = nil
            affineSelectedBlob = nil
        }
        
        
        
    }
    
    //this may be called extremely frequently.
    func cancelAllTouches() {
        print("Engine.cancelAllTouches()")
        affineSelectedBlob = nil
        affineSelectionTouch = nil
        
    }
    
    
    var isPanning:Bool = false
    var panStartPos:CGPoint = CGPointZero
    var panPos:CGPoint = CGPointZero
    
    func panBegin(pos pos:CGPoint) {
        print("PanBegin(\(pos.x) x \(pos.y))")
        if isPanning {
            panEnd(pos: pos, velocity: CGPointZero)
        }
        isPanning = true
        panStartPos = pos
        panPos = pos
        
        if sceneMode == .Edit && editMode == .Affine {
            
            if let blob = affineSelectedBlob {
                affineSelectionStartCenter = blob.center
            }
            gestureUpdateAffine()
        }
    }
    
    func pan(pos pos:CGPoint) {
        guard isPanning else { return }
        panPos = pos
        if sceneMode == .Edit && editMode == .Affine { gestureUpdateAffine() }
    }
    
    func panEnd(pos pos:CGPoint, velocity:CGPoint) {
        guard isPanning else { return }
        panPos = pos
        isPanning = false
    }
    
    var isPinching:Bool = false
    var pinchScale:CGFloat = 1.0
    var pinchStartPos:CGPoint = CGPointZero
    var pinchPos:CGPoint = CGPointZero
    func pinchBegin(pos pos:CGPoint, scale:CGFloat) {
        print("PinchBegin(\(pos.x) x \(pos.y))")
        if isPinching {
            pinchEnd(pos: pos, scale: pinchScale)
            isPinching = false
        }
        isPinching = true
        pinchStartPos = pos
        pinchPos = pos
        pinchScale = scale
        if sceneMode == .Edit && editMode == .Affine { gestureUpdateAffine() }
    }
    
    func pinch(pos pos:CGPoint, scale:CGFloat) {
        guard isPinching else { return }
        pinchPos = pos
        pinchScale = scale
        if sceneMode == .Edit && editMode == .Affine { gestureUpdateAffine() }
    }
    
    func pinchEnd(pos pos:CGPoint, scale:CGFloat) {
        guard isPinching else { return }
        print("PinchEnd(\(pos.x) x \(pos.y))")
        pinchPos = pos
        pinchScale = scale
        isPinching = false
    }
    
    
    
    var isRotating:Bool = false
    var rotation:CGFloat = 0.0
    var rotationStartPos:CGPoint = CGPointZero
    var rotationPos:CGPoint = CGPointZero
    func rotateBegin(pos pos:CGPoint, radians:CGFloat) {
        print("RotateBegin(\(pos.x) x \(pos.y)) Rad: \(radians * 100) RSS(\(affineSelectionStartRotation * 100))")
        if isRotating {
            rotateEnd(pos: pos, radians: radians)
            isRotating = false
        }
        isRotating = true
        rotationStartPos = pos
        rotationPos = pos
        rotation = radians
        if sceneMode == .Edit && editMode == .Affine { gestureUpdateAffine() }
    }
    
    func rotate(pos pos:CGPoint, radians:CGFloat) {
        print("Rotate(\(pos.x) x \(pos.y)) Rad: \(radians * 100) RSS(\(affineSelectionStartRotation * 100))")
        guard isRotating else { return }
        rotationPos = pos
        rotation = radians
        if sceneMode == .Edit && editMode == .Affine { gestureUpdateAffine() }
    }
    
    func rotateEnd(pos pos:CGPoint, radians:CGFloat) {
        guard isRotating else { return }
        print("RotateEnd(\(pos.x) x \(pos.y)) Rad: \(radians * 100) RSS(\(affineSelectionStartRotation * 100))")
        rotationPos = pos
        rotation = radians
        isRotating = false
    }
    
    
    func cancelAllGestures() {
        print("Engine.cancelAllGestures()")
        //if isPanning { panEnd(pos: panPos, velocity: CGPointZero) }
        //if isPinching { pinchEnd(pos: pinchPos, scale: pinchScale) }
        
        isPanning = false
        isPinching = false
        isRotating = false
        
        affineSelectedBlob = nil
        affineSelectionTouch = nil
    }
    
    func postNotification(notification: BounceNotification) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: String(notification), object: self))
    }
    
    func postNotification(notification: BounceNotification, object: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: String(notification), object: object))
    }
    
    func addBlob() -> Blob {
        let blob = Blob()
        blobs.append(blob)
        selectedBlob = blob
        blob.center.x = sceneRect.origin.x + 50
        blob.center.y = sceneRect.origin.y + sceneRect.size.height / 2.0
        
        postNotification(.BlobAdded)
        
        return blob
    }
    
    
    func blobClosestToPoint(pos:CGPoint) -> Blob? {
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
    
    func selectBlobAtPoint(pos:CGPoint) -> Blob? {
        var result:Blob?
        
        result = blobClosestToPoint(pos)
        
        return result
    }
    
    
    
    func gestureUpdateAffine() {
        
        if let blob = affineSelectedBlob where sceneMode == .Edit && editMode == .Affine {
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
        }
    }
    
//    if sceneMode == .Edit && editMode == .Affine {
//    
//    if affineSelectedBlob == nil {
//    affineSelectedBlob = touchBlob
//    
//    
//    if let checkAffineSelectedBlob = affineSelectedBlob {
//    selectedBlob = checkAffineSelectedBlob
//    affineSelectionTouch = touch
//    
//    affineSelectionStartCenter = checkAffineSelectedBlob.center
//    affineSelectionStartScale = checkAffineSelectedBlob.scale
//    affineSelectionStartRotation = checkAffineSelectedBlob.rotation
//    } else {
//    affineSelectedBlob = nil
//    affineSelectionTouch = nil
//    }
//    }
//    }
    
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        
        /*
         info["image_name"] = imageName
         info["image_path"] = imagePath
         
         info["landscape"] = isLandscape
         
         info["size_width"] = Float(size.width)
         info["size_height"] = Float(size.height)
         */
        
        return info
    }
    
    func load(info info:[String:AnyObject]) {
        print("************\nBounceEngine.load()")
        
    }
    
    
    
}
