//
//  ImageDownloaderTask.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

protocol ImageDownloaderTaskDelegate
{
    func taskComplete(task: ImageDownloaderTask, resultImage: UIImage, urlString: String, object: Any?)
    func taskError(task: ImageDownloaderTask, urlString: String, object: Any?)
}

class ImageDownloaderTask : NSObject, WebFetcherDelegate
{
    var delegate:ImageDownloaderTaskDelegate?
    
    var active: Bool = false
    
    private var attemptCount: Int = 0
    private var urlString: String = ""
    private var object: Any?
    
    var _fetcher: WebFetcher?
    var fetcher: WebFetcher {
        if _fetcher == nil {
            _fetcher = WebFetcher()
            _fetcher!.delegate = self
        }
        return _fetcher!
    }
    
    func start(withURL: String, forObject: Any?) {
        clear()
        urlString = String(withURL)
        object = forObject
        restart()
    }
    
    internal func restart() {
        active = true
        fetcher.clear()
        fetcher.fetch(urlString)
        attemptCount += 1
    }
    
    func clear() {
        active = false
        fetcher.clear()
        if active {
            delegate?.taskError(task: self, urlString: urlString, object: object)
            active = false
        }
        attemptCount = 0
        urlString = ""
        object = nil
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        var success:Bool = false
        if fetcher.data != nil {
            if let image = UIImage(data: fetcher.data!), image.size.width > 2.0 && image.size.height > 2.0 {
                active = false
                delegate?.taskComplete(task: self, resultImage: image, urlString: urlString, object: object)
                success = true
            }
        }
        if success == false {
            fetchDidFail(fetcher: fetcher, result: .error)
        }
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
        //We'll try pulling the image 3 times.
        if attemptCount < 4 {
            restart()
        } else {
            active = false
            delegate?.taskError(task: self, urlString: urlString, object: object)
        }
    }
}

