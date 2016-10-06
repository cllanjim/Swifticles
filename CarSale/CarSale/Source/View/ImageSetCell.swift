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
    
    @IBOutlet weak var button: CellHighlightButton?
    
    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadOverlayView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        
    }
    
    func setUp() {
    
        layer.shadowOffset = CGSize(width: -2, height: 2.0)
        layer.shadowColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.20).cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        
        layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.04).cgColor
        layer.borderWidth = 1.0
        
        clipsToBounds = false
        
        //layer.shadowRadius
        
        
    }
    
    
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
