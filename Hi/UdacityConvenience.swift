//
//  UdacityConvenience.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient{
//
//
//    func loginToUdacity(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
//        
//        var jsonBody = [String:AnyObject]()
//        
//        jsonBody[JSONBodyKeys.Udacity] = [
//            JSONBodyKeys.Username: username,
//            JSONBodyKeys.Password: password,
//        ]
//        
//        /* 2. Make the request */
//        postMethodImplementation(Methods.session, jsonBody: jsonBody) { (JSONResult, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandler(success: false, errorString: "Login Failed sessionId.")
//            } else {
//                if let account = JSONResult[JSONResponses.Account] as? [String:AnyObject],
//                    let key = account[JSONResponses.UserKey] as? String {
//                        completionHandler(success: true, errorString: nil)
//                        return
//                }
//            }
//        }
//    }
//    
//    func getUserKey(userKey: String, completionHandler: (student: StudentLocations?, error: NSError?) -> Void) {
//        
//        let url = Constants.secureUdacityURL + Methods.forGetMethod + "/\(userKey)"
//        
//        getMethodImplementation(url){(JSONResult, error) in
//            
//            guard error == nil else {
//                completionHandler(student: nil, error: error)
//                return
//            }
//            
//            // success
//            if let JSONResult = JSONResult,
//                let userDictionary = JSONResult[JSONResponses.User] as? [String:AnyObject],
//                let firstName = userDictionary[JSONResponses.FirstName] as? String,
//                let lastName = userDictionary[JSONResponses.LastName] as? String {
//                    completionHandler(student: StudentLocations(dictionary: JSONResult as! [String : AnyObject]), error: nil)
//                    return
//            }
//            
//        }
//    }
//    
//    func logoutUdacityAccount(){
//    
//    }
    
}