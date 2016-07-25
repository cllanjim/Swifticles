//
//  ImportScrollView.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImportScrollView: UIScrollView, UIScrollViewDelegate {
    
    @IBOutlet var imageView:UIImageView?
    
    var image:UIImage? {
        didSet {
            if imageView == nil {
                
                image = image?.resize(CGSizeMake(5000, 8000))
                
                imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image!.size.width, height: image!.size.height))
                imageView!.image = image
                
                self.addSubview(imageView!)
                self.contentSize = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
                
                delegate = self
                maximumZoomScale = 2.0
                minimumZoomScale = 0.2
            }
        }
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /*
    
    optional public func scrollViewDidScroll(scrollView: UIScrollView) // any offset changes
    {
        
    }
    
    optional public func scrollViewDidZoom(scrollView: UIScrollView) // any zoom scale changes
    {
        
    }
    
    // called on start of dragging (may require some time and or distance to move)
    @available(iOS 2.0, *)
    optional public func scrollViewWillBeginDragging(scrollView: UIScrollView)
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @available(iOS 5.0, *)
    optional public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @available(iOS 2.0, *)
    optional public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    @available(iOS 2.0, *)
    optional public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) // called on finger up as we are moving
    @available(iOS 2.0, *)
    optional public func scrollViewDidEndDecelerating(scrollView: UIScrollView) // called when scroll view grinds to a halt
    
    @available(iOS 2.0, *)
    optional public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    
    @available(iOS 2.0, *)
    optional public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens
    @available(iOS 3.2, *)
    optional public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) // called before the scroll view begins zooming its content
    @available(iOS 2.0, *)
    optional public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
    
    @available(iOS 2.0, *)
    optional public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    @available(iOS 2.0, *)
    optional public func scrollViewDidScrollToTop(scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
    
    */

    
}
