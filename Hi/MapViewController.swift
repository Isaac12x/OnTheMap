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
    
    
    var longPress: UILongPressGestureRecognizer? = nil
    var session: NSURLSession!
    var locations: [StudentLocations] = [StudentLocations]()
    
override func viewDidLoad(){
    super.viewDidLoad()
    
    session = NSURLSession.sharedSession()
    self.initLongPress()
    self.activityView.alpha = 0.0
    
    //MARK: Set up the Map
    
    for dictionary in ParseClient.sharedInstance().map{
        let pinPoint = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: dictionary.latitude, longitude: dictionary.longitude)
        pinPoint.coordinate = location
        pinPoint.title = "\(dictionary.fullName)"
        pinPoint.subtitle = dictionary.mediaURL
        mapView.addAnnotation(pinPoint)
    }

}
    
    
    // MARK: MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView!
        
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
    
    @IBAction func refreshData(sender: AnyObject){
        self.refreshDataFromParse()
    }
    

    
    
    /* Helper: refresh data */
    func refreshDataFromParse(){
        activityView.alpha = 1.0
        activityView.startAnimating()
        
        let parseClient = ParseClient.sharedInstance()
        parseClient.callParseAPI(){ (success, error) in
            if success{
                //Do nothing
            }else{
                let alert = UIAlertController(title: "Failed", message: "Failed to reload data", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
            
        activityView.stopAnimating()
        activityView.alpha = 0.0
    }
    
    


}

extension MapViewController {
    func initLongPress(){
        longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPress?.numberOfTapsRequired = 0
        longPress?.numberOfTouchesRequired = 1
        longPress?.minimumPressDuration = 1.0
        longPress?.allowableMovement = 0
        longPress?.delaysTouchesBegan = false
        longPress?.delegate = self
        self.view.addGestureRecognizer(longPress!)
    }
    
}


extension MapViewController {
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer){
            let logoutModal = UIAlertController(title: "Logout from Udacity", message: nil, preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .Destructive){(action: UIAlertAction!) in
            UdacityClient.sharedInstance().deleteMethodImplementation(){(success, error) in
                if success{
                    let logOutController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(logOutController, animated: false, completion: nil)
                } else{
                    let alert = UIAlertController(title: "Bad luck", message: "You weren't logged out", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Dimiss", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
        logoutModal.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        logoutModal.addAction(cancelAction)
        
        self.presentViewController(logoutModal, animated: true, completion: nil)
        
    }
}

