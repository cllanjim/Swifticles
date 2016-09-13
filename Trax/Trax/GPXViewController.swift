//
//  ViewController.swift
//  Trax
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {

    var gpxURL: NSURL? {
        didSet {
            if let url = gpxURL {
                clearWaypoints()
                GPX.parse(url, completionHandler: {gpx in
                    
                    if gpx != nil {
                        self.addWaypoints(gpx!.waypoints)
                    }
                    
                })
            }
        }
    }
    
    private func clearWaypoints() {
        
    }
    
    private func addWaypoints(waypoints: [GPX.Waypoint]) {
        mapView?.addAnnotations(waypoints)
        mapView?.showAnnotations(waypoints, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton, let url = (view.annotation as? GPX.Waypoint)?.thumbnailURL {
            
            let imageData = NSData(contentsOfURL: url)
            if let image = UIImage(data: imageData!) {
                thumbnailImageButton.setImage(image, forState: .Normal)
            }
            
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        let annotationView = sender as? MKAnnotationView
        let wayPoint = annotationView?.annotation as? GPX.Waypoint
        
        if segue.identifier == Constants.ShowImageSegue {
            
            if let ivc = destination as? ImageViewController {
                ivc.imageURL = wayPoint?.imageURL
                ivc.title = wayPoint?.name
            }
        }
        
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpxURL = NSURL(string: "http://web.stanford.edu/class/cs193p/Vacation.gpx")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWaypoint(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .Began {
            
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            
            let wayPoint = GPX.Waypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            wayPoint.name = "Dropped"
            
            mapView.addAnnotation(wayPoint)
            
            
        }
        
    }
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59) // sad face
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditUserWaypoint = "Edit Waypoint"
    }

}

extension UIViewController {
    
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}
