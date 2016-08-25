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

class BounceEngine {
    
    var zoomMode:Bool = false {
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: String(BounceNotification.ZoomModeChanged), object: self))
        }
    }
    
    var blobs = [Blob]()
    
    var selectedBlob:Blob?
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    var touchPoint:CGPoint = CGPointZero
    
    var sceneRect:CGRect = CGRectZero {
        didSet {
            background.startX = sceneRect.origin.x
            background.startY = sceneRect.origin.y
            background.endX = sceneRect.size.width
            background.endY = sceneRect.size.height
        }
    }
    
    func setUp(image image:UIImage, sceneRect:CGRect, screenRect:CGRect) {
        backgroundTexture.load(image: image)
        background.load(texture: backgroundTexture)
        self.sceneRect = CGRect(x: 0.0, y: 0.0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    
    func update() {
        
        for blob:Blob in blobs {
            if blob.enabled { blob.update() }
        }
    }
    
    func draw() {
        
        background.draw()
        for blob:Blob in blobs {
            if blob.enabled { blob.draw() }
        }
        
        gG.colorSet(r: 0.6, g: 0.8, b: 0.25)
        gG.pointDraw(point: touchPoint)
        
        gG.colorSet()
    }
    
    func touchDown(inout touch:UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
    }
    
    func touchMove(inout touch:UITouch, point:CGPoint) {
        touchPoint = CGPoint(x:point.x, y:point.y)
    }
    
    func touchUp(inout touch:UITouch, point:CGPoint) {
        
    }
    
    //this may be called extremely frequently.
    func cancelAllTouches() {
        
    }
    
    func cancelAllGestures() {
        
    }
    
    
    func addBlob() -> Blob {
        let blob = Blob()
        blobs.append(blob)
        selectedBlob = blob
        blob.center.x = sceneRect.origin.x + 50
        blob.center.y = sceneRect.origin.y + sceneRect.size.height / 2.0
        return blob
    }
    
    
}
