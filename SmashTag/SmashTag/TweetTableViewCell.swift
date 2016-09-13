//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/19/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    //override func viewDid
    
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.attributedText = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            tweetScreenNameLabel?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
                {
                    //What in the devil is this systax all about? ...
                    [weak weakSelf = self, weak randomLabel = tweetTextLabel] () in
                    
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue())
                        {
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                            //randomLabel?.text = "this variable coasted along with the block"
                        }
                    }
                }
            }
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            }
            else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
    
    
}
