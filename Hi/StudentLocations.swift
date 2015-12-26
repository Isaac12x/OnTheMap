//
//  Location.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 23/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

struct StudentLocations {
    
    // MARK: Properties
    
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var firstName = ""
    var lastName = ""
    var mediaURL = ""
    var objectID = ""
    var uniqueKey = ""
    
    // MARK: Initializers
    
    /* Construct a UdacityPin from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary[ParseClient.JSONResponses.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponses.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponses.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponses.Longitude] as! Double
        mapString = dictionary[ParseClient.JSONResponses.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponses.MediaURL] as! String
        uniqueKey = dictionary[ParseClient.JSONResponses.UniqueKey] as! String
        objectID = dictionary[ParseClient.JSONResponses.ObjectID] as! String
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of location objects */
    static func getLocations(results: [[String : AnyObject]]) -> [StudentLocations] {
        var location = [StudentLocations]()
        
        for result in results {
            location.append(StudentLocations(dictionary: result))
        }
        
        return location
    }

}
