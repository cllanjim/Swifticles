import UIKit
import CoreLocation

protocol LocationGrabberDelegate
{
    func locationDidUpdate(loc: LocationGrabber)
    func locationDidFail(loc: LocationGrabber)
    func locationDidSucceed(loc: LocationGrabber)
}

class LocationGrabber: NSObject, CLLocationManagerDelegate
{
    static let sharedInstance = LocationGrabber() // Singleton
    
    var lat:CGFloat = 45.523062
    var lon:CGFloat = -122.676482
    
    var delegate:LocationGrabberDelegate! = nil
    
    private let locationManager:CLLocationManager = CLLocationManager()
    
    private var didUpdateLocation:Bool = false;
    
    private override init()
    {
        super.init()
        
        locationManager.delegate = self
        
        //Need always to do the background update properly.
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.requestLocation()
        
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func active() -> Bool
    {
        return (didUpdateLocation == true);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If location data can be determined
        
        if let location = locations.last! as CLLocation! {
            
            let first:Bool = (!didUpdateLocation)
            
            didUpdateLocation = true
            
            lat = CGFloat(location.coordinate.latitude)
            lon = CGFloat(location.coordinate.longitude)
            
            if((delegate != nil) && (first == true)){
                delegate.locationDidSucceed(self)
            }
            
            if(delegate != nil){
                delegate.locationDidUpdate(self)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Location Manager: \(error)")
        if(delegate != nil)
        {
            delegate.locationDidFail(self)
        }
    }
}

let gLoc:LocationGrabber = LocationGrabber.sharedInstance;