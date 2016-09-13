//
//  CDTweet.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/20/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import CoreData


class CDTweet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func tweetWithTwitterInfo(twitterInfo:Tweet, inManagedObjectContext context:NSManagedObjectContext) -> CDTweet? {
        
        let request = NSFetchRequest(entityName:"CDTweet")
        
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? CDTweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("CDTweet", inManagedObjectContext: context) as? CDTweet {
            
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.user = CDTwitterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedContext: context)
            
        }
        
        /*
        do {
            let queryResult = try context.executeFetchRequest(request)
            
            if let tweet = queryResult.first as? CDTweet {
                return tweet
            }
            
        } catch let error {
            
        }
         */
        
        
        //request.
        
        
        return nil
    }
    
    
}
