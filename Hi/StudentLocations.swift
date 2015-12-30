//
//  Location.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 23/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//


class StudentLocations {
    
    

    // MARK: Initializers
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var mediaURL: String
    var fullName: String!
    var longitude: Double!
    var latitude: Double!
    var mapString: String!
    var objectId: String!
    
    

    
    /* Construct a UdacityPin from a dictionary */
    init(dictionary: [String : AnyObject]) {

        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        fullName = "\(firstName) \(lastName)"
        
    }
    


}
