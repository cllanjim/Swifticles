//
//  Blob.swift
//
//  Created by Raptis, Nicholas on 8/22/16.
//

import UIKit
import OpenGLES

struct BlobGridNode {
    //Base = untransformed, no Base = transformed...
    var point:CGPoint = CGPoint.zero
    var pointBase:CGPoint = CGPoint.zero
    var meshIndex:Int?
    
    var edgeU:Bool = false
    var edgeR:Bool = false
    var edgeD:Bool = false
    var edgeL:Bool = false
    
    var meshIndexEdgeU:Int?
    var meshIndexEdgeR:Int?
    var meshIndexEdgeD:Int?
    var meshIndexEdgeL:Int?
    
    var edgePointBaseU:CGPoint = CGPoint.zero
    var edgePointBaseR:CGPoint = CGPoint.zero
    var edgePointBaseD:CGPoint = CGPoint.zero
    var edgePointBaseL:CGPoint = CGPoint.zero
    
    var texturePoint:CGPoint = CGPoint.zero
    
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
    
    var testAngle1:CGFloat = 0.0
    var testAngle2:CGFloat = 180.0
    var testAngle3:CGFloat = 360.0
    
    var testSin1:CGFloat = 0.0
    var testSin2:CGFloat = 0.0
    var testSin3:CGFloat = 0.0
    
    private var vertexBufferSlot:BufferIndex?
    private var indexBufferSlot:BufferIndex?
    
    var linesBase = LineSegmentBuffer()//[LineSegment]()
    var lines = LineSegmentBuffer()//[LineSegment]()
    
    //Base = untransformed, no Base = transformed...
    private var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256) { didSet { needsComputeAffine = true } }
    var scale:CGFloat = 1.0 { didSet { needsComputeAffine = true } }
    var rotation:CGFloat = 0.0 { didSet { needsComputeAffine = true } }
    
    
    func setNeedsComputeShape() { needsComputeShape = true }
    internal var needsComputeShape:Bool = true
    func setNeedsComputeAffine() { needsComputeAffine = true }
    internal var needsComputeAffine:Bool = true
    
    internal var boundingBox:CGRect = CGRect.zero
    
    var enabled: Bool {
        return true
    }
    
    var selectable:Bool {
        return true
    }
    
    init() {
        
        vertexBufferSlot = Graphics.shared.bufferGenerate()
        indexBufferSlot = Graphics.shared.bufferGenerate()
        
        //vertexBufferSlot = Graphics.shared.bufferVertexGenerate(data: &vertexBuffer, size: 40)
        //indexBufferSlot = Graphics.shared.bufferIndexGenerate(data: &indexBuffer, size: 6)
        
        var radius = min(gApp.width, gApp.height)
        var pointCount = 6
        
        if gDevice.tablet {
            pointCount = 8
            radius = radius / 6
        } else {
            radius = radius / 6
        }
        for i in 0..<pointCount {
            var percent = CGFloat(i) / CGFloat(pointCount)
            var rads = percent * Math.PI2
            spline.add(sin(rads) * radius, y: cos(rads) * radius)
        }
        spline.linear = false
        spline.closed = true
        computeShape()
    }
    
    deinit {
        Graphics.shared.bufferDelete(bufferIndex: vertexBufferSlot)
        vertexBufferSlot = nil
        
        Graphics.shared.bufferDelete(bufferIndex: indexBufferSlot)
        indexBufferSlot = nil
    }
    
    func update() {
        
        testAngle1 += 2.0
        if testAngle1 > 360.0 { testAngle1 -= 360.0 }
        
        testAngle2 -= 1.5
        if testAngle2 < 0.0 { testAngle2 += 360.0 }
        
        testAngle3 += 3.25
        if testAngle3 > 360.0 { testAngle3 -= 360.0 }
        
        testSin1 = Math.sind(testAngle1)
        testSin2 = Math.sind(testAngle2)
        testSin3 = Math.sind(testAngle3)
        
        
        //var testAngle1 = 0.0
        //var testAngle2 = 180.0
        //var testAngle3 = 360.0
        
        //var testSin1 = 0.0
        //var testSin2 = 0.0
        //var testSin3 = 0.0
        
    }
    
    func draw() {
        
        guard let sprite = gApp.engine?.background else {
            valid = false
            return
        }
        
        computeIfNeeded()
        
        
        Graphics.shared.colorSet(r: 0.5, g: 0.8, b: 0.05)
        Graphics.shared.rectDraw(x: Float(center.x - 6), y: Float(center.y - 6), width: 13, height: 13)
        
        Graphics.shared.colorSet(r: 0.25, g: 1.0, b: 1.0, a: 1.0)
        
        
        
        for i in 0..<lines.count {
            
            let segment = lines.data[i]
            
            Graphics.shared.lineDraw(p1: segment.p1, p2: segment.p2, thickness: 0.5)
        }
        
        
        
        
        Graphics.shared.colorSet(r: 1.0, g: 0.0, b: 0.5)
        for i in 0..<spline.controlPointCount {
            var controlPoint = spline.getControlPoint(i)
            controlPoint = transformPoint(point: controlPoint)
            Graphics.shared.rectDraw(x: Float(controlPoint.x - 5), y: Float(controlPoint.y - 5), width: 11, height: 11)
        }
        

        
        
        
        let indexBufferCount = tri.count * 3
        let vertexBufferCount = meshNodes.count * 30
        if vertexBuffer.count < vertexBufferCount {
            vertexBuffer.reserveCapacity(vertexBufferCount)
            while(vertexBuffer.count < vertexBufferCount) {
                vertexBuffer.append(0.0)
            }
        }
        
        
        Graphics.shared.colorSet()
        
        
        if gApp.engine?.sceneMode == .edit {
            
            Graphics.shared.textureDisable()
            Graphics.shared.textureBlankBind()
            Graphics.shared.blendEnable()
            Graphics.shared.blendSetAlpha()
            
            var r:CGFloat = 0.05
            var g:CGFloat = 0.65
            var b:CGFloat = 0.05
            var a:CGFloat = 0.24
            
            if selected {
                r = 0.1
                g = 1.0
                b = 0.2
                a = 0.525
            }
            
            var vertexIndex:Int = 0
            for nodeIndex in 0..<meshNodes.count {
                let node = meshNodes.data[nodeIndex]
                node.r = r;node.g = g;node.b = b;node.a = a
                node.writeToTriangleList(&vertexBuffer, index: vertexIndex)
                vertexIndex += 10
            }
            
        } else if gApp.engine?.sceneMode == .view {
            
            Graphics.shared.textureEnable()
            Graphics.shared.textureBind(texture: sprite.texture)
            Graphics.shared.blendDisable()
            
            var vertexIndex:Int = 0
            for nodeIndex in 0..<meshNodes.count {
                let node = meshNodes.data[nodeIndex]
                
                node.r = 1.0
                node.g = 1.0
                node.b = 1.0
                node.a = 1.0
                
                node.writeToTriangleList(&vertexBuffer, index: vertexIndex)
                vertexIndex += 10
            }
            
        }
        
        
        
        Graphics.shared.bufferVertexSetData(bufferIndex: vertexBufferSlot, data: &vertexBuffer, size: vertexBufferCount)
        Graphics.shared.positionEnable()
        Graphics.shared.positionSetPointer(size: 3, offset: 0, stride: 10)
        
        Graphics.shared.texCoordEnable()
        Graphics.shared.textureCoordSetPointer(size: 3, offset: 3, stride: 10)
        
        Graphics.shared.colorArrayEnable()
        Graphics.shared.colorArraySetPointer(size: 4, offset: 6, stride: 10)
        
        Graphics.shared.bufferIndexSetData(bufferIndex: indexBufferSlot, data: &tri.indeces, size: indexBufferCount)
        Graphics.shared.drawElementsTriangle(count:indexBufferCount, offset: 0)
        
        Graphics.shared.blendDisable()
        
        
        /*
        for i in 0..<tri.count {
            
            let t = tri.data [i]
            
            let drawTriangle = DrawTriangle()
            
            let x1 = meshNodes.data[t.i1].x
            var y1 = meshNodes.data[t.i1].y
            
            let x2 = meshNodes.data[t.i2].x
            var y2 = meshNodes.data[t.i2].y
            
            let x3 = meshNodes.data[t.i3].x
            var y3 = meshNodes.data[t.i3].y
            
            y1 += meshNodes.data[t.i1].edgePercent * 20.0 * testSin3
            y2 += meshNodes.data[t.i2].edgePercent * 20.0 * testSin3
            y3 += meshNodes.data[t.i3].edgePercent * 20.0 * testSin3
            
            drawTriangle.p1 = (x1, y1, 0.0)
            drawTriangle.p2 = (x2, y2, 0.0)
            drawTriangle.p3 = (x3, y3, 0.0)
            
            drawTriangle.u1 = meshNodes.data[t.i1].u
            drawTriangle.v1 = meshNodes.data[t.i1].v
            
            drawTriangle.u2 = meshNodes.data[t.i2].u
            drawTriangle.v2 = meshNodes.data[t.i2].v
            drawTriangle.u3 = meshNodes.data[t.i3].u
            drawTriangle.v3 = meshNodes.data[t.i3].v
            
            drawTriangle.a1 = 0.88
            drawTriangle.a2 = 0.85
            drawTriangle.a3 = 0.85

            drawTriangle.draw()
        }
        */
 
        /*
        Graphics.shared.colorSet(a: 0.25)
        for i in 0..<tri.count {
            
            let t = tri.data [i]
            
            let drawTriangle = DrawTriangle()
            
            let x1 = meshNodes.data[t.i1].x
            var y1 = meshNodes.data[t.i1].y
            
            let x2 = meshNodes.data[t.i2].x
            var y2 = meshNodes.data[t.i2].y
            
            let x3 = meshNodes.data[t.i3].x
            var y3 = meshNodes.data[t.i3].y
            
            y1 += meshNodes.data[t.i1].edgePercent * 20.0 * testSin3
            y2 += meshNodes.data[t.i2].edgePercent * 20.0 * testSin3
            y3 += meshNodes.data[t.i3].edgePercent * 20.0 * testSin3
            
            Graphics.shared.lineDraw(p1: CGPoint(x: x1, y:y1), p2: CGPoint(x: x2, y: y2), thickness: 0.25)
            Graphics.shared.lineDraw(p1: CGPoint(x: x2, y:y2), p2: CGPoint(x: x3, y: y3), thickness: 0.25)
            Graphics.shared.lineDraw(p1: CGPoint(x: x3, y:y3), p2: CGPoint(x: x1, y: y1), thickness: 0.25)
        }
 
        
        
        for nodeIndex in 0..<meshNodes.count {
            let node = meshNodes.data[nodeIndex]
            
            Graphics.shared.colorSet(r: Float(node.edgePercent), g: 0.0, b: 0.0)
            Graphics.shared.pointDraw(point: CGPoint(x: node.x, y: node.y), size: 3.0)
            
        }
        
        
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                
                Graphics.shared.colorSet(color: grid[i][n].color)
                //Graphics.shared.pointDraw(point: grid[i][n].pointBase, size: 4.0)
                Graphics.shared.pointDraw(point: grid[i][n].point, size: 2.0)
            }
        }
        */

        
        
        /*
        //Draw the border grid egdes..
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                if grid[i][n].edgeL {
                    Graphics.shared.colorSet(color: UIColor.blueColor())
                    Graphics.shared.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseL), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeR {
                    Graphics.shared.colorSet(color: UIColor.redColor())
                    Graphics.shared.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseR), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeU {
                    Graphics.shared.colorSet(color: UIColor.redColor())
                    Graphics.shared.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseU), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeD {
                    Graphics.shared.colorSet(color: UIColor.purpleColor())
                    Graphics.shared.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseD), p2: grid[i][n].point, thickness: 1.0)
                }
            }
        }
        */
        
        //var linesBase = [LineSegment]()
        //var lines = [LineSegment]()
        //computeMesh()
        
    }
    
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
        //deformGridH()
        //computeGridInside()
        
        computeMesh()
        
        //computeMeshEdgeFactors()
        
        guard valid == true else { return }
        
        //computeGridTextureCoords()
        //guard valid == true else { return }
        
        computeAffine()
    }
    
    internal func computeBorder() {
        borderBase.reset()
        
        var threshDist = CGFloat(8.0)
        if gDevice.tablet { threshDist = 12.0 }
        
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
        let stepSize = minSize / 30.0
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
                
                if grid[i][n].inside {
                    grid[i][n].color = UIColor(red: 0.0, green: 1.0, blue: 0.25, alpha: 1.0)
                } else {
                    grid[i][n].color = UIColor(red: 1.0, green: 0.25, blue: 0.5, alpha: 1.0)
                }
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
    
    //tri.add(x1: left, y1: top, x2: left, y2: n, x3: i, y3: top)
    
    
    func computeMesh() {
        
        guard valid else { return }
        
        
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
        guard linesBase.count > 1 && valid else {
            valid = false
            return
        }
        
        var largestDist:CGFloat = 0.0
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
        
        guard largestDist > Math.epsilon else {
            valid = false
            return
        }
        
        for nodeIndex in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[nodeIndex]
            node.edgePercent = node.edgeDistance / largestDist
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
        
        lines.reset()
        var prev = border.data[border.count - 1]
        for i in 0..<border.count {
            let point = border.data[i]
            lines.set(index: i, p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y))
            prev = point
        }
        
        
    }
    
    internal func computeTextureCoords() {
        
        guard let sceneRect = gApp.engine?.sceneRect else {
            valid = false
            return
        }
        
        guard let sprite = gApp.engine?.background else {
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
        if needsComputeAffine { computeAffine() }
    }
    
    func untransformPoint(point:CGPoint) -> CGPoint {
        return BounceEngine.untransformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    func transformPoint(point:CGPoint) -> CGPoint {
        return BounceEngine.transformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["center_x"] = Float(center.x) as AnyObject?
        info["center_y"] = Float(center.y) as AnyObject?
        info["scale"] = Float(scale) as AnyObject?
        info["rotation"] = Float(rotation) as AnyObject?
        info["spline"] = spline.save() as AnyObject?
        return info
    }
    
    func load(info:[String:AnyObject]) {
        if let _centerX = info["center_x"] as? Float { center.x = CGFloat(_centerX) }
        if let _centerY = info["center_y"] as? Float { center.y = CGFloat(_centerY) }
        if let _scale = info["scale"] as? Float { scale = CGFloat(_scale) }
        if let _rotation = info["rotation"] as? Float { rotation = CGFloat(_rotation) }
        if let splineInfo = info["spline"] as? [String:AnyObject] { spline.load(info: splineInfo) }
        setNeedsComputeShape()
        setNeedsComputeAffine()
    }
}

