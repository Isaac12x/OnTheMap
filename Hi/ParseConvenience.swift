//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation


extension ParseClient {

    func grabDataToBeDisplayedInMap(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?){
        self.getParseData() {(result, error) in

        }else{
            completionHandler(success: success, errorString: errorString)
        }
    }
    
    
    func getParseData()(completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void){

        getMethodImplementation(){JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
            completionHandler(result: nil, error: error)
            } else {
        
            if let results = JSONResult[ParseClient.JSONResponses.LocationResponse] as? [[String : AnyObject]] {
            
                let locations = StudentLocations.getLocations(results)
                completionHandler(result: locations, error: nil)
            } else {
            completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
            }
        
            }
        }
    }
    
    func createNewPin(){
        
    }
    
    func updatePin(){
        
    }
    
    func refreshDataFromParse(){
        
    }

}