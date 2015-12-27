//
//  model.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 23/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//


extension UdacityClient {
    
    struct Constants {
        var sessionID: String? = nil
        var userID: String? = nil
  
        // MARK: URLs
        static let secureUdacityURL : String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: Methods
    struct Methods {
        static let session : String = "session"
        static let forGetMethod : String = "users"
    }
    
    struct URLKeys {
        static let UserID = "id"
        static let SessionID = "sessionId"
        static let ObjectId = "objectId"
    }
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static var Username = "username"
        static var Password = "password"
    }
    
    // MARK: JSONResponse Keys
    struct JSONResponses {
        
        // MARK: Account
        static let Account = "account"
        static let UserKey = "key"
        static let Session = "session"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
}
