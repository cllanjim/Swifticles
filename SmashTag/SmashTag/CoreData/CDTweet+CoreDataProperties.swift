//
//  CDTweet+CoreDataProperties.swift
//  SmashTag
//
//  Created by Raptis, Nicholas on 7/20/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDTweet {

    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var posted: NSDate?
    @NSManaged var user: CDTwitterUser?

}
