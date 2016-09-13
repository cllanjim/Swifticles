//
//  ImageViewController.swift
//  Cassini
//
//  Created by Raptis, Nicholas on 7/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL:NSURL? {
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    //https://upload.wikimedia.org/wikipedia/commons/9/9d/243_Ida_large.jpg
    
    private var imageView = UIImageView()
    
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
    
    private var image : UIImage? {
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
    
    private func fetchImage(){
        
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
            {
                let contentsOfURL = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue())
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
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    
}
