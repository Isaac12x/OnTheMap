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

    func authenticate(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        self.getSessionId(){ (success, errorString) in
            if success {
                ParseClient.sharedInstance().getParseData()
            }
    }
    
    func getSessionId(completionHandler: (success: Bool, sessionId: String?, errorString: String?) -> Void) {
            
        /* 2. Make the request */
        postMethodImplementation(Methods.session, jsonBody: jsonBody) { (JSONResult, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
            } else {
                if let requestToken = JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandler(success: true, requestToken: requestToken, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
                    completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
                }
            }
    
        }
    }
    
    func logoutUdacityAccount(){
    
    }
    
}