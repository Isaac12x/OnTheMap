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
    var key: String!
    var firstName: String!
    var lastName: String!
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
        
    }
    
    
    func callParseAPI(completionHandler: (success: Bool, errorString: ErrorType?) -> Void){
        
        /* 1. Set the parameters */
        let params = [
            "limit": 400,
            "order": "-UpdatedAt"
        ]
        //*& 2. Build the URL */
        let urlString = URL.secureParseURL + ParseClient.sharedInstance().escapedParams(params)
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        
        /* Add  App Id and REST API Id */
        request.addValue("\(HeaderValues.ApiKey)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(HeaderValues.APiKeyParse)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let _ = response as? NSHTTPURLResponse {
                    completionHandler(success: false, errorString: error)
                } else if let _ = response {
                    completionHandler(success: false, errorString: error)
                } else {
                    completionHandler(success: false, errorString: error)
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


            if let results = parsedResult["results"] as? [[String: AnyObject]] {
                //Students.sharedInstance().studentLocations.removeAll(keepCapacity: true)
                

                for result in results {
                    Students.sharedInstance().studentLocations.append(StudentLocations(dictionary: result))
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
    
        let urlString = URL.secureParseURL
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("\(HeaderValues.ApiKey)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(HeaderValues.APiKeyParse)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        self.unwrap()

        request.HTTPBody = "{\"uniqueKey\": \"\(self.key)\", \"firstName\": \"\(self.firstName)\", \"lastName\": \"\(self.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
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
            print(parsedResult)
            
            if let object = parsedResult["objectId"] as? [String:AnyObject] {
                Students.sharedInstance().studentLocations.append(StudentLocations(dictionary: object))

                completionHandler(success: true, errorString: nil)
            }else{
                completionHandler(success: false, errorString: error?.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    /* Helper: Input a dictionary and return a url */
    func escapedParams(parameters: [String: AnyObject]) -> String{
        var urlVars = [String]()
        for (mogly, balu) in parameters{
            let stringBalu = "\(balu)"
            let escapedBalu = stringBalu.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [mogly + "=" + "\(escapedBalu!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    /* Helper: unwraper of dictionary */
    func unwrap(){
        if let hat = Students.sharedInstance().student["userKey"]{
            if let mac = Students.sharedInstance().student["firstName"]{
                if let dump = Students.sharedInstance().student["lastName"]{
                    self.key = "\(hat)"
                    self.firstName = "\(mac)"
                    self.lastName = "\(dump)"
                }
            }
        }
    }
    
    // MARK: Shared instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
        
    }
    
}

