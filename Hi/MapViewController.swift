//
//  MainViewController.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 15/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var postPinButton: UIBarButtonItem!
        @IBOutlet weak var refreshButton: UIBarButtonItem!
        @IBOutlet weak var activityView: UIActivityIndicatorView!
        @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var session: NSURLSession!
    
override func viewDidLoad(){
    super.viewDidLoad()
    
    session = NSURLSession.sharedSession()
    mapView.delegate = self
    self.activityView.alpha = 0.0
    
    //MARK: Set up the Map
    self.createPinsToMap()
    
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.sharedApplication()
            if let followLink = view.annotation?.subtitle! {
                app.openURL(NSURL(string: followLink)!)
            }
        }
    }
    
    // MARK: Post a new Pin
    @IBAction func postNewPin(sender: AnyObject){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavCont")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: RefreshData
    @IBAction func refreshData(sender: AnyObject){
        self.refreshDataFromParse()
    }
    
    // MARK: Log Out from Udacity, return to loginViewController
    @IBAction func logOutFromUdacity(sender: AnyObject){
        UdacityClient.sharedInstance().deleteMethodImplementation(){(success, error) in
            if success{
                let logOutController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                self.presentViewController(logOutController, animated: false, completion: nil)
            }else{
                self.alertOnFailure("Failure", message: "Unable to complete logout")
            }
        }
    }

    // MARK: Add pins to the map
    func createPinsToMap(){
    for dictionary in Students.sharedInstance().studentLocations{
        let pinPoint = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: dictionary.latitude, longitude: dictionary.longitude)
        pinPoint.coordinate = location
        pinPoint.title = "\(dictionary.fullName)"
        pinPoint.subtitle = dictionary.mediaURL
        mapView.addAnnotation(pinPoint)
        }
    }
    
    
    /* Helper: refresh data */
    func refreshDataFromParse(){
        activityView.alpha = 1.0
        activityView.startAnimating()
    
        ParseClient.sharedInstance().callParseAPI(){ (success, error) in
            if success{
                self.createPinsToMap()
            }else{
                let alert = UIAlertController(title: "Failed", message: "Failed to reload data", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
            
        activityView.stopAnimating()
        activityView.alpha = 0.0
    }
    
    /* Helper: alert display function */
    func alertOnFailure(title: String!, message: String!){
        dispatch_async(dispatch_get_main_queue()){
            self.activityView.alpha = 0.0
            self.activityView.stopAnimating()
            let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Got it", style: .Default, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }


}





