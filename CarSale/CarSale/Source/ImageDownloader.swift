//
//  ImageDownloader.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/30/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol ImageDownloaderDelegate
{
    func imageDownloadComplete(downloader: ImageDownloader, resultImage: UIImage, urlString: String, object: Any?)
    func imageDownloadError(downloader: ImageDownloader, urlString: String, object: Any?)
}

//This will manage up to n image downloads at at time,
//where n = concurrentImagePulls.

//According to Amazon's research, the optimal number
//of concurrent mobile image downloads is 2.

let concurrentImagePulls:Int = 3
class ImageDownloader : NSObject, ImageDownloaderTaskDelegate
{
    static let shared = ImageDownloader()
    private override init() {
        super.init()
        
        while tasks.count < concurrentImagePulls {
            let task = ImageDownloaderTask()
            task.delegate = self
            tasks.append(task)
        }
    }
    
    var delegate:ImageDownloaderDelegate?
    
    private var tasks = [ImageDownloaderTask]()
    
    var isReady: Bool {
        for task in tasks {
            if task.active == false {
                return true
            }
        }
        return false
    }
    
    func addDownload(forURL: String, withObject: Any?) {
        for task in tasks {
            if task.active == false {
                task.start(withURL: forURL, forObject: withObject)
                return
            }
        }
    }
    
    
    func taskComplete(task: ImageDownloaderTask, resultImage: UIImage, urlString: String, object: Any?){
        delegate?.imageDownloadComplete(downloader: self, resultImage: resultImage, urlString: urlString, object: object)
        
        //If there are additional image downloads enqueued, start one.
    }
    
    func taskError(task: ImageDownloaderTask, urlString: String, object: Any?) {
        delegate?.imageDownloadError(downloader: self, urlString: urlString, object: object)
    }
    
    
}
