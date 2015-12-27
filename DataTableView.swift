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

    var appDelegate: AppDelegate!
    // var locations: [StudentLocations] = [StudentLocations]()
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
    
    @IBAction func refreshData(sender: AnyObject){
        self.refreshDataFromParse()
    }
    
    
    /* Helper: refresh data */
    func refreshDataFromParse(){
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


