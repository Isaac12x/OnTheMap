//
//  PostPinViewController.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class PostPinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
        @IBOutlet weak var firstLabel: UILabel!
        @IBOutlet weak var middleLabel: UILabel!
        @IBOutlet weak var lastLabel: UILabel!
        @IBOutlet weak var textFieldForLocation: UITextField!
        @IBOutlet weak var findMyLocation: UIButton!
        @IBOutlet weak var grabMyLocation: UIButton!
        @IBOutlet weak var mediaURL2Attach: UITextField!
        @IBOutlet weak var mapView : MKMapView!
        @IBOutlet weak var activityView: UIActivityIndicatorView!
        @IBOutlet weak var postMyPinButton: UIButton!
    
    var mapSearchRequest : MKLocalSearchRequest!
    var mapSearch : MKLocalSearch!
    var mapSearchResponse : MKLocalSearchResponse!
    var annotationOnMap : MKAnnotation!
    var pointAnnotation : MKPointAnnotation!
    var pinPointAnnotation : MKPinAnnotationView!
    var myLocationGrabbed : CLLocationManager!

    var student = [StudentLocations]()
    var coordinatesToParse: String!
    var latit: CLLocationDegrees!
    var longit: CLLocationDegrees!
    var fullName: String!
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
    mapView.alpha = 0.0
    activityView.alpha = 0.0
    postMyPinButton.alpha = 0.0
    mediaURL2Attach.hidden = true
    fullName = "\(UdacityClient.sharedInstance().firstName) \(UdacityClient.sharedInstance().lastName)"
}

    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: find location from textfield
    @IBAction func findMyLocationOnTheMap(sender: AnyObject){
        
        if  textFieldForLocation.text!.isEmpty{
            self.alertOnFailure("Error", message: "There isn't anything in the textfield to search for")
        } else{
            activityView.alpha = 1.0
            activityView.startAnimating()
            
            mapSearchRequest = MKLocalSearchRequest()
            mapSearchRequest.naturalLanguageQuery = textFieldForLocation.text
            mapSearch = MKLocalSearch(request: mapSearchRequest!)
            mapSearch.startWithCompletionHandler{(mapSearchResponse, error) -> Void in
                if mapSearchResponse?.boundingRegion.center.latitude == nil {
                    self.alertOnFailure("Not a location", message: "Please, do enter a good location")
                    self.textFieldForLocation.text = ""
                    self.textFieldForLocation.placeholder = "Enter Your Location"
                } else if mapSearchResponse?.boundingRegion.center.longitude == nil {
                    self.alertOnFailure("Not a location", message: "Please, do enter a good location")
                }else{
                    self.pointAnnotation = MKPointAnnotation()
                    self.latit = mapSearchResponse!.boundingRegion.center.latitude
                    self.longit = mapSearchResponse!.boundingRegion.center.longitude
                    self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: mapSearchResponse!.boundingRegion.center.latitude, longitude: mapSearchResponse!.boundingRegion.center.longitude)
                    self.pointAnnotation.title = self.fullName
                    self.pointAnnotation.subtitle = self.mediaURL2Attach.text
                    self.pinPointAnnotation = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                    self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                    self.mapView.addAnnotation(self.pinPointAnnotation.annotation!)
                    self.presentSecondView()
                }
            }
            activityView.stopAnimating()
            activityView.alpha = 0.0
        }
    }
    
    
    // MARK: find my location from gps
    @IBAction func grabMyCurrentPositionIntoAPin(sender: AnyObject){
        self.alertOnFailure("Sorry", message: "We are working on implmenting this feature soon")
//        /* Track if the user authorized the app to access his location */
//        myLocationGrabbed = CLLocationManager()
//
//        myLocationGrabbed.delegate = self
//        myLocationGrabbed.desiredAccuracy = kCLLocationAccuracyBest
//        myLocationGrabbed.requestWhenInUseAuthorization()
//        myLocationGrabbed.startUpdatingLocation()
//        
//        var currentLocation = CLLocation()
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
//                
//            currentLocation = myLocationGrabbed.location!
//                
//        }
//        latit = currentLocation.coordinate.latitude
//        longit = currentLocation.coordinate.longitude
//        self.findmeOnMap(latit, longitude: longit)
//        
//        
//
//        self.presentSecondView()
    }
    

    
    
    
    
    @IBAction func postMyPin(sender: AnyObject) {
        if self.mediaURL2AttachValidation(mediaURL2Attach.text!){
            ParseClient.sharedInstance().postDataToParse(latit.description, longitude: longit.description, mapString: textFieldForLocation.text!, mediaURL: mediaURL2Attach.text!){(success, error) in
                if success{
                    dispatch_async(dispatch_get_main_queue()){
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }else{
                    self.alertOnFailure("Failed to post", message: "We encountered an error and failed to post data to the server")
                }
            }
        } else {
            self.alertOnFailure("Bad URL", message: "The url you typed isn't a good url, please type another one")
        }
    }

    /* Helper: transition within the same view*/
    func presentSecondView(){
        firstLabel.hidden = true
        middleLabel.hidden = true
        lastLabel.hidden = true
        self.configTextField(mediaURL2Attach)
        postMyPinButton.alpha = 1.0
        textFieldForLocation.alpha = 0.0
        findMyLocation.alpha = 0.0
        grabMyLocation.alpha = 0.0
        mapView.alpha = 1.0
        activityView.stopAnimating()
        activityView.alpha = 0.0
    }
    
    // Helper: url validation
    func mediaURL2AttachValidation(url: String) -> Bool{
        let pattern = "^(http?|https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if let _ = url.rangeOfString(pattern, options: .RegularExpressionSearch){
            return true
        }else{
            return false
        }
    }
    
    /* Helper: Configurate the TextField */
    func configTextField(textField: UITextField){
        textField.placeholder = "Type an url to display"
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        textField.hidden = false
    }
    
    /* Helper */
    func alertOnFailure(title: String!, message: String!){
        dispatch_async(dispatch_get_main_queue()){
            let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Got it", style: .Default, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}