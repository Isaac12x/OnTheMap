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
    @IBOutlet weak var textFildForLocation: UITextField!
    @IBOutlet weak var findMyLocation: UIButton!
    @IBOutlet weak var grabMyLocation: UIButton!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findMyLocationOnTheMap(sender: AnyObject){
        
        if  textFildForLocation.text!.isEmpty{
            
        }
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PrePosting") as! PostPinLastStepVC
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func grabMyCurrentPositionIntoAPin(sender: AnyObject){
        /* Track if the user authorized the app to access his location */
        self.appDelegate.locationManager = CLLocationManager()
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PrePosting")
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}