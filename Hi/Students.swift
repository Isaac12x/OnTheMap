//
//  Students.swift
//  OnTheMap
//
//  Created by Isaac Albets Ramonet on 30/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import Foundation

class Students{
    var studentLocations = [StudentLocations]()
    var student: [String: AnyObject] = [String: AnyObject]()


    
    class func sharedInstance() -> Students{
    
        struct Singleton{
            static var sharedInstance = Students()
        }
        
        return Singleton.sharedInstance
    }
}

