//
//  TweeterTableViewController.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/20/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CoreData

//TweetersMentioningSearchTerm
class TweeterTableViewController: CoreDataTableViewController {

    var mention: String?{didSet{updateUI()}}
    var managedObjectContext:NSManagedObjectContext?{didSet{updateUI()}}
    
    private func updateUI() {
        
        if let context = managedObjectContext where mention?.characters.count > 0 {
            
            let request = NSFetchRequest(entityName: "CDTwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "abc13")
            request.sortDescriptors = [
                NSSortDescriptor(key: "screenName",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        }
    }
    
    
    private func tweetCountWithMentionByTwitterUser(user: CDTwitterUser) -> Int? {
    
        var count:Int?
        
        user.managedObjectContext?.performBlockAndWait {
            let request = NSFetchRequest(entityName: "CDTweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and user = %@", self.mention!, user)
            count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterUserCell", forIndexPath: indexPath)
        
        if let twitterUser = fetchedResultsController?.objectAtIndexPath(indexPath) as? CDTwitterUser {
            
            var screenName:String?
            
            twitterUser.managedObjectContext?.performBlockAndWait
            {
                
                screenName = twitterUser.screenName
                
            }
            cell.textLabel?.text = screenName
            
            if let count = tweetCountWithMentionByTwitterUser(twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 Tweeet" : "\(count) Tweetz"
            } else {
                cell.detailTextLabel?.text = "X_X SOME ISSUE"
            }
        }
        return cell
    }
}
