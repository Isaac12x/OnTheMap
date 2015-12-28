//
//  ParseClient.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{

    var session: NSURLSession
    
    // Authentication
    var userKey = ""
    var firstName = ""
    var lastName = ""
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: GET (to get the userKey)
    func getNameForUdacitystudent(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(self.userKey)")!)
        
        //Initialize the task for getting the data.
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                completionHandler(success: false, errorString: error!.description)
            }
            guard let data = data else{
                print("The request returned no data")
                return
            }
            
            var parsedResult: AnyObject!
            do{
                parsedResult =  try! NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length - 5)), options: .AllowFragments) as! [String:AnyObject]
            }catch{
                _ = [NSLocalizedDescriptionKey : "Could not parse the JSON: '\(data)'"]
                completionHandler(success: false, errorString: nil)
            }
            
            
            if let firstName = parsedResult["user"]!!.valueForKey("first_name") as? String {
                self.firstName = firstName
            } else {
                completionHandler(success: false, errorString: "Failed")
                return
            }
            
            if let lastName = parsedResult["user"]!!.valueForKey("last_name") as? String {
                self.lastName = lastName
            } else {
                completionHandler(success: false, errorString: "Failed")
                return
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }

    // MARK: POST (to login)
    func loginToUdacity(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                completionHandler(success: false, errorString: error!.description)
            }
            
            guard let data = data else{
                print("The request returned no data")
                return
            }

            var parsedResult: AnyObject!
            do{
                parsedResult =  try! NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length - 5)), options: .AllowFragments) as! [String:AnyObject]
            }catch{
                _ = [NSLocalizedDescriptionKey : "Could not parse the JSON: '\(data)'"]
                completionHandler(success: false, errorString: nil)
            }
            
            
            if let userKey = parsedResult["account"]??.valueForKey("key") as? String {
                self.userKey = userKey
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "Incorrect username or password.")
            }
        }
        task.resume()
    }
    
    // MARK: DELETE
    
    func deleteMethodImplementation(completionHandler: (success: Bool, errorString: String?) -> Void){
        
        let urlString = Constants.secureUdacityURL + Methods.session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                print("There was an error")
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(success: false, errorString: error?.localizedDescription)
                }else if let response = response {
                    completionHandler(success: false, errorString: error?.localizedDescription)
                } else {
                    completionHandler(success: false, errorString: error?.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                print("We couldn't find any data")
                return
            }
            
            var parsedResult: AnyObject!
            do{
                parsedResult =  try! NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length - 5)), options: .AllowFragments) as! [String:AnyObject]
            }catch{
                _ = [NSLocalizedDescriptionKey : "Could not parse the JSON: '\(data)'"]
                completionHandler(success: false, errorString: nil)
            }
            
            // Do nothing
        }
        task.resume()
    }

    


    
    // MARK: Shared instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance

    }
    

}