//
//  ImageSetCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageSetCell : UICollectionViewCell
{
    var set: ImageSet?
    
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
    
    func reset() {
        didDownload = false
        didAttemptDownload = false
        isDownloading = false
        set = nil
        imageView?.image = nil
    }
    
    @IBOutlet weak var imageView: UIImageView?
    
    
}
