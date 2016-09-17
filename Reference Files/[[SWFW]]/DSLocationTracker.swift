//
//  DSRandomizer.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit
import CoreLocation

@objc class DSLocationTracker : DSObject//, CLLocationManagerDelegate
{
    var mLoc:CLLocationManager! = nil
    
    func startTracking()
    {
        if(mLoc == nil)
        {
            //self.mLoc = CLLocationManager()
            //mLoc.delegate = self
            
            //mLoc.desiredAccuracy = kCLLocationAccuracyBest
            
            //mLoc.requestWhenInUseAuthorization()
            
            //mLoc.startUpdatingLocation()
            
        }
        
    }
    
    
    func stopTracking()
    {
        
    }
    
    
    
    
//    @available(iOS 6.0, *)
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        
//    }
//    /*
//    *  locationManager:didUpdateHeading:
//    *
//    *  Discussion:
//    *    Invoked when a new heading is available.
//    */
//    @available(iOS 3.0, *)
//    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
//    {
//        
//    }
//    /*
//    *  locationManagerShouldDisplayHeadingCalibration:
//    *
//    *  Discussion:
//    *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
//    *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
//    */
//    //@available(iOS 3.0, *)
//    //func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool
//    //{
//        
//    //}
//    /*
//    *  locationManager:didDetermineState:forRegion:
//    *
//    *  Discussion:
//    *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
//    *    a call to requestStateForRegion:.
//    */
//    @available(iOS 7.0, *)
//    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
//    {
//        
//    }
//    /*
//    *  locationManager:didRangeBeacons:inRegion:
//    *
//    *  Discussion:
//    *    Invoked when a new set of beacons are available in the specified region.
//    *    beacons is an array of CLBeacon objects.
//    *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
//    *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
//    *    by the device.
//    */
//    @available(iOS 7.0, *)
//    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
//    {
//        
//    }
//    /*
//    *  locationManager:rangingBeaconsDidFailForRegion:withError:
//    *
//    *  Discussion:
//    *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
//    */
//    @available(iOS 7.0, *)
//    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError)
//    {
//        
//    }
//    /*
//    *  locationManager:didEnterRegion:
//    *
//    *  Discussion:
//    *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
//    *    CLLocationManager instance with a non-nil delegate that implements this method.
//    */
//    @available(iOS 4.0, *)
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)
//    {
//        
//    }
//    /*
//    *  locationManager:didExitRegion:
//    *
//    *  Discussion:
//    *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
//    *    CLLocationManager instance with a non-nil delegate that implements this method.
//    */
//    @available(iOS 4.0, *)
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion)
//    {
//        
//    }
//    /*
//    *  locationManager:didFailWithError:
//    *
//    *  Discussion:
//    *    Invoked when an error has occurred. Error types are defined in "CLError.h".
//    */
//    @available(iOS 2.0, *)
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
//    {
//        
//    }
//    /*
//    *  locationManager:monitoringDidFailForRegion:withError:
//    *
//    *  Discussion:
//    *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
//    */
//    @available(iOS 4.0, *)
//    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError)
//    {
//        
//    }
//    /*
//    *  locationManager:didChangeAuthorizationStatus:
//    *
//    *  Discussion:
//    *    Invoked when the authorization status changes for this application.
//    */
//    @available(iOS 4.2, *)
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
//    {
//        
//    }
//    /*
//    *  locationManager:didStartMonitoringForRegion:
//    *
//    *  Discussion:
//    *    Invoked when a monitoring for a region started successfully.
//    */
//    @available(iOS 5.0, *)
//    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion)
//    {
//        
//    }
//    /*
//    *  Discussion:
//    *    Invoked when location updates are automatically paused.
//    */
//    @available(iOS 6.0, *)
//    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager)
//    {
//        
//    }
//    /*
//    *  Discussion:
//    *    Invoked when location updates are automatically resumed.
//    *
//    *    In the event that your application is terminated while suspended, you will
//    *	  not receive this notification.
//    */
//    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager)
//    {
//        
//    }
//    /*
//    *  locationManager:didFinishDeferredUpdatesWithError:
//    *
//    *  Discussion:
//    *    Invoked when deferred updates will no longer be delivered. Stopping
//    *    location, disallowing deferred updates, and meeting a specified criterion
//    *    are all possible reasons for finishing deferred updates.
//    *
//    *    An error will be returned if deferred updates end before the specified
//    *    criteria are met (see CLError), otherwise error will be nil.
//    */
//    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?)
//    {
//        
//    }
//    /*
//    *  locationManager:didVisit:
//    *
//    *  Discussion:
//    *    Invoked when the CLLocationManager determines that the device has visited
//    *    a location, if visit monitoring is currently started (possibly from a
//    *    prior launch).
//    */
//    
//    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit)
//    {
//        
//    }
    
    
    class var shared: DSLocationTracker
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSLocationTracker? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSLocationTracker()}
        return Static.cInstance!
    }
}

let gLocationTracker:DSLocationTracker = DSLocationTracker.shared;
