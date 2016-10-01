//
//  ImageDownloader.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/30/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

let concurrentImagePulls:Int = 3

//TODO: Think about this thing - how should it work?

class ImageDownloader : NSObject, WebFetcherDelegate
{
    
    private let fetcher = [WebFetcher](repeating: WebFetcher(), count:concurrentImagePulls)
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    
}
