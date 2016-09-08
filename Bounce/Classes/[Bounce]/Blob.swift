//
//  Blob.swift
//
//  Created by Raptis, Nicholas on 8/22/16.
//

import UIKit
import OpenGLES



struct BlobGridNode {
    //Base = untransformed, no Base = transformed...
    var point:CGPoint = CGPointZero
    var pointBase:CGPoint = CGPointZero
    
    var meshIndex:Int?
    
    var edgeU:Bool = false
    var edgeR:Bool = false
    var edgeD:Bool = false
    var edgeL:Bool = false
    
    
    var edgePointBaseU:CGPoint = CGPointZero
    var edgePointBaseR:CGPoint = CGPointZero
    var edgePointBaseD:CGPoint = CGPointZero
    var edgePointBaseL:CGPoint = CGPointZero
    
    var texturePoint:CGPoint = CGPointZero
    
    var inside:Bool = false
    
    var color:UIColor = UIColor.whiteColor()
}

public class Blob
{
    var grid = [[BlobGridNode]]()
    
    var meshNodes = DrawNodeBuffer()
    var meshNodesBase = DrawNodeBuffer()
    
    
    weak var touch:UITouch?
    
    var spline = CubicSpline()
    
    var valid:Bool = false
    
    var tri = IndexTriangleList()
    
    
    var linesBase = LineSegmentBuffer()//[LineSegment]()
    var lines = LineSegmentBuffer()//[LineSegment]()
    
    //Base = untransformed, no Base = transformed...
    var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256) { didSet { needsComputeAffine = true } }
    var scale:CGFloat = 1.0 { didSet { needsComputeAffine = true } }
    var rotation:CGFloat = 0.0 { didSet { needsComputeAffine = true } }
    
    
    func setNeedsComputeShape() { needsComputeShape = true }
    internal var needsComputeShape:Bool = true
    func setNeedsComputeAffine() { needsComputeAffine = true }
    internal var needsComputeAffine:Bool = true
    
    internal var boundingBox:CGRect = CGRectZero
    
    var touchPoint:CGPoint = CGPointZero
    
    var enabled: Bool {
        return true
    }
    
    var selectable:Bool {
        return true
    }
    
    init() {
        spline.add(0.0, y: -100)
        //spline.add(50.0, y: -50)
        spline.add(100, y: 0.0)
        //spline.add(50.0, y: 50)
        spline.add(0.0, y: 100.0)
        spline.add(-50.0, y: 50)
        spline.add(-100.0, y: 0.0)
        //spline.add(-50.0, y: -50)
        
        spline.linear = false
        spline.closed = true
        
        computeShape()
    }
    
    func update() {
        
    }
    
    func draw() {
        
        guard let sprite = gApp.engine?.background else {
            valid = false
            return
        }
        
        
        computeIfNeeded()
        
        gG.colorSet(r: 0.5, g: 0.8, b: 0.05)
        gG.rectDraw(x: Float(center.x - 6), y: Float(center.y - 6), width: 13, height: 13)
        
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.0)
        borderBase.drawEdges(closed: false)
        border.drawEdges(closed: true)
        
        gG.colorSet(r: 0.25, g: 0.88, b: 0.89)
        border.drawPoints()
        
        //gG.colorSet(r: 0.25, g: 0.15, b: 0.88, a: 0.22)
        //gG.rectDraw(border.getBoundingBox(padding: 5.0))
        
        
        gG.colorSet(r: 0.25, g: 1.0, b: 1.0, a: 1.0)
        
        
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.5)
        for i in 0..<spline.controlPointCount {
            
            var controlPoint = spline.getControlPoint(i)
            
            controlPoint = transformPoint(point: controlPoint)
            
            gG.rectDraw(x: Float(controlPoint.x - 5), y: Float(controlPoint.y - 5), width: 11, height: 11)
        }
        
        
        gG.colorSet(color: UIColor.yellowColor())
        gG.pointDraw(point: touchPoint, size: 19.25)
        
        
        gG.colorSet()
        gG.textureEnable()
        gG.textureBind(texture: sprite.texture)
        
        
        for i in 0..<tri.count {
            
            var t = tri.data [i]
            
            var drawTriangle = DrawTriangle()
            
            var x1 = meshNodes.data[t.i1].x
            var y1 = meshNodes.data[t.i1].y
            
            var x2 = meshNodes.data[t.i2].x
            var y2 = meshNodes.data[t.i2].y
            
            var x3 = meshNodes.data[t.i3].x
            var y3 = meshNodes.data[t.i3].y
            
            //gG.lineDraw(p1: CGPoint(x: x1, y: y1), p2: CGPoint(x: x2, y: y2), thickness: 0.25)
            //gG.lineDraw(p1: CGPoint(x: x2, y: y2), p2: CGPoint(x: x3, y: y3), thickness: 0.25)
            //gG.lineDraw(p1: CGPoint(x: x3, y: y3), p2: CGPoint(x: x1, y: y1), thickness: 0.25)
            
            drawTriangle.p1 = (x1, y1, 0.0)
            drawTriangle.p2 = (x2, y2, 0.0)
            drawTriangle.p3 = (x3, y3, 0.0)
            
            
            drawTriangle.draw()
            
            /*
            if  t.x1 >= 0 && t.x1 < grid.count && t.x2 >= 0 && t.x2 < grid.count && t.x3 >= 0 && t.x3 < grid.count &&
                t.y1 >= 0 && t.y1 < grid[0].count && t.y2 >= 0 && t.y2 < grid[0].count && t.y3 >= 0 && t.y3 < grid[0].count {
                
                var x1 = grid[t.x1][t.y1].point.x
                var y1 = grid[t.x1][t.y1].point.y
                
                var x2 = grid[t.x2][t.y2].point.x
                var y2 = grid[t.x2][t.y2].point.y
                
                var x3 = grid[t.x3][t.y3].point.x
                var y3 = grid[t.x3][t.y3].point.y
                
                //gG.lineDraw(p1: CGPoint(x: x1, y: y1), p2: CGPoint(x: x2, y: y2), thickness: 0.25)
                //gG.lineDraw(p1: CGPoint(x: x2, y: y2), p2: CGPoint(x: x3, y: y3), thickness: 0.25)
                //gG.lineDraw(p1: CGPoint(x: x3, y: y3), p2: CGPoint(x: x1, y: y1), thickness: 0.25)
                
                drawTriangle.p1 = (x1, y1, 0.0)
                drawTriangle.p2 = (x2, y2, 0.0)
                drawTriangle.p3 = (x3, y3, 0.0)
                
                drawTriangle.u1 = grid[t.x1][t.y1].texturePoint.x
                drawTriangle.v1 = grid[t.x1][t.y1].texturePoint.y
                
                
                drawTriangle.u2 = grid[t.x2][t.y2].texturePoint.x
                drawTriangle.v2 = grid[t.x2][t.y2].texturePoint.y
                
                drawTriangle.u3 = grid[t.x3][t.y3].texturePoint.x
                drawTriangle.v3 = grid[t.x3][t.y3].texturePoint.y
                
                //drawTriangle.c1 = (0.5, 0.5, 1.0, 1.0)
                //drawTriangle.c2 = (1.0, 1.0, 0.5, 1.0)
                
                
                
                //drawTriangle.u1 = 0.0
                //drawTriangle.v1 = 0.0
                
                //drawTriangle.u2 = 1.0
                //drawTriangle.v2 = 0.5
                
                //drawTriangle.u3 = 0.5
                //drawTriangle.v3 = 1.0
                
                
                
                
                
                
                
                drawTriangle.draw()
                
            }
            */
        }
 
        
        
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                
                gG.colorSet(color: grid[i][n].color)
                //gG.pointDraw(point: grid[i][n].pointBase, size: 4.0)
                gG.pointDraw(point: grid[i][n].point, size: 2.0)
            }
        }
        
        
        var ls = LineSegment()
        ls.p1 = CGPoint(x: 500.0, y: 120)
        ls.p2 = CGPoint(x: 500.0, y: 350.0)
        
        gG.colorSet(r: 1.0, g: 1.0, b: 1.0)
        
        gG.lineDraw(p1: ls.p1, p2: ls.p2, thickness: 3)
        
        var planeDir = ls.direction
        var planeX = ls.x1
        var planeY = ls.x2
        
        
        for i in 0..<lines.count {
            
            var segment = lines.data[i]
        //for segment in lines {
            
            if LineSegment.SegmentsIntersect(l1: segment, l2: ls) {
            let result = LineSegment.LinePlaneIntersection(line: segment, planeX: planeX, planeY: planeY, planeDirX: planeDir.x, planeDirY: planeDir.y)
            
            if result.intersects {
                gG.colorSet(r: 1.0, g: 0.2, b: 0.2)
                
                gG.pointDraw(point: result.point, size: 14.0)
                
            } else {
                gG.colorSet(r: 0.2, g: 1.0, b: 0.7)
            }
                
            }
            
            //if result.
            
            
            /*
            if LineSegment.SegmentsIntersect(l1: segment, l2: ls) {
                gG.colorSet(r: 1.0, g: 0.2, b: 0.2)
            } else {
                gG.colorSet(r: 0.2, g: 1.0, b: 0.7)
            }
            */
            
            gG.lineDraw(p1: segment.p1, p2: segment.p2, thickness: 0.66)
            
            
        }
        
        //Draw the border grid egdes..
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                if grid[i][n].edgeL {
                    gG.colorSet(color: UIColor.blueColor())
                    gG.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseL), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeR {
                    gG.colorSet(color: UIColor.redColor())
                    gG.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseR), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeU {
                    gG.colorSet(color: UIColor.redColor())
                    gG.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseU), p2: grid[i][n].point, thickness: 1.0)
                }
                
                if grid[i][n].edgeD {
                    gG.colorSet(color: UIColor.purpleColor())
                    gG.lineDraw(p1: transformPoint(point: grid[i][n].edgePointBaseD), p2: grid[i][n].point, thickness: 1.0)
                }
            }
        }
        
        
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
        
        //deformGridH()
        //computeGridInside()
        
        computeMesh()
        
        guard valid == true else { return }
        
        //computeGridTextureCoords()
        //guard valid == true else { return }
        
        computeAffine()
    }
    
    internal func computeBorder() {
        borderBase.reset()
        
        var threshDist = CGFloat(12.0)
        if gDevice.tablet { threshDist = 18 }
        
        threshDist = (threshDist * threshDist)
        
        let step = CGFloat(0.01)
        var prevPoint = spline.get(0.0)
        let lastPoint = spline.get(spline.maxPos)
        
        borderBase.add(x: prevPoint.x, y: prevPoint.y)
        for pos:CGFloat in step.stride(to: CGFloat(spline.maxPos), by: step) {
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
        
        var prev = borderBase.data[borderBase.count - 1]
        for i in 0..<borderBase.count {
            let point = borderBase.data[i]
            linesBase.set(index: i, p1: prev, p2: point)
            prev = point
        }
    }
 
    func computeGridPoints() {
        let minSize = min(boundingBox.size.width, boundingBox.size.height)
        let stepSize = minSize / 10.0
        var countX = 0
        var countY = 0
        let leftX = boundingBox.origin.x
        let rightX = leftX + boundingBox.size.width
        for _ in leftX.stride(to: rightX, by: stepSize) {
            countX += 1
        }
        
        let topY = boundingBox.origin.y
        let bottomY = topY + boundingBox.size.height
        for _ in topY.stride(to: bottomY, by: stepSize) {
            countY += 1
        }
        
        grid = [[BlobGridNode]](count: countX, repeatedValue:[BlobGridNode](count: countY, repeatedValue: BlobGridNode()))
        
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
    
        
    //var meshNodes = DrawNodeBuffer()
    //var meshNodesBase = DrawNodeBuffer()
    
        
    func meshIndex(gridX: Int, _ gridY: Int) -> Int {
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
    
    func computeMesh() {
        
        guard valid else { return }
        
        computeGridEdges()
        
        for i in 0..<grid.count {
            for n in 1..<grid[i].count {
                grid[i][n].meshIndex = nil
                
            }
        }
        
        tri.reset()
        meshNodes.reset()
        
        //First handle all the easy cases, where the entire
        //quad is on the inside.
        for i in 1..<grid.count {
            for n in 1..<grid[i].count {
                let top = n - 1
                let left = i - 1
                
                //All 4 tri's IN
                if grid[left][top].inside && grid[i][top].inside && grid[left][n].inside && grid[i][n].inside {
                    tri.add(i1: meshIndex(left, top), i2: meshIndex(left, n), i3: meshIndex(i, top))
                    
                    //tri.add(x1: left, y1: top, x2: left, y2: n, x3: i, y3: top)
                    //tri.add(x1: left, y1: n, x2: i, y2: top, x3: i, y3: n)
                    
                }
                
                //meshIndex
                
                // else if grid[left][top].inside && grid[i][top].inside && grid[left][n].inside {
                //    tri.add(x1: left, y1: top, x2: left, y2: n, x3: i, y3: top)
                //} else if grid[left][top].inside && grid[i][top].inside && grid[i][n].inside {
                //    tri.add(x1: left, y1: top, x2: i, y2: top, x3: i, y3: n)
                //} else if grid[left][top].inside && grid[left][n].inside && grid[i][n].inside {
                //    tri.add(x1: left, y1: top, x2: left, y2: n, x3: i, y3: n)
                //} else if grid[i][top].inside && grid[left][n].inside && grid[i][n].inside {
                //    tri.add(x1: left, y1: n, x2: i, y2: top, x3: i, y3: n)
                //}
            }
        }
        
        
        
        
        //meshNodesBase
        
        
    }
    
    
    func closestBorderPointUp(point point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x, y: point.y - 512.0)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointRight(point point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x + 512.0, y: point.y)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointDown(point point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x, y: point.y + 512.0)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPointLeft(point point:CGPoint) -> CGPoint {
        let segment = LineSegment()
        segment.p1 = CGPoint(x: point.x, y: point.y)
        segment.p2 = CGPoint(x: point.x - 512.0, y: point.y)
        return closestBorderPoint(segment: segment)
    }
    
    func closestBorderPoint(segment segment:LineSegment) -> CGPoint {
        var result = CGPoint(x: segment.x1, y: segment.y1)
        var bestDist:CGFloat?
        let planeX = segment.x1
        let planeY = segment.y1
        let planeDir = segment.direction
        
        for i in 0..<linesBase.count {
        //for line in linesBase {
            let line = linesBase.data[i]
            if LineSegment.SegmentsIntersect(l1: segment, l2: line) {
                let intersection = LineSegment.LinePlaneIntersection(line: line, planeX: planeX, planeY: planeY, planeDirX: planeDir.x, planeDirY: planeDir.y)
                if intersection.intersects {
                    if bestDist == nil || (intersection.distance < bestDist) {
                        bestDist = intersection.distance
                        result = intersection.point
                    }
                }
            }
        }
        return result
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
        
        
        for i in 0..<meshNodesBase.count {
            
            let node = meshNodesBase.data[i]
            meshNodes.set(index: i, node: node)
            
            var point = transformPoint(point: CGPoint(x: meshNodes.data[i].x, y: meshNodes.data[i].y))
            meshNodes.data[i].x = point.x
            meshNodes.data[i].y = point.y
            
        }
        
        computeGridTextureCoords()
        
        for i in 0..<meshNodesBase.count {
            let node = meshNodesBase.data[i]
            meshNodes.set(index: i, node: node)
        }
        
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
    
    internal func computeGridTextureCoords() {
        
        guard let sceneRect = gApp.engine?.sceneRect else {
            valid = false
            return
        }
        
        guard let sprite = gApp.engine?.background else {
            valid = false
            return
        }
        
        //sprite
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
        
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                
                let x = Double(grid[i][n].point.x)
                let y = Double(grid[i][n].point.y)
                
                let percentX = (x - startX) / spanX
                let percentY = (y - startY) / spanY
                
                let u = startU + spanU * percentX
                let v = startV + spanV * percentY
                
                grid[i][n].texturePoint = CGPoint(x: CGFloat(u), y: CGFloat(v))
            }
        }
        
        
        
        //lines
        
        
    }
    
    internal func computeIfNeeded() {
        if needsComputeShape { computeShape() }
        if needsComputeAffine { computeAffine() }
    }
    
    func untransformPoint(point point:CGPoint) -> CGPoint {
        return BounceEngine.untransformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    func transformPoint(point point:CGPoint) -> CGPoint {
        return BounceEngine.transformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["center_x"] = Float(center.x)
        info["center_y"] = Float(center.y)
        info["scale"] = Float(scale)
        info["rotation"] = Float(rotation)
        info["spline"] = spline.save()
        return info
    }
    
    func load(info info:[String:AnyObject]) {
        if let _centerX = info["center_x"] as? Float { center.x = CGFloat(_centerX) }
        if let _centerY = info["center_y"] as? Float { center.y = CGFloat(_centerY) }
        if let _scale = info["scale"] as? Float { scale = CGFloat(_scale) }
        if let _rotation = info["rotation"] as? Float { rotation = CGFloat(_rotation) }
        if let splineInfo = info["spline"] as? [String:AnyObject] { spline.load(info: splineInfo) }
        setNeedsComputeShape()
        setNeedsComputeAffine()
    }
}

