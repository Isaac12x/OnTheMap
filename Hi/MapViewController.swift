//
//  MainViewController.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 15/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate{
    
    // TODO: Make the long gesture work
    //       Make a hint pop up to explain how to log out!

        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var postPinButton: UIBarButtonItem!
        @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var longPress: UILongPressGestureRecognizer? = nil
    var session: NSURLSession!
    var locations: [StudentLocations] = [StudentLocations]()
    
override func viewDidLoad(){
    super.viewDidLoad()
    
    session = NSURLSession.sharedSession()
    self.initLongPress()
    
    //MARK: Set up the Map
    
    var mapAnnotations = [MKPointAnnotation]()
    
    for dictionary in locations{
        let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
        let long = CLLocationDegrees(dictionary["longitude"] as! Double)
        
        let cordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let first = dictionary["firstName"] as! String
        let last = dictionary["lastName"] as! String
        let postedURL = dictionary["mediaURL"] as! String
        
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = cordinates
        pinPoint.title = "\(first) \(last)"
        pinPoint.subtitle = postedURL
        
        mapAnnotations.append(pinPoint)
    }
    self.mapView.addAnnotations(mapAnnotations)
}
    
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
        ParseClient.sharedInstance().refreshDataFromParse()
    }
    
    
    // MARK: Logout methods
    
    func completeLogout(){
        dispatch_async(dispatch_get_main_queue()){
            let logOutController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController")
            self.presentViewController(logOutController, animated: false, completion: nil)
        }
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
        
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){(action) in
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            logoutModal.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .Destructive){(action: UIAlertAction!) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            logoutModal.addAction(logoutAction)
        
        
        self.presentViewController(logoutModal, animated: true, completion: nil)
        
    }
}

