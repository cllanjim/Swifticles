//
//  ImageViewController.swift
//  Cassini
//
//  Created by Raptis, Nicholas on 7/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL:URL? {
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.startAnimating()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    fileprivate var image : UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
        
    }
    
    fileprivate func fetchImage(){
        
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
            {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async
                {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        print("Ignore Image Data, Wrong URL Pal!")
                    }
                }
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    
}
