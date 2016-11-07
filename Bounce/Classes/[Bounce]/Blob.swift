//
//  Blob.swift
//
//  Created by Raptis, Nicholas on 8/22/16.
//

import UIKit
import OpenGLES

struct BlobGridNode {
    //Relative to (x=0, y=0).
    var pointBase:CGPoint = CGPoint.zero
    
    //Transformed to user's view.
    var point:CGPoint = CGPoint.zero
    
    //Index in the triangle list, we only store each data point once.
    var meshIndex:Int?
    
    var center = CGPoint.zero
    
    
    //Is it an edge?
    var edgeU:Bool = false
    var edgeR:Bool = false
    var edgeD:Bool = false
    var edgeL:Bool = false
    
    //Edge indeces in the triangle list, we only store each data point once.
    var meshIndexEdgeU:Int?
    var meshIndexEdgeR:Int?
    var meshIndexEdgeD:Int?
    var meshIndexEdgeL:Int?
    
    //Exact points where the adjacent edges are.
    var edgePointBaseU:CGPoint = CGPoint.zero
    var edgePointBaseR:CGPoint = CGPoint.zero
    var edgePointBaseD:CGPoint = CGPoint.zero
    var edgePointBaseL:CGPoint = CGPoint.zero
    
    //texture coordinates (u, v) of the transformed point on the background image.
    var texturePoint:CGPoint = CGPoint.zero
    
    //Is it inside the border outline?
    var inside:Bool = false
    
    var color:UIColor = UIColor.white
}

class Blob
{
    var grid = [[BlobGridNode]]()
    
    var meshNodes = BlobMeshBuffer()
    var meshNodesBase = BlobMeshBuffer()
    
    
    weak var touch:UITouch?
    
    var spline = CubicSpline()
    
    var valid:Bool = false
    
    var selected:Bool = false
    
    var tri = IndexTriangleList()
    var vertexBuffer = [GLfloat]()
    
    var vertexBufferStereoLeft = [GLfloat]()
    var vertexBufferStereoRight = [GLfloat]()
    
    
    var testAngle1:CGFloat = 0.0
    var testAngle2:CGFloat = 180.0
    var testAngle3:CGFloat = 360.0
    
    var testSin1:CGFloat = 0.0
    var testSin2:CGFloat = 0.0
    var testSin3:CGFloat = 0.0
    
    private var vertexBufferSlot:BufferIndex?
    private var indexBufferSlot:BufferIndex?
    
    var linesBase = LineSegmentBuffer()
    var linesInner = LineSegmentBuffer()
    var linesOuter = LineSegmentBuffer()
    
    weak var grabSelectionTouch:UITouch?
    
    var grabSelection: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var grabSelectionHistory = [CGPoint]()
    var grabSelectionHistoryCount: Int = 0
    var grabSelectionHistorySize: Int = 7
    
    var grabAnimationGuideOffsetStart:CGPoint = CGPoint(x: 0.0, y: 0.0)
    var grabAnimationGuideTouchStart:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    private var _previousWeightOffset = CGPoint.zero
    var weightOffset = CGPoint.zero {
        willSet {
            _previousWeightOffset = weightOffset
        }
        didSet {
            if weightOffset.x != _previousWeightOffset.x || weightOffset.y != _previousWeightOffset.y {
                setNeedsComputeWeight()
            }
        }
    }
    
    private var _previouscenterBulgeFactor: CGFloat = 0.5
    var centerBulgeFactor: CGFloat = 0.5 {
        willSet {
            _previouscenterBulgeFactor = centerBulgeFactor
        }
        didSet {
            if _previouscenterBulgeFactor != centerBulgeFactor {
                setNeedsComputeWeight()
            }
        }
    }
    
    private var _previousEdgeBulgeFactor: CGFloat = 0.5
    var edgeBulgeFactor: CGFloat = 0.5 {
        willSet {
            _previousEdgeBulgeFactor = edgeBulgeFactor
        }
        didSet {
            if _previousEdgeBulgeFactor != edgeBulgeFactor {
                setNeedsComputeWeight()
            }
        }
    }
    
    var weightScale: CGFloat = 1.0
    var weightCenter: CGPoint {
        set { weightOffset = untransformPoint(point: newValue) }
        get { return transformPoint(point: weightOffset) }
    }
    
    
    
    //
    //
    
    //Base = untransformed, no Base = transformed...
    private var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256) { didSet { setNeedsComputeAffine() } }
    var scale:CGFloat = 1.0 { didSet { setNeedsComputeAffine() } }
    var rotation:CGFloat = 0.0 { didSet { setNeedsComputeAffine() } }
    
    var animationGuideOffset:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    var animationGuideSpeed:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    var animationGuideReleaseFlingDecay: CGFloat = 0.0
    var animationGuideReleaseFlingAccel:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    
    //var animationGuide:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    
    
    func setNeedsComputeShape() { needsComputeShape = true }
    internal var needsComputeShape: Bool = true
    func setNeedsComputeWeight() { needsComputeWeight = true }
    internal var needsComputeWeight: Bool = true
    func setNeedsComputeAffine() { needsComputeAffine = true }
    internal var needsComputeAffine: Bool = true
    internal var boundingBox: CGRect = CGRect.zero
    
    var enabled: Bool {
        return true
    }
    
    var selectable:Bool {
        return true
    }
    
    init() {
        
        for _ in 0..<grabSelectionHistorySize {
            grabSelectionHistory.append(CGPoint(x: 0.0, y: 0.0))
        }
        
        
        //var grabSelection: CGPoint = CGPoint(x: 0.0, y: 0.0)
        //var grabSelectionHistory = [CGPoint]()
        //var grabSelectionHistoryCount: Int = 0
        //var grabSelectionHistorySize: Int = 12
        
        
        vertexBufferSlot = Graphics.bufferGenerate()
        indexBufferSlot = Graphics.bufferGenerate()
        
        linesInner.color = Color(1.0, 1.0, 1.0, 1.0)
        linesOuter.color = Color(0.45, 0.45, 0.45, 1.0)
        
        //var linesOuter = LineSegmentBuffer()
        
        var radius = min(ApplicationController.shared.width, ApplicationController.shared.height)
        var pointCount = 6
        
        if Device.isTablet {
            pointCount = 8
            radius = radius / 6
        } else {
            radius = radius / 6
        }
        for i in 0..<pointCount {
            let percent = CGFloat(i) / CGFloat(pointCount)
            let rads = percent * Math.PI2
            spline.add(sin(rads) * radius, y: cos(rads) * radius)
        }
        spline.linear = false
        spline.closed = true
        computeShape()
        
    }
    
    deinit {
        Graphics.bufferDelete(bufferIndex: vertexBufferSlot)
        vertexBufferSlot = nil
        
        Graphics.bufferDelete(bufferIndex: indexBufferSlot)
        indexBufferSlot = nil
    }
    
    func update() {
        
        var isEditMode = false
        var isViewMode = false
        
        var isEditModeAffine = false
        var isEditModeShape = false
        
        var shapeSelectionControlPointIndex:Int?
        
        if let engine = ApplicationController.shared.engine {
            if engine.sceneMode == .edit {
                isEditMode = true
                if engine.editMode == .affine { isEditModeAffine = true }
                if engine.editMode == .shape {
                    isEditModeShape = true
                    if selected {
                        shapeSelectionControlPointIndex = engine.shapeSelectionControlPointIndex
                    }
                }
            }
            if engine.sceneMode == .view {
                isViewMode = true
            }
            
        }
        
        
        testAngle1 += 2.0
        if testAngle1 > 360.0 { testAngle1 -= 360.0 }
        
        testAngle2 -= 1.5
        if testAngle2 < 0.0 { testAngle2 += 360.0 }
        
        testAngle3 += 3.25
        if testAngle3 > 360.0 { testAngle3 -= 360.0 }
        
        testSin1 = Math.sind(testAngle1)
        testSin2 = Math.sind(testAngle2)
        testSin3 = Math.sind(testAngle3)
        
        if grabSelectionTouch !== nil {
            if grabSelectionHistoryCount < grabSelectionHistorySize {
                grabSelectionHistory[grabSelectionHistoryCount].x = grabSelection.x
                grabSelectionHistory[grabSelectionHistoryCount].y = grabSelection.y
                grabSelectionHistoryCount += 1
            } else {
                for i in 1..<grabSelectionHistorySize {
                    grabSelectionHistory[i-1].x = grabSelectionHistory[i].x
                    grabSelectionHistory[i-1].y = grabSelectionHistory[i].y
                }
                grabSelectionHistory[grabSelectionHistorySize - 1].x = grabSelection.x
                grabSelectionHistory[grabSelectionHistorySize - 1].y = grabSelection.y
            }
        } else {
            grabSelectionHistoryCount = 0
        }
        
        
        
        if isViewMode {
            
            if grabSelectionTouch === nil {
                
                var diffX = -animationGuideOffset.x
                var diffY = -animationGuideOffset.y
                
                var dist = diffX * diffX + diffY * diffY
                
                if dist > Math.epsilon {
                    dist = CGFloat(sqrtf(Float(dist)))
                    diffX /= dist
                    diffY /= dist
                } else {
                    
                    diffX = 0.0
                    diffY = 0.0
                }
                
                var decayInv = (1.0 - animationGuideReleaseFlingDecay)
                
                
                //animationGuideReleaseFlingAccel = CGPoint.zero
                //animationGuideSpeed = CGPoint.zero
                
                animationGuideSpeed.x += animationGuideReleaseFlingAccel.x * animationGuideReleaseFlingDecay
                animationGuideSpeed.y += animationGuideReleaseFlingAccel.y * animationGuideReleaseFlingDecay
                
                animationGuideSpeed.x += diffX * dist * 0.04
                animationGuideSpeed.y += diffY * dist * 0.04
                
                let speedDecay = 0.954 + (animationGuideReleaseFlingDecay * 0.046)
                
                animationGuideSpeed.x *= speedDecay
                animationGuideSpeed.y *= speedDecay
                
                animationGuideOffset.x += animationGuideSpeed.x
                animationGuideOffset.y += animationGuideSpeed.y
                
                animationGuideReleaseFlingDecay -= 0.06
                if animationGuideReleaseFlingDecay < 0.0 { animationGuideReleaseFlingDecay = 0.0 }
                
                
                let gyroDir = ApplicationController.shared.gyroDir
                animationGuideSpeed.x += gyroDir.x
                animationGuideSpeed.y += gyroDir.y
            }
        } else {
            cancelAnimationGuideMotion()
        }
    }
    
    func drawMesh() {
        
        guard let engine = ApplicationController.shared.engine else {
            valid = false
            return
        }
        
        let sprite = engine.background
        
        guard let bounce = ApplicationController.shared.bounce else {
            valid = false
            return
        }
        
        
        
        
        
        var stereo = ApplicationController.shared.engine!.stereoscopic
        var stereoChannel = ApplicationController.shared.engine!.stereoscopicChannel
        var stereoOffset: CGFloat = ApplicationController.shared.engine!.stereoscopicSpreadOffset
        var stereoBase: CGFloat = ApplicationController.shared.engine!.stereoscopicSpreadBase
        
        if stereo == false {
            //stereoOffset = 0.0
            //stereoBase = 0.0
            
        }
        
        //if stereo {
        //    if stereoChannel {
        //        stereoSpread = -ApplicationController.shared.engine!.stereoscopicSpread
        //    } else {
        //        stereoSpread = ApplicationController.shared.engine!.stereoscopicSpread
        //    }
        //}
        
        
        
        computeIfNeeded()
        
        let indexBufferCount = tri.count * 3
        let vertexBufferCount = meshNodes.count * 30
        if vertexBuffer.count < vertexBufferCount {
            vertexBuffer.reserveCapacity(vertexBufferCount)
            while(vertexBuffer.count < vertexBufferCount) {
                vertexBuffer.append(0.0)
                vertexBufferStereoLeft.append(0.0)
                vertexBufferStereoRight.append(0.0)
            }
        }
        
        ShaderProgramMesh.shared.colorSet()
        
        var r:CGFloat = 0.05
        var g:CGFloat = 0.65
        var b:CGFloat = 0.05
        var a:CGFloat = 0.24
        
        var vertexIndex:Int = 0
        if ApplicationController.shared.engine?.sceneMode == .edit {
            
            Graphics.textureDisable()
            ShaderProgramMesh.shared.textureBlankBind()
            Graphics.blendEnable()
            Graphics.blendSetAlpha()
            
            if ApplicationController.shared.editMode == .distribution {
                
                let outerR:CGFloat = r
                let outerG:CGFloat = g
                let outerB:CGFloat = b
                var outerA:CGFloat = a
                
                let innerR:CGFloat = 1.0
                let innerG:CGFloat = 0.0
                let innerB:CGFloat = 0.0
                var innerA:CGFloat = 0.54
                
                
                let showEdge: Bool = engine.editShowEdgeWeight
                let showCenter: Bool = engine.editShowCenterWeight
                let showBoth: Bool = (showEdge && showCenter)
                
                if selected {
                    outerA = 0.54
                    innerA = 0.72
                }
                for nodeIndex in 0..<meshNodes.count {
                    let node = meshNodes.data[nodeIndex]
                    
                    //let percent = node.factor
                    var percent: CGFloat = 0.0
                    
                    if showBoth {
                        percent = node.edgeFactor * node.weightFactor
                    } else if showEdge {
                        percent = node.edgeFactor
                    }else if showCenter {
                        percent = node.weightFactor
                    }
                    
                    r = outerR + (innerR - outerR) * percent
                    g = outerG + (innerG - outerG) * percent
                    b = outerB + (innerB - outerB) * percent
                    a = outerA + (innerA - outerA) * percent
                    node.r = r;node.g = g;node.b = b;node.a = a
                    node.writeToTriangleList(&vertexBuffer, index: vertexIndex)
                    vertexIndex += 10
                }
            } else {
                if selected {
                    r = 0.1;g = 1.0;b = 0.2;a = 0.525
                }
                
                for nodeIndex in 0..<meshNodes.count {
                    let node = meshNodes.data[nodeIndex]
                    node.r = r;node.g = g;node.b = b;node.a = a
                    node.writeToTriangleList(&vertexBuffer, index: vertexIndex)
                    vertexIndex += 10
                }
            }
        } else if ApplicationController.shared.engine?.sceneMode == .view {
            Graphics.textureEnable()
            Graphics.textureBind(texture: sprite.texture)
            Graphics.blendDisable()
            
            r = 1.0
            g = 1.0
            b = 1.0
            a = 1.0
            
            if stereo {
                if stereoChannel {
                    r = 0.0
                } else {
                    g = 0.0
                    b = 0.0
                }
            }
            
            
            for nodeIndex in 0..<meshNodes.count {
                let node = meshNodes.data[nodeIndex]
                
                let animX = node.x + testSin1 * 20.0 * node.factor
                let animY = node.y + testSin2 * 40.0 * node.factor
                let animZ = node.factor * 200.0
                
                node.animX = animX + (stereoBase + stereoOffset * node.factor)
                node.animY = animY
                node.animZ = animZ
                
                node.r = r;node.g = g;node.b = b;node.a = a
                node.writeToTriangleListAnimated(&vertexBuffer, index: vertexIndex)
                
                vertexIndex += 10
            }
            
            
            
        }
        
        if vertexIndex > 0 && indexBufferCount > 0 {
            
            Graphics.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: &vertexBuffer, size: vertexIndex)
            //Graphics.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: &vertexBuffer, size: vertexBuffer.count)
            
            ShaderProgramMesh.shared.positionEnable()
            ShaderProgramMesh.shared.positionSetPointer(size: 3, offset: 0, stride: 10)
            
            ShaderProgramMesh.shared.texCoordEnable()
            ShaderProgramMesh.shared.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
            
            ShaderProgramMesh.shared.colorArrayEnable()
            ShaderProgramMesh.shared.colorArraySetPointer(size: 4, offset: 6, stride: 10)
            
            Graphics.bufferIndexSetData(bufferIndex: indexBufferSlot, data: &tri.indeces, size: indexBufferCount)
            //Graphics.bufferIndexSetData(bufferIndex: indexBufferSlot, data: &tri.indeces, size: tri.indeces.count)
            
            Graphics.drawElementsTriangle(count:indexBufferCount, offset: 0)
        }
        
        Graphics.blendEnable()
        Graphics.blendSetAlpha()
        
    }
    
    
    func drawMarkers() {
        
        computeIfNeeded()
        
        var isEditMode = false
        var isViewMode = false
        
        var isEditModeAffine = false
        var isEditModeShape = false
        var isEditModeDistribution = false
        
        
        var shapeSelectionControlPointIndex:Int?
        
        if let engine = ApplicationController.shared.engine {
            if engine.sceneMode == .edit {
                isEditMode = true
                if engine.editMode == .affine { isEditModeAffine = true }
                if engine.editMode == .shape {
                    isEditModeShape = true
                    if selected {
                        shapeSelectionControlPointIndex = engine.shapeSelectionControlPointIndex
                    }
                }
                if engine.editMode == .distribution { isEditModeDistribution = true }
            }
            
        }
        
        
        
        if selected {
            
            if Device.isTablet {
                
                linesOuter.thickness = 2.5
                linesInner.thickness = 1.5
            } else {
                linesOuter.thickness = 1.75
                linesInner.thickness = 1.0
            }
        } else {
            if Device.isTablet {
                linesOuter.thickness = 2.0
                linesInner.thickness = 1.0
            } else {
                linesOuter.thickness = 1.5
                linesInner.thickness = 0.75
            }
        }
        
        if isEditMode {
            
            Graphics.blendEnable()
            Graphics.blendSetPremultiplied()
            
            
            if isEditModeShape {
                
                
                linesOuter.draw()
                for i in 0..<spline.controlPointCount {
                    let point = transformPoint(point: spline.getControlPoint(i))
                    if shapeSelectionControlPointIndex == i {
                        BounceViewController.shared?.controlPointSelectedUnderlay.drawCentered(pos: point)
                    } else {
                        BounceViewController.shared?.controlPointUnderlay.drawCentered(pos: point)
                    }
                }
                
                linesInner.draw()
                for i in 0..<spline.controlPointCount {
                    let point = transformPoint(point: spline.getControlPoint(i))
                    
                    if shapeSelectionControlPointIndex == i {
                        BounceViewController.shared?.controlPointSelected.drawCentered(pos: point)
                    } else {
                        BounceViewController.shared?.controlPoint.drawCentered(pos: point)
                    }
                }
                
            } else {
                
                linesOuter.draw()
                linesInner.draw()
            }
            
            Graphics.blendSetAlpha()
        }
        
        
        Graphics.blendEnable()
        Graphics.blendSetAlpha()
        
        ShaderProgramMesh.shared.colorSet()
        
        ShaderProgramMesh.shared.pointDraw(point: center)
        ShaderProgramMesh.shared.lineDraw(p1: center, p2: CGPoint(x: center.x + animationGuideOffset.x, y: center.y + animationGuideOffset.y), thickness: 1)
        
        ShaderProgramMesh.shared.colorSet(r: 1.0, g: 0.0, b: 0.0, a: 0.5)
        
        for i in 0..<grabSelectionHistoryCount {
            let p = grabSelectionHistory[i]
            ShaderProgramMesh.shared.pointDraw(point: p)
        }
        
        if isEditModeDistribution {
            Graphics.blendEnable()
            Graphics.blendSetPremultiplied()
            ShaderProgramMesh.shared.colorSet(r: 1.0, g: 1.0, b: 0.0, a: 1.0)
            let wc = weightCenter
            if selected {
                BounceViewController.shared?.centerMarkerSelected.drawCentered(pos: wc)
            } else {
                BounceViewController.shared?.centerMarker.drawCentered(pos: wc)
            }
            Graphics.blendSetAlpha()
        }
    }
    
    func releaseGrabFling() {
        
        //var animationGuideReleaseFlingDecay: CGFloat = 0.0
        
        animationGuideReleaseFlingDecay = 0.0
        animationGuideReleaseFlingAccel = CGPoint.zero
        animationGuideSpeed = CGPoint.zero
        
        if grabSelectionHistoryCount > 2 {
            
            let startPoint = grabSelectionHistory[0]
            var dirSum = CGPoint(x: 0.0, y: 0.0)
            
            for i in 0..<grabSelectionHistoryCount {
                let dirSlice = CGPoint(x: grabSelectionHistory[i].x - startPoint.x, y: grabSelectionHistory[i].y - startPoint.y)
                dirSum.x += dirSlice.x
                dirSum.y += dirSlice.y
            }
            
            
            
            var dir = CGPoint(x: dirSum.x / CGFloat(grabSelectionHistoryCount), y: dirSum.y / CGFloat(grabSelectionHistoryCount))
            
            
            var dirLength = dir.x * dir.x + dir.y * dir.y
            
            if dirLength > Math.epsilon {
                
                animationGuideReleaseFlingDecay = 1.0
                
                dirLength = CGFloat(sqrtf(Float(dirLength)))
                dir.x /= dirLength
                dir.y /= dirLength
                
                
                let releaseSpeed = dirLength / 2.0
                
                animationGuideSpeed.x = dir.x * releaseSpeed
                animationGuideSpeed.y = dir.y * releaseSpeed
                
                let accelSpeed = CGFloat(sqrtf(Float(releaseSpeed + releaseSpeed))) / 2.0
                
                animationGuideReleaseFlingAccel.x = dir.x * accelSpeed
                animationGuideReleaseFlingAccel.y = dir.y * accelSpeed
                
                
                print("Release LEN = \(dirLength) ACCEL = \(accelSpeed) Dir: \(dir.x) x \(dir.y)")
                
            }
            
            
            
            //animationGuideSpeed.x += diffX * dist * 0.07
            //animationGuideSpeed.y += diffY * dist * 0.07
            
            
            
            
            
        }
        
        
        grabSelectionHistoryCount = 0
        grabSelectionTouch = nil
        
    }
    
    func computeWeight() {
        needsComputeWeight = false
        guard valid == true else { return }
        
        
        var minDist: CGFloat?
        var maxDist: CGFloat?
        
        for nodeIndex in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[nodeIndex]
            let diffX = node.x - weightOffset.x
            let diffY = node.y - weightOffset.y
            var dist = diffX * diffX + diffY * diffY
            if dist > Math.epsilon {
                dist = CGFloat(sqrtf(Float(dist)))
            }
            
            if minDist != nil {
                if dist < minDist! { minDist = dist }
            } else { minDist = dist }
            
            if maxDist != nil {
                if dist > maxDist! { maxDist = dist }
            } else { maxDist = dist }
            
            node.weightDistance = dist
            node.weightPercent = 0.0
            node.weightPercentMin = 0.0
            node.weightPercentMax = 0.0
            
            node.edgeFactor = node.edgePercentMin + (node.edgePercentMax - node.edgePercentMin) * edgeBulgeFactor
        }
        
        if let minD = minDist, let maxD = maxDist {
            let spanD = maxD - minD
            if spanD > Math.epsilon {
                for nodeIndex in 0..<meshNodesBase.count {
                    let node = meshNodesBase.data[nodeIndex]
                    var percent = (node.weightDistance - minD) / spanD
                    percent = (1.0 - percent)
                    if percent >= 1.0 {
                        percent = 1.0
                        node.weightPercentMin = 1.0
                        node.weightPercentMax = 1.0
                    } else if percent <= 0.0 {
                        percent = 0.0
                        node.weightPercentMin = 0.0
                        node.weightPercentMax = 0.0
                    } else {
                        node.weightPercentMin = 1.0 - cos(percent * percent * Math.PI_2)
                        
                        let percentInverse:CGFloat = 1.0 - percent
                        let maxFactor = 1.0 - (percentInverse * percentInverse)
                        node.weightPercentMax = sin(maxFactor * Math.PI_2)
                    }
                    node.weightPercent = percent
                    node.weightFactor = node.weightPercentMin + (node.weightPercentMax - node.weightPercentMin) * centerBulgeFactor
                    
                }
            }
        }
        
        computeAffine()
    }
    
    // { computeWeight() }
    
    func computeShape() {
        
        needsComputeShape = false
        valid = true
        
        computeBorder()
        
        guard borderBase.count > 4 && valid == true else {
            valid = false
            return
        }
        
        boundingBox = borderBase.getBoundingBox(padding: 5.0)
        
        guard boundingBox.size.width > 10.0 && boundingBox.size.height > 10.0 && valid == true else {
            valid = false
            return
        }
        
        computeGridPoints()
        
        guard grid.count >= 3 else {
            valid = false
            return
        }
        guard grid[0].count >= 3 && valid == true else {
            valid = false
            return
        }
        
        computeGridInside()
        computeGridEdges()
        computeMesh()
        computeMeshEdgeFactors()
        guard valid == true else { return }
        
        computeWeight()
    }
    
    internal func computeBorder() {
        borderBase.reset()
        
        #if DEBUG
            var threshDist = CGFloat(10.0)
            if Device.isTablet { threshDist = 28.0 }
        #else
            var threshDist = CGFloat(4.0)
            if Device.isTablet { threshDist = 8.0 }
        #endif
        
        threshDist = (threshDist * threshDist)
        
        let step = CGFloat(0.01)
        var prevPoint = spline.get(0.0)
        let lastPoint = spline.get(spline.maxPos)
        
        borderBase.add(x: prevPoint.x, y: prevPoint.y)
        for pos:CGFloat in stride(from: step, to: CGFloat(spline.maxPos), by: step) {
            let point = spline.get(pos)
            let diffX1 = point.x - prevPoint.x
            let diffY1 = point.y - prevPoint.y
            let diffX2 = point.x - lastPoint.x
            let diffY2 = point.y - lastPoint.y
            let dist1 = diffX1 * diffX1 + diffY1 * diffY1
            let dist2 = diffX2 * diffX2 + diffY2 * diffY2
            if dist1 > threshDist && dist2 > threshDist {
                borderBase.add(x: point.x, y: point.y)
                prevPoint = point
            }
        }
        
        guard borderBase.count >= 1 else {
            valid = false
            return
        }
        
        linesBase.reset()
        var prev = borderBase.data[borderBase.count - 1]
        for i in 0..<borderBase.count {
            let point = borderBase.data[i]
            linesBase.set(index: i, p1: prev, p2: point)
            prev = point
        }
    }
    
    func computeGridPoints() {
        let minSize = min(boundingBox.size.width, boundingBox.size.height)
        
        #if DEBUG
            let stepSize = minSize / 12.0
        #else
            let stepSize = minSize / 30.0
        #endif
        
        
        var countX = 0
        var countY = 0
        let leftX = boundingBox.origin.x
        let rightX = leftX + boundingBox.size.width
        for _ in stride(from: leftX, to: rightX, by: stepSize) {
            countX += 1
        }
        
        let topY = boundingBox.origin.y
        let bottomY = topY + boundingBox.size.height
        for _ in stride(from: topY, to: bottomY, by: stepSize) {
            countY += 1
        }
        
        grid = [[BlobGridNode]](repeating: [BlobGridNode](repeating: BlobGridNode(), count: countY), count: countX)
        
        for i in 0..<countX {
            let percentX = CGFloat(Double(i) / Double(countX - 1))
            let x = leftX + (rightX - leftX) * percentX
            for n in 0..<countY {
                let percentY = CGFloat(Double(n) / Double(countY - 1))
                let y = topY + (bottomY - topY) * percentY
                let point = CGPoint(x: x, y: y)
                grid[i][n].pointBase = point
                grid[i][n].inside = borderBase.pointInside(point: point)
                
                if grid[i][n].inside {
                    grid[i][n].color = UIColor(red: 1.0 - percentX, green: 1.0, blue: 1.0 - percentY, alpha: 1.0)
                } else {
                    grid[i][n].color = UIColor(red: percentX, green: 0.0, blue: percentY, alpha: 1.0)
                }
            }
        }
    }
    
    //Find which grid points are inside our polygon.
    func computeGridInside() {
        guard grid.count > 0 else { return }
        guard grid[0].count > 0 else { return }
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                grid[i][n].inside = borderBase.pointInside(point: grid[i][n].pointBase)
            }
        }
    }
    
    func computeGridEdges() {
        //Reset the border points.
        for i in 0..<grid.count {
            for n in 1..<grid[i].count {
                grid[i][n].edgeU = false
                grid[i][n].edgeR = false
                grid[i][n].edgeD = false
                grid[i][n].edgeL = false
            }
        }
        //Find all of the border points for the grid.
        for i in 1..<grid.count {
            for n in 1..<grid[i].count {
                let top = n - 1
                let left = i - 1
                let right = i
                let bottom = n
                if grid[left][bottom].inside == true && grid[left][top].inside == false {
                    grid[left][bottom].edgeU = true
                    grid[left][bottom].edgePointBaseU = closestBorderPointUp(point: grid[left][bottom].pointBase)
                }
                if grid[right][bottom].inside == true && grid[right][top].inside == false {
                    grid[right][bottom].edgeU = true
                    grid[right][bottom].edgePointBaseU = closestBorderPointUp(point: grid[right][bottom].pointBase)
                }
                if grid[left][bottom].inside == false && grid[left][top].inside == true {
                    grid[left][top].edgeD = true
                    grid[left][top].edgePointBaseD = closestBorderPointDown(point: grid[left][top].pointBase)
                }
                if grid[right][bottom].inside == false && grid[right][top].inside == true {
                    grid[right][top].edgeD = true
                    grid[right][top].edgePointBaseD = closestBorderPointDown(point: grid[right][top].pointBase)
                }
                if grid[left][top].inside == false && grid[right][top].inside == true {
                    grid[right][top].edgeL = true
                    grid[right][top].edgePointBaseL = closestBorderPointLeft(point: grid[right][top].pointBase)
                }
                if grid[left][bottom].inside == false && grid[right][bottom].inside == true {
                    grid[right][bottom].edgeL = true
                    grid[right][bottom].edgePointBaseL = closestBorderPointLeft(point: grid[right][bottom].pointBase)
                }
                if grid[left][top].inside == true && grid[right][top].inside == false {
                    grid[left][top].edgeR = true
                    grid[left][top].edgePointBaseR = closestBorderPointRight(point: grid[left][top].pointBase)
                }
                if grid[left][bottom].inside == true && grid[right][bottom].inside == false {
                    grid[left][bottom].edgeR = true
                    grid[left][bottom].edgePointBaseR = closestBorderPointRight(point: grid[left][bottom].pointBase)
                }
            }
        }
    }
    
    //For indexed triangle list, we will only use each grid edge point once.
    func meshIndexEdgeU(_ gridX: Int, _ gridY: Int) -> Int {
        if (grid[gridX][gridY].meshIndexEdgeU != nil) {
            return grid[gridX][gridY].meshIndexEdgeU!
        } else {
            let index = meshNodesBase.count
            grid[gridX][gridY].meshIndexEdgeU = meshNodesBase.count
            let point = grid[gridX][gridY].edgePointBaseU
            meshNodesBase.setXY(index, x: point.x, y: point.y)
            return index
        }
    }
    
    //For indexed triangle list, we will only use each grid edge point once.
    func meshIndexEdgeR(_ gridX: Int, _ gridY: Int) -> Int {
        if (grid[gridX][gridY].meshIndexEdgeR != nil) {
            return grid[gridX][gridY].meshIndexEdgeR!
        } else {
            let index = meshNodesBase.count
            grid[gridX][gridY].meshIndexEdgeR = meshNodesBase.count
            let point = grid[gridX][gridY].edgePointBaseR
            meshNodesBase.setXY(index, x: point.x, y: point.y)
            return index
        }
    }
    
    //For indexed triangle list, we will only use each grid edge point once.
    func meshIndexEdgeD(_ gridX: Int, _ gridY: Int) -> Int {
        if (grid[gridX][gridY].meshIndexEdgeD != nil) {
            return grid[gridX][gridY].meshIndexEdgeD!
        } else {
            let index = meshNodesBase.count
            grid[gridX][gridY].meshIndexEdgeD = meshNodesBase.count
            let point = grid[gridX][gridY].edgePointBaseD
            meshNodesBase.setXY(index, x: point.x, y: point.y)
            return index
        }
    }
    
    //For indexed triangle list, we will only use each grid edge point once.
    func meshIndexEdgeL(_ gridX: Int, _ gridY: Int) -> Int {
        if (grid[gridX][gridY].meshIndexEdgeL != nil) {
            return grid[gridX][gridY].meshIndexEdgeL!
        } else {
            let index = meshNodesBase.count
            grid[gridX][gridY].meshIndexEdgeL = meshNodesBase.count
            let point = grid[gridX][gridY].edgePointBaseL
            meshNodesBase.setXY(index, x: point.x, y: point.y)
            return index
        }
    }
    
    //For indexed triangle list, we will only use each grid point once.
    func meshIndex(_ gridX: Int, _ gridY: Int) -> Int {
        if (grid[gridX][gridY].meshIndex != nil) {
            return grid[gridX][gridY].meshIndex!
        } else {
            let index = meshNodesBase.count
            grid[gridX][gridY].meshIndex = meshNodesBase.count
            let point = grid[gridX][gridY].pointBase
            meshNodesBase.setXY(index, x: point.x, y: point.y)
            return index
        }
    }
    
    func addTriangle(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int) {
        let i1 = meshIndex(x1, y1)
        let i2 = meshIndex(x2, y2)
        let i3 = meshIndex(x3, y3)
        tri.add(i1: i1, i2: i2, i3: i3)
    }
    
    func computeMesh() {
        guard valid else { return }
        
        //Reset the mesh indeces.
        for i in 0..<grid.count {
            for n in 1..<grid[i].count {
                grid[i][n].meshIndex = nil
                grid[i][n].meshIndexEdgeU = nil
                grid[i][n].meshIndexEdgeR = nil
                grid[i][n].meshIndexEdgeD = nil
                grid[i][n].meshIndexEdgeL = nil
            }
        }
        
        tri.reset()
        meshNodesBase.reset()
        
        //Build the mesh using level 6 magic.
        for i in 1..<grid.count {
            for n in 1..<grid[i].count {
                let top = n - 1
                let left = i - 1
                let right = i
                let bottom = n
                
                let U_L = grid[left][top]
                let D_L = grid[left][bottom]
                let U_R = grid[right][top]
                let D_R = grid[right][bottom]
                
                //All 4 tri's IN
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == true) {
                    let t1_i1 = meshIndex(left, top)
                    let t1_i2 = meshIndex(left, bottom)
                    let t1_i3 = meshIndex(right, top)
                    tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                    
                    let t2_i1 = meshIndex(left, bottom)
                    let t2_i2 = meshIndex(right, top)
                    let t2_i3 = meshIndex(right, bottom)
                    tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                }
                
                //Upper-Left in (Corner)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_L.edgeR && U_L.edgeD {
                        let t1_i1 = meshIndex(left, top)
                        let t1_i2 = meshIndexEdgeD(left, top)
                        let t1_i3 = meshIndexEdgeR(left, top)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                    }
                }
                
                //Upper-Right in (Corner)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_R.edgeL && U_R.edgeD {
                        let t1_i1 = meshIndexEdgeL(right, top)
                        let t1_i2 = meshIndexEdgeD(right, top)
                        let t1_i3 = meshIndex(right, top)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                    }
                }
                
                //Bottom-Left in (Corner)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == false) {
                    if D_L.edgeR && D_L.edgeU {
                        let t1_i1 = meshIndex(left, bottom)
                        let t1_i2 = meshIndexEdgeR(left, bottom)
                        let t1_i3 = meshIndexEdgeU(left, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                    }
                }
                
                //Bottom-Right in (Corner)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == false) && (D_R.inside == true) {
                    if D_R.edgeL && D_R.edgeU {
                        let t1_i1 = meshIndexEdgeU(right, bottom)
                        let t1_i2 = meshIndexEdgeL(right, bottom)
                        let t1_i3 = meshIndex(right, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                    }
                }
                
                //Up in (Side)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_L.edgeD && U_R.edgeD {
                        let t1_i1 = meshIndex(left, top)
                        let t1_i2 = meshIndexEdgeD(left, top)
                        let t1_i3 = meshIndexEdgeD(right, top)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndex(left, top)
                        let t2_i2 = meshIndex(right, top)
                        let t2_i3 = meshIndexEdgeD(right, top)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                    }
                }
                
                //Right in (Side)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == true) {
                    if U_R.edgeL && D_R.edgeL {
                        let t1_i1 = meshIndexEdgeL(right, top)
                        let t1_i2 = meshIndexEdgeL(right, bottom)
                        let t1_i3 = meshIndex(right, top)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndexEdgeL(right, bottom)
                        let t2_i2 = meshIndex(right, top)
                        let t2_i3 = meshIndex(right, bottom)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                    }
                }
                //Down in (Side)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == true) {
                    if D_L.edgeU && D_R.edgeU {
                        let t1_i1 = meshIndexEdgeU(left, bottom)
                        let t1_i2 = meshIndex(left, bottom)
                        let t1_i3 = meshIndexEdgeU(right, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndex(left, bottom)
                        let t2_i2 = meshIndexEdgeU(right, bottom)
                        let t2_i3 = meshIndex(right, bottom)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                        
                    }
                }
                
                //Left in (Side)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == false) {
                    if U_L.edgeR && D_L.edgeR {
                        let t1_i1 = meshIndex(left, top)
                        let t1_i2 = meshIndexEdgeR(left, top)
                        let t1_i3 = meshIndexEdgeR(left, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndexEdgeR(left, bottom)
                        let t2_i2 = meshIndex(left, top)
                        let t2_i3 = meshIndex(left, bottom)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                    }
                }
                
                //Upper-Left out (Elbow)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == true) {
                    if U_R.edgeL && D_L.edgeU {
                        let t1_i1 = meshIndexEdgeU(left, bottom)
                        let t1_i2 = meshIndexEdgeL(right, top)
                        let t1_i3 = meshIndex(right, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndexEdgeU(left, bottom)
                        let t2_i2 = meshIndex(left, bottom)
                        let t2_i3 = meshIndex(right, bottom)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                        
                        let t3_i1 = meshIndexEdgeL(right, top)
                        let t3_i2 = meshIndex(right, top)
                        let t3_i3 = meshIndex(right, bottom)
                        tri.add(i1: t3_i1, i2: t3_i2, i3: t3_i3)
                    }
                }
                
                //Upper-Right out (Elbow)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == true) {
                    if U_L.edgeR && D_R.edgeU {
                        let t1_i1 = meshIndex(left, bottom)
                        let t1_i2 = meshIndexEdgeR(left, top)
                        let t1_i3 = meshIndexEdgeU(right, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndex(left, top)
                        let t2_i2 = meshIndex(left, bottom)
                        let t2_i3 = meshIndexEdgeR(left, top)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                        
                        let t3_i1 = meshIndex(left, bottom)
                        let t3_i2 = meshIndexEdgeU(right, bottom)
                        let t3_i3 = meshIndex(right, bottom)
                        tri.add(i1: t3_i1, i2: t3_i2, i3: t3_i3)
                    }
                }
                
                //Bottom-Left out (Elbow)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == true) {
                    if U_L.edgeD && D_R.edgeL {
                        let t1_i1 = meshIndexEdgeD(left, top)
                        let t1_i2 = meshIndex(right, top)
                        let t1_i3 = meshIndexEdgeL(right, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndex(left, top)
                        let t2_i2 = meshIndexEdgeD(left, top)
                        let t2_i3 = meshIndex(right, top)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                        
                        let t3_i1 = meshIndexEdgeL(right, bottom)
                        let t3_i2 = meshIndex(right, top)
                        let t3_i3 = meshIndex(right, bottom)
                        tri.add(i1: t3_i1, i2: t3_i2, i3: t3_i3)
                    }
                }
                
                //Bottom-Right out (Elbow)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == false) {
                    if U_R.edgeD && D_L.edgeR {
                        let t1_i1 = meshIndex(left, top)
                        let t1_i2 = meshIndexEdgeD(right, top)
                        let t1_i3 = meshIndexEdgeR(left, bottom)
                        tri.add(i1: t1_i1, i2: t1_i2, i3: t1_i3)
                        
                        let t2_i1 = meshIndex(left, top)
                        let t2_i2 = meshIndex(left, bottom)
                        let t2_i3 = meshIndexEdgeR(left, bottom)
                        tri.add(i1: t2_i1, i2: t2_i2, i3: t2_i3)
                        
                        let t3_i1 = meshIndex(left, top)
                        let t3_i2 = meshIndex(right, top)
                        let t3_i3 = meshIndexEdgeD(right, top)
                        tri.add(i1: t3_i1, i2: t3_i2, i3: t3_i3)
                    }
                }
            }
        }
    }
    
    func closestBorderPointUp(point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x, y: point.y - 2048.0)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointRight(point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x + 2048.0, y: point.y)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointDown(point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x, y: point.y + 2048.0)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointLeft(point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x - 2048.0, y: point.y)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPoint(segment:LineSegment) -> CGPoint {
        var result = CGPoint(x: segment.x1, y: segment.y1)
        var bestDist:CGFloat?
        let planeX = segment.x1
        let planeY = segment.y1
        let planeDir = segment.direction
        for i in 0..<linesBase.count {
            let line = linesBase.data[i]
            if LineSegment.SegmentsIntersect(l1: segment, l2: line) {
                let intersection = LineSegment.LinePlaneIntersection(line: line, planeX: planeX, planeY: planeY, planeDirX: planeDir.x, planeDirY: planeDir.y)
                if intersection.intersects {
                    if bestDist == nil {
                        bestDist = intersection.distance
                        result = intersection.point
                    } else if (intersection.distance < bestDist!) {
                        bestDist = intersection.distance
                        result = intersection.point
                    }
                }
            }
        }
        return result
    }
    
    func computeMeshEdgeFactors() {
        
        //Something went very wrong.
        guard linesBase.count > 1 && valid else {
            valid = false
            return
        }
        
        //The farthest total distance of any point to the border.
        var largestDist:CGFloat = 0.0
        
        //Find the closest distance from each point to anywhere on the border.
        for nodeIndex in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[nodeIndex]
            let point = CGPoint(x: node.x, y: node.y)
            var closestDist:CGFloat = 100000000.0
            for segmentIndex in 0..<linesBase.count {
                let line = linesBase.data[segmentIndex]
                let closestPoint = LineSegment.SegmentClosestPoint(line: line, point: point)
                let diffX = closestPoint.x - point.x
                let diffY = closestPoint.y - point.y
                let dist = diffX * diffX + diffY * diffY
                if (dist < closestDist) {
                    closestDist = dist
                }
            }
            if closestDist > Math.epsilon { closestDist = CGFloat(sqrtf(Float(closestDist))) }
            if closestDist > largestDist { largestDist = closestDist }
            node.edgeDistance = closestDist
        }
        
        //Something went very wrong.
        guard largestDist > Math.epsilon else {
            valid = false
            return
        }
        
        //Normalize all of the distances for percent [0, 1]
        for nodeIndex in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[nodeIndex]
            node.edgePercent = node.edgeDistance / largestDist
            
            if node.edgePercent >= 1.0 {
                node.edgePercent = 1.0
            } else if node.edgePercent <= 0.0 {
                node.edgePercent = 0.0
            }
        }
        
        //Compute damping based on percent.
        for nodeIndex in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[nodeIndex]
            let percent = node.edgePercent
            
            if percent >= 1.0 {
                node.edgePercentMin = 1.0
                node.weightPercentMax = 1.0
            } else if percent <= 0.0 {
                node.edgePercentMin = 0.0
                node.edgePercentMax = 0.0
            } else {
                node.edgePercentMin = 1.0 - cos(percent * percent * Math.PI_2)
                
                let percentInverse:CGFloat = 1.0 - percent
                let maxFactor = 1.0 - (percentInverse * percentInverse)
                node.edgePercentMax = sin(maxFactor * Math.PI_2)
            }
            
            node.dampen = node.edgePercentMax
            node.factor = node.edgePercentMax
        }
    }
    
    func computeAffine() {
        needsComputeAffine = false
        
        guard valid == true else { return }
        
        border.reset()
        border.add(list: borderBase)
        border.transform(scale: scale, rotation: rotation)
        border.transform(translation: center)
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                grid[i][n].point = transformPoint(point: grid[i][n].pointBase)
            }
        }
        
        meshNodes.reset()
        for i in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[i]
            meshNodes.set(index: i, node: node)
            let point = transformPoint(point: CGPoint(x: node.x, y: node.y))
            meshNodes.data[i].x = point.x
            meshNodes.data[i].y = point.y
        }
        
        computeTextureCoords()
        
        guard border.count >= 1 else {
            valid = false
            return
        }
        
        linesInner.reset()
        linesOuter.reset()
        var prev = border.data[border.count - 1]
        for i in 0..<border.count {
            let point = border.data[i]
            linesInner.set(index: i, p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y))
            linesOuter.set(index: i, p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y))
            
            prev = point
        }
        
        
    }
    
    internal func computeTextureCoords() {
        
        guard let sceneRect = ApplicationController.shared.engine?.sceneRect else {
            valid = false
            return
        }
        
        guard let sprite = ApplicationController.shared.engine?.background else {
            valid = false
            return
        }
        
        let startU = Double(sprite.startU)
        let spanU = Double(sprite.endU) - startU
        let startV = Double(sprite.startV)
        let spanV = Double(sprite.endV) - startV
        
        let startX = Double(sceneRect.origin.x)
        let spanX = Double(sceneRect.size.width)
        let startY = Double(sceneRect.origin.y)
        let spanY = Double(sceneRect.size.height)
        
        guard spanX > 32.0 && spanY > 32.0 && spanU > 0.05 && spanV > 0.05 else {
            valid = false
            return
        }
        
        for i in 0..<meshNodes.count {
            let node = meshNodes.data[i]
            
            let x = Double(node.x)
            let y = Double(node.y)
            
            let percentX = (x - startX) / spanX
            let percentY = (y - startY) / spanY
            
            node.u = CGFloat(startU + spanU * percentX)
            node.v = CGFloat(startV + spanV * percentY)
        }
    }
    
    internal func computeIfNeeded() {
        if needsComputeShape { computeShape() }
        else if needsComputeWeight { computeWeight() }
        else if needsComputeAffine { computeAffine() }
    }
    
    func untransformPoint(point:CGPoint) -> CGPoint {
        return BounceEngine.untransformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    func transformPoint(point:CGPoint) -> CGPoint {
        return BounceEngine.transformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    
    func cancelAnimationGuideMotion() {
        grabSelectionTouch = nil
        grabSelection = CGPoint.zero
        grabSelectionHistoryCount = 0
        grabAnimationGuideOffsetStart = CGPoint.zero
        grabAnimationGuideTouchStart = CGPoint.zero
        animationGuideOffset = CGPoint.zero
        animationGuideSpeed = CGPoint.zero
        animationGuideReleaseFlingDecay = 0.0
        animationGuideReleaseFlingAccel = CGPoint(x: 0.0, y: 0.0)
    }
    
    func handleZoomModeChanged() {
        cancelAnimationGuideMotion()
    }
    
    func handleSceneModeChanged() {
        cancelAnimationGuideMotion()
    }
    
    func handleEditModeChanged() {
        cancelAnimationGuideMotion()
    }
    
    func handleViewModeChanged() {
        cancelAnimationGuideMotion()
    }
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["center_x"] = Float(center.x) as AnyObject?
        info["center_y"] = Float(center.y) as AnyObject?
        info["weight_offset_x"] = Float(weightOffset.x) as AnyObject?
        info["weight_offset_y"] = Float(weightOffset.y) as AnyObject?
        info["scale"] = Float(scale) as AnyObject?
        info["rotation"] = Float(rotation) as AnyObject?
        info["spline"] = spline.save() as AnyObject?
        info["center_bulge_factor"] = Float(centerBulgeFactor) as AnyObject?
        info["edge_bulge_factor"] = Float(edgeBulgeFactor) as AnyObject?
        
        return info
    }
    
    func load(info:[String:AnyObject]) {
        if let _centerX = info["center_x"] as? Float { center.x = CGFloat(_centerX) }
        if let _centerY = info["center_y"] as? Float { center.y = CGFloat(_centerY) }
        if let _weightOffsetX = info["weight_offset_x"] as? Float { weightOffset.x = CGFloat(_weightOffsetX) }
        if let _weightOffsetY = info["weight_offset_y"] as? Float { weightOffset.y = CGFloat(_weightOffsetY) }
        if let _scale = info["scale"] as? Float { scale = CGFloat(_scale) }
        if let _rotation = info["rotation"] as? Float { rotation = CGFloat(_rotation) }
        if let splineInfo = info["spline"] as? [String:AnyObject] { spline.load(info: splineInfo) }
        if let _centerBulgeFactor = info["center_bulge_factor"] as? Float { centerBulgeFactor = CGFloat(_centerBulgeFactor) }
        if let _edgeBulgeFactor = info["edge_bulge_factor"] as? Float { edgeBulgeFactor = CGFloat(_edgeBulgeFactor) }
        
        setNeedsComputeShape()
        //computeShape()
    }
}

