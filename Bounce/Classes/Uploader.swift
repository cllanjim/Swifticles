//
//  Uploader.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/27/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//


//
//  ApplicationController.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class Uploader : NSObject, URLSessionDelegate
{
    static let shared = Uploader()
    private override init() {
        super.init()
    }
    
    private enum UploadState: UInt32 { case pending = 0, image = 1, thumb = 2, data = 3 }
    private var state:UploadState = .pending
    
    
    var session:URLSession?
    var sessionDataTask:URLSessionDataTask?
    
    var uploadImage:UIImage?
    var uploadThumb:UIImage?
    
    var imageName:String?
    
    var imageID: Int?
    var thumbID: Int?
    
    func reset() {
        state = .pending
        
        sessionDataTask?.cancel()
        sessionDataTask = nil
        
        session?.invalidateAndCancel()
        session = nil
        
        imageID = nil
        thumbID = nil
        
        uploadImage = nil
        uploadThumb = nil
    }
    
    func upload(image: UIImage, thumb: UIImage, scene: BounceScene) -> Void {
        reset()
        
        uploadImage = image
        uploadThumb = thumb
        
        imageName = scene.imageName
        
        state = .pending
        advance()
    }
    
    func advance() {
        if state == .pending {
            print("advance(.pending)")
            
            if uploadImage != nil && imageName != nil {
                state = .image
                uploadImage(image: uploadImage!, name: imageName!)
            } else {
                fail()
            }
        } else if state == .image {
            print("advance(.image)")
            
            if uploadThumb != nil && imageName != nil {
                state = .thumb
                uploadImage(image: uploadThumb!, name: imageName!)
            } else {
                fail()
            }
        } else if state == .thumb {
            print("advance(.thumb)")
            uploadScene()
        }
    }
    
    func fail() {
        
    }
    
    func uploadScene() {
        
        if imageID != nil && thumbID != nil {
            
            var urlString = "http://www.froggystudios.com/bounce/create_scene.php?name="
            urlString = urlString + "scene001"
            urlString = urlString + "&imageid=" + String(imageID!)
            urlString = urlString + "&thumbid=" + String(thumbID!)
            
            print("\(urlString)")
            
            let request = NSURLRequest(url: URL(string: urlString)!)
            
            self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            
            self.sessionDataTask = session!.dataTask(with: request as URLRequest, completionHandler:
                {
                    [weak weakSelf = self] (data, response, error) -> Void in
                    
                    if data == nil || response == nil || error != nil {
                        weakSelf?.fail()
                    } else {
                        
                        DispatchQueue.main.async { //[strongSelf = weakSelf] in
                            
                            let jsonData = FileUtils.parseJSON(data: data) as? [String:AnyObject]
                            
                            
                            print("JSON DATA = ")
                            print("\(jsonData)")
                        }
                    }
                    
                })
            sessionDataTask?.resume()
            
            
            
            
        } else {
            fail()
        }
        
        
    }
    
    
    func uploadImage(image: UIImage, name: String) {
        
        var imageData = UIImageJPEGRepresentation(image, 70)
        
        var urlString = "http://www.froggystudios.com/bounce/upload_image.php?name="
        
        if state == .thumb {
            urlString = urlString + name + "_thumb"
            urlString = urlString + "&width=" + String(Int(image.size.width))
            urlString = urlString + "&height=" + String(Int(image.size.height))
        } else {
            urlString = urlString + name
            urlString = urlString + "&width=" + String(Int(image.size.width))
            urlString = urlString + "&height=" + String(Int(image.size.height))
        }
        
        
        
        let request = NSMutableURLRequest()
        request.url = URL(string: urlString)

        request.httpMethod = "POST"

        let boundary = "---------------------------347A2FL8KEN1CK3DLJR4PT1SGLKD5"
        let contentType = "multipart/form-data; boundary=\(boundary)"

        request.addValue(contentType, forHTTPHeaderField: "Content-Type")

        var body = NSMutableData()

        body.append((String("\r\n--\(boundary)\r\n")?.data(using: String.Encoding.utf8))!)
        body.append((String("Content-Disposition: form-data; name=\"photo\"; filename=\"bounce/ipodfile.jpg\"\r\n")?.data(using: String.Encoding.utf8))!)
        body.append((String("Content-Type: application/octet-stream\r\n\r\n")?.data(using: String.Encoding.utf8))!)
        body.append(imageData!)
        body.append((String("\r\n--\(boundary)--\r\n")?.data(using: String.Encoding.utf8))!)

        request.httpBody = (body as Data)
        
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)

        self.sessionDataTask = session!.dataTask(with: request as URLRequest, completionHandler:
            {
                [weak weakSelf = self] (data, response, error) -> Void in
                
                if data == nil || response == nil || error != nil {
                    weakSelf?.fail()
                } else {
                    
                    DispatchQueue.main.async { //[strongSelf = weakSelf] in
                        
                        let jsonData = FileUtils.parseJSON(data: data) as? [String:AnyObject]
                        
                        var imageID: Int?
                        var imageURL: String?
                        
                        if let json = jsonData {
                            imageID = json["id"] as? Int
                            imageURL = json["imageURL"] as? String
                        }
                        
                        if let strongSelf = weakSelf {
                        if imageID != nil && imageURL != nil {
                            
                            if strongSelf.state == .image {
                                strongSelf.imageID = imageID
                            } else {
                                strongSelf.thumbID = imageID
                            }
                            strongSelf.advance()
                        } else {
                            strongSelf.fail()
                        }
                        }
                        
                        
                        
                        print("JSON DATA = ")
                        print("\(jsonData)")
                     
                        
                        
                        
                    }
                }
        })
        sessionDataTask?.resume()
    }
    
}
