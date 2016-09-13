//
//  CDTwitterUser.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/20/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import CoreData


class CDTwitterUser: NSManagedObject {
    
    class func twitterUserWithTwitterInfo(twitterInfo:User, inManagedContext context: NSManagedObjectContext) -> CDTwitterUser? {
        
        let request = NSFetchRequest(entityName: "CDTwitterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        
        if let twitterUser = (try? context.executeFetchRequest(request))?.first as? CDTwitterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObjectForEntityForName("CDTwitterUser", inManagedObjectContext: context) as? CDTwitterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
        }
        
        return nil
    }
    
// Insert code here to add functionality to your managed object subclass

}
