//
//  ImageSetCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ImageSetCell : UICollectionViewCell
{
    var set: ImageSet?
    
    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadOverlayView: UIView!
    
    private var _didDownload: Bool = false
    var didDownload: Bool {
        get { return _didDownload }
        set { _didDownload = newValue }
    }
    
    private var _didAttemptDownload: Bool = false
    var didAttemptDownload: Bool {
        get { return _didAttemptDownload }
        set { _didAttemptDownload = newValue }
    }
    
    private var _isDownloading: Bool = false
    var isDownloading: Bool {
        get { return _isDownloading }
        set { _isDownloading = newValue }
    }
    
    func loadThumbComplete(thumb: UIImage) {
        
        if imageView == nil {
            
            //imageView
            
        } else {
            imageView!.image = thumb
            animateLoadComplete()
        }
    }
    
    func loadThumbError() {
        //Run to the hills, cry to mommy.
        
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true
    }
    
    
    func animateLoadComplete() {
        loadSpinner.stopAnimating()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak weakSelf = self] in
            weakSelf?.loadOverlayView.alpha = 0.0
            }, completion: { [weak weakSelf = self] didFinish in
                weakSelf?.loadOverlayView.isHidden = true
            })
    }
    
    func reset() {
        didDownload = false
        didAttemptDownload = false
        isDownloading = false
        set = nil
        imageView?.image = nil
        
        loadOverlayView.alpha = 1.0
        loadOverlayView.isHidden = false
        
        loadSpinner.isHidden = false
        loadSpinner.startAnimating()
    }
    
    
    
}
