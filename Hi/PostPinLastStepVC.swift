//
//  PostPinLastStepVC.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostPinLastStepVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
        @IBOutlet weak var mediaURL2Attach: TextFieldClass!
        @IBOutlet weak var mapView : MKMapView!
    
    var appDelegate: AppDelegate!
    var loc: Double!
    var long: Double!
    
override func viewDidLoad() {
    super.viewDidLoad()
    appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    
    mediaURL2Attach.placeholder = "Type a URL to display"
    checkifLocManagerIsEnabled()
}

    
    func checkifLocManagerIsEnabled(){
        var locationManager = appDelegate.locationManager
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            //mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.location
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func postPinToParse(){
        
    }
}