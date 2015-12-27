//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 26/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation


extension ParseClient {

//    func grabDataToBeDisplayedInMap(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?){
//        self.getParseData() {(result, error) in
//
//        }else{
//            completionHandler(success: success, errorString: errorString)
//        }
//    }
    
    
//    func getParseData()(completionHandler: (result: [StudentLocations]?, error: NSError?) -> Void){
//
//        getMethodImplementation(){JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//            completionHandler(result: nil, error: error)
//            } else {
//        
//            if let results = JSONResult[ParseClient.JSONResponses.LocationResponse] as? [[String : AnyObject]] {
//                let locations = StudentLocations.getLocations(results)
//                completionHandler(result: locations, error: nil)
//            } else {
//            completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
//            }
//        
//            }
//        }
//    }
    
//    func createNewPin(locations: StudentLocations ,completionHandler: (result: Int?, error: NSError?) -> Void){
//        
//            let jsonBody : [String:AnyObject] = [
//               // ParseClient.JSONBodyKeys.UniqueKey: StudentLocations.uniqueKey as String,
//                ParseClient.JSONBodyKeys.FirstName: StudentLocations.firstName,
//                ParseClient.JSONBodyKeys.LastName: StudentLocations.lastName,
//                ParseClient.JSONBodyKeys.MapString: StudentLocations.mapString,
//                ParseClient.JSONBodyKeys.MediaURL: StudentLocations.mediaURL,
//                ParseClient.JSONBodyKeys.Latitude: StudentLocations.latitude,
//                ParseClient.JSONBodyKeys.Longitude: StudentLocations.longitude,
//            ]
//
//            /* 2. Make the request */
//            postMethodImplementation(jsonBody){ JSONResult, error in
//                
//                /* 3. Send the desired value(s) to completion handler */
//                if let error = error {
//                    completionHandler(result: nil, error: error)
//                } else {
//                    if let results = JSONResult[ParseClient.JSONResponses.StatusCode] as? Int {
//                        completionHandler(result: results, error: nil)
//                    } else {
//                        completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
//                    }
//                }
//            }
//        }



    func updatePin(){
        
    }
    
    func refreshDataFromParse(){
        
    }

}