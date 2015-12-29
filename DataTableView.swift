//
//  DataTableView.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 17/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit
import Foundation

class DataTableView: UITableViewController{
    
        @IBOutlet weak var tableDisplay: UITableView!
        @IBOutlet weak var cancelButton: UIBarButtonItem!
        @IBOutlet weak var postPinToMapButton: UIBarButtonItem!
        @IBOutlet weak var logOutButton: UIBarButtonItem!
        @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    var locations = ParseClient.sharedInstance().map
    
override func viewDidLoad() {
    super.viewDidLoad()
}

override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableDisplay!.reloadData()
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
                self.presentViewController(logOutController, animated: true, completion: nil)
            }else{
                self.alertOnFailure("Failure", message: "Unable to complete logout")
            }
        }
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
    
    // Table cell's count
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return locations.count
    }
    
    // Populate tableView cells with data form the data storage
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let location = locations[indexPath.row]
        
        let cellIdentifier = "PeopleInMap"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! TableViewCell
        
        cell.locationLabel!.text = "\(location.fullName)"
        
        return cell
    }
    
    // Instructions to segue when pressing down into any cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let location = locations[indexPath.row]

        if location.mediaURL.isEmpty == false{
            app.openURL(NSURL(string: location.mediaURL)!)
        }else{
            let alert = UIAlertController(title: "Bad Url", message: "We are sorry but we couldn't follow the link", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler:{(action) in
                self.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(alert, animated: false, completion: nil)
        }
    }


}


