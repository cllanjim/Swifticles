//
//  AllQandAsTableViewController.swift
//  Pollster
//
//  Created by Raptis, Nicholas on 8/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CloudKit

class AllQandAsTableViewController : UITableViewController
{
    var allQandAs = [CKRecord]() {didSet { tableView.reloadData() } }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllQandAs()
        iCloudSubscribeToQandAs()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        iCloudUnsubscribeToQandAs()
    }
    
    
    private let database = CKContainer.defaultContainer().publicCloudDatabase
    
    private func fetchAllQandAs() {
        
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: Cloud.Entity.QandA, predicate: predicate)
        
        database.performQuery(query, inZoneWithID: nil) {(records, error) in
            
            if records != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.allQandAs = records!
                }
            }
        }
    }
    
    //MARK: Subscription
    
    private let subscriptionID = "All QandA Creations and Deletions"
    private var cloudKitObserver:NSObjectProtocol?
    
    private func iCloudSubscribeToQandAs() {
        
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        let subscription = CKSubscription(recordType: Cloud.Entity.QandA, predicate: predicate, subscriptionID: subscriptionID, options: [.FiresOnRecordCreation, .FiresOnRecordDeletion])
        
        database.saveSubscription(subscription) { (savedSubscription, error) in
            
            if error?.code == CKErrorCode.ServerRejectedRequest.rawValue {
                //ignore
            } else if error != nil {
                //report
            }
            
        }
        
        cloudKitObserver = NSNotificationCenter.defaultCenter().addObserverForName(CloudKitNotifications.NotificationReceived, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification) in
        
            if let ckqn = notification.userInfo?[CloudKitNotifications.NotificationReceived] as? CKQueryNotification {
                
                //self.i
                
                
            }
        
        })
        
    }
    
    private func iCloudHandleSubscriptionNotification(ckqn:CKQueryNotification) {
        
        if ckqn.subscriptionID == self.subscriptionID {
            if let recordID = ckqn.recordID {
                
                switch ckqn.queryNotificationReason {
                    
                case .RecordCreated:
                    database.fetchRecordWithID(recordID){ (record, error) in
                        if record != nil {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.allQandAs = (self.allQandAs + [record!]).sort {
                                    return $0.question < $1.question
                                }
                            }
                        }
                    }
                    break
                case .RecordDeleted:
                    dispatch_async(dispatch_get_main_queue()) {
                        self.allQandAs = self.allQandAs.filter {
                            $0.recordID != recordID
                        }
                    }
                    break
                default:
                    break
                }
                
            }
        }
        
    }
    
    private func iCloudUnsubscribeToQandAs() {

        database.deleteSubscriptionWithID(subscriptionID) { (subscription, error) in
            
            
        }
    }
    
    
    //MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQandAs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("qanda_cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = allQandAs[indexPath.row][Cloud.Attribute.Question] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allQandAs[indexPath.row].wasCreatedByThisUser
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let record = allQandAs[indexPath.row]
            
            database.deleteRecordWithID(record.recordID, completionHandler: { (deletedRecord, error) in
                //handle errorz
            })
            allQandAs.removeAtIndex(indexPath.row)
        }
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show QandA" {
            
            if let ckQandATVC = segue.destinationViewController as? CloudQandATableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    ckQandATVC.ckQandARecord = allQandAs[indexPath.row]
                } else {
                    ckQandATVC.ckQandARecord = CKRecord(recordType: Cloud.Entity.QandA)
                }
            }
            
            
        }
    }
    
}








