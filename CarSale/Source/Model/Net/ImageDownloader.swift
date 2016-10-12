//
//  ImageDownloader.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

//This should be converted into a notification, all kinds of
//shit wants to listen to the image downloader. Caching, thumbs,
//different pages in background and foreground..
protocol ImageDownloaderDelegate
{
    func imageDownloadComplete(downloader: ImageDownloader, resultImage: UIImage, urlString: String, object: Any?)
    func imageDownloadError(downloader: ImageDownloader, urlString: String, object: Any?)
}

//This will manage up to n image downloads at at time,
//where n = concurrentImagePulls.

//According to Amazon's research, the optimal number
//of concurrent mobile thumbnail image downloads is 2.

let concurrentImagePulls:Int = 2
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
    
    func cancelAll() {
        for task in tasks {
            task.clear()
        }
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
    }
    
    func taskError(task: ImageDownloaderTask, urlString: String, object: Any?) {
        delegate?.imageDownloadError(downloader: self, urlString: urlString, object: object)
    }
    
}
