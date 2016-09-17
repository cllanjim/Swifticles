//
//  DropItView.swift
//  DropIt
//
//  Created by Raptis, Nicholas on 7/21/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class DropItView: NamedBezierPathView, UIDynamicAnimatorDelegate {

    let dropBehavior = FallingObjectBehavior()
    
    private lazy var animator:UIDynamicAnimator = {
        
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    private let dropsPerRow = 10
    
    var animating: Bool = false {
        
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        
        return CGSize(width: size, height: size)
    }
    
    
    private var lastDrop: UIView?
    
    func addDrop(){
        
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        addSubview(drop)
        dropBehavior.addItem(drop)
        lastDrop = drop
    }
    
    func grabDrop(rec:UIPanGestureRecognizer) {
        
        let gesturePoint = rec.locationInView(self)
        switch rec.state {
        case .Began:
            if let dropToAttach = lastDrop where dropToAttach.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttach, attachedToAnchor: gesturePoint)
                lastDrop = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }
    
    
    private var attachment:UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment!.action = {
                    
                    [unowned self] in
                    
                    if let attachedDrop = self.attachment!.items.first as? UIView {
                        self.bezierPaths["attachment"] = UIBezierPath.lineFrom(self.attachment!.anchorPoint, to: attachedDrop.center)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let path = UIBezierPath(ovalInRect: CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addBarrier(path, named: "middle_barrier")
        //bezierP
        bezierPaths["middle_barrier"] = path
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    private func removeCompletedRow()
    {
        var dropsToRemove = [UIView]()
        
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropsTested = 0
            var dropsFound = [UIView]()
            while dropsTested < dropsPerRow {
                if let hitView = hitTest(hitTestRect.mid) where hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                hitTestRect.origin.x += dropSize.width
                dropsTested += 1
            }
            if dropsTested == dropsPerRow {
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            dropBehavior.removeItem(drop)
            drop.removeFromSuperview()
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
