//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    var session: NSURLSession
    var objectID: String!
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    var map = [StudentLocations]()
    
    func callParseAPI(completionHandler: (success: Bool, errorString: ErrorType?) -> Void){
        
        /* 1. Set the parameters */
        
        //*& 2. Build the URL */
        let urlString = "https://api.parse.com/1/classes/StudentLocation"
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        
        /* Add  App Id and REST API Id */
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("The request returned no data")
                return
            }
            
            var parsedResult: AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch{
                _ = [NSLocalizedDescriptionKey : "Could not parse the JSON: '\(data)'"]
                completionHandler(success: false, errorString: error)
            }
            

            
            if let results = parsedResult["results"] as? [[String : AnyObject]] {
                //Clear existing data from the mapPoints object.
                self.map.removeAll(keepCapacity: true)
                //StudentLocations.getLocations(results)
                //Re-populate the mapPoints object with refreshed data.
                for result in results {
                    self.map.append(StudentLocations(dictionary: result))
                }
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: error)
            }
            
        }
        task.resume()
    }
    
    // MARK: Function for post
    func postDataToParse(latitude: String, longitude: String, mapString: String, mediaURL: String, completionHandler: (success: Bool, errorString: String?) -> Void){
    
        let urlString = "https://api.parse.com/1/classes/StudentLocation"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().userKey)\", \"firstName\": \"\(UdacityClient.sharedInstance().firstName)\", \"lastName\": \"\(UdacityClient.sharedInstance().lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) {data, response, error in
            guard (error == error) else {
                completionHandler(success: false, errorString: nil)
                return
            }
            
            guard let data = data else {
                print("Something went wrong")
                return
            }
            var parsedResult: AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }catch{
                parsedResult = nil
                return
            }
            
            if let object = parsedResult["objectId"] as? String {
                self.objectID = object
                completionHandler(success: true, errorString: nil)
            }else{
                completionHandler(success: false, errorString: "Failed")
            }
            
        }
        task.resume()
    }
    
    
    // MARK: Shared instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
        
    }
    
}

