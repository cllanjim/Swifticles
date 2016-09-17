//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/19/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var twitterRequest:TwitterRequest? {
        if let query = searchText where !query.isEmpty {
            return TwitterRequest(search: query + " -filter:retweers", count: 100)
        }
        return nil
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private func searchForTweets() {
        
        if let request = twitterRequest {
            request.fetchTweets {[weak weakSelf = self] (newTweets:[Tweet]) in
                dispatch_async(dispatch_get_main_queue()) {
                    if !newTweets.isEmpty {
                        weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        weakSelf?.updateDatabase(newTweets)
                    }
                }
            }
        }
    }
    
    private func updateDatabase(newTweets:[Tweet]) {
        
        managedObjectContext?.performBlock {
            for twitterInfo in newTweets {
                
                CDTweet.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: self.managedObjectContext!)
                
                //create new unique core data tweet object.
                
            }
            
            do {
            
            try self.managedObjectContext?.save()
                
                
            } catch let error {
                print("Core Data Error = \(error)")
            }
            
        }
        
        printDatabaseStats()
        print("done printing database stats...")
        
    }
    
    private func printDatabaseStats() {
        
        /*
        managedObjectContext?.performBlock {
            if let results = try? self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "CDTwitterUser")) {
                print("\(results.count) twitter users")
            }
            
            //More efficient, according to the great Paul H!
            let tweetCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "CDTweet"), error: nil)
            print("\(tweetCount) tweets!")
            
            
        }
        */
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchText = "#nasa"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    private struct Storyboard {
     
        static let TweetCellIdentifier = "tweet_cell"
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        
        
        //cell?.textLabel?.text = tweet.text
        //cell?.detailTextLabel?.text = tweet.user.name
        
        
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBOutlet weak var searchTextFied: UITextField!
        {
        didSet {
            searchTextFied.delegate = self
            searchTextFied.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchTextFied.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweeterTVC = segue.destinationViewController as?
                
                TweeterTableViewController {
                
                tweeterTVC.mention = searchText
                tweeterTVC.managedObjectContext = managedObjectContext
                
            }
        }
    }
}











