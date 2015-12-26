//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

extension ParseClient{


    struct Constants {
        
        // MARK: URL
        static let secureParseURL : String = "https://api.parse.com/1/classes/StudentLocation"

        
        // MARK: API Key
        static let ApiKey : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APiKeyParse : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    // MARK: Methods
    struct Methods{
        static let ObjectID = "objectId"
    }
    
    
    // MARK: JSON Body

    struct JSONBodyKeys {
        static let UniqueKey = "key"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let MapString = "mapString"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Responses
    struct JSONResponses {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Repsonse
        static let LocationResponse = "locationsResponse"
        
        // MARK: location
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
}