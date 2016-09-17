//
//  ViewController.swift
//  Trax
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {

    var gpxURL: URL? {
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
    
    fileprivate func clearWaypoints() {
        
    }
    
    fileprivate func addWaypoints(_ waypoints: [GPX.Waypoint]) {
        mapView?.addAnnotations(waypoints)
        mapView?.showAnnotations(waypoints, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.isDraggable = annotation is EditableWaypoint
        
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
            if waypoint is EditableWaypoint {
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton, let url = (view.annotation as? GPX.Waypoint)?.thumbnailURL {
            
            let imageData = try? Data(contentsOf: url as URL)
            if let image = UIImage(data: imageData!) {
                thumbnailImageButton.setImage(image, for: UIControlState())
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegue(withIdentifier: Constants.ShowImageSegue, sender: view)
        } else if control == view.rightCalloutAccessoryView {
            mapView.deselectAnnotation(view.annotation, animated: true)
            performSegue(withIdentifier: Constants.EditUserWaypoint, sender: view)
        }
    }
    
    @IBAction func updatedUserWaypoint(segue: UIStoryboardSegue) {
        selectWaypoint(wp: (segue.source.contentViewController as? EditWaypointViewController)?.waypointToEdit)
        
    }
    
    private func selectWaypoint(wp: EditableWaypoint?) {
        if wp != nil {
            mapView.selectAnnotation(wp!, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination.contentViewController
        let annotationView = sender as? MKAnnotationView
        let wayPoint = annotationView?.annotation as? GPX.Waypoint
        
        if segue.identifier == Constants.ShowImageSegue {
            
            if let ivc = destination as? ImageViewController {
                ivc.imageURL = wayPoint?.imageURL
                ivc.title = wayPoint?.name
            }
        }
        
        if segue.identifier ==  Constants.EditUserWaypoint {
            if let editableWaypoint = wayPoint as? EditableWaypoint, let ewvc = destination as? EditWaypointViewController {
                
                if let ppc = ewvc.popoverPresentationController {
                    ppc.sourceRect = annotationView!.frame
                    ppc.delegate = self
                }
                
                ewvc.waypointToEdit = editableWaypoint
            }
        }
        
        
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .satellite
            mapView.delegate = self
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        selectWaypoint(wp: (popoverPresentationController.presentedViewController as? EditWaypointViewController)?.waypointToEdit)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return .overFullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        
        if style == .fullScreen || style == .overFullScreen {
            let navCon = UINavigationController(rootViewController: controller.presentedViewController)
            
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            visualEffectView.frame = navCon.view.bounds
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            navCon.view.insertSubview(visualEffectView, at: 0)
            
            //var vc = UIViewController()
            //vc.view.frame = navCon.view.bounds
            //vc.view.insertSubview(visualEffectView, at: 0)
            
            return navCon
            
        } else {
            return nil
        }
        
        print("(((((((((((")
        
        return nil
    }
    
    /*
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        
        if style == .fullScreen {
            let navCon = UINavigationController(rootViewController: controller.presentingViewController)
            return navCon
        } else {
            return nil
        }
        
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpxURL = URL(string: "http://web.stanford.edu/class/cs193p/Vacation.gpx")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWaypoint(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let wayPoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            wayPoint.name = "Dropped"
            mapView.addAnnotation(wayPoint)
        }
        
    }
    
    fileprivate struct Constants {
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
