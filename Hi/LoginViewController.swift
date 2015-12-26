//
//  ViewController.swift
//  Hi
//
//  Created by Isaac Albets Ramonet on 11/12/15.
//  Copyright © 2015 Isaac Albets Ramonet. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {


        @IBOutlet weak var udacityLogin: UIImageView!
        @IBOutlet weak var loginText: UILabel!
        @IBOutlet weak var userNameTextField: TextFieldClass!
        @IBOutlet weak var passwordTextField: TextFieldClass!
        @IBOutlet weak var debugLabel: UILabel!
        @IBOutlet weak var loginButon: UIButton!
        @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    // MARK: Load textfield image

    var mail : UIImageView{
        let image = UIImageView(image: UIImage(named:"email.png"))
        image.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return image
    }
    
    var password : UIImageView {
        let image = UIImageView(image: UIImage(named:"password.png"))
        image.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        return image
    }
    

//MARK: UIViewController lifecycle

override func viewDidLoad() {
    super.viewDidLoad()
    
    appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    session = NSURLSession.sharedSession()
    self.initTap()
    
    userNameTextField.leftView = mail
    settingStyling(userNameTextField)
    userNameTextField.placeholder = "Your email here"
    
    passwordTextField.leftView = password
    settingStyling(passwordTextField)
    passwordTextField.placeholder = "Your password here"
    
}

override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.addKeyboardDismissRecognizer()
    
}

override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.debugLabel.text = ""
    self.activityIndicatorView.stopAnimating()
    self.activityIndicatorView.hidden = true
}

override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.removeKeyboardDismissRecognizer()
}


    
        // MARK: Textfields helpers
    
        func settingStyling(textfield: UITextField!) {
            textfield.leftViewMode = UITextFieldViewMode.Always
            textfield.font = UIFont(name: "Roboto-Thin", size: 12)
            textfield.textColor = UIColor.blackColor()
            textfield.frame = CGRectMake(2, 25, 300, 50)
            textfield.alpha = 0.9
            textfield.textAlignment = .Center
            textfield.delegate = self
        }
    
    
        func textFieldDidBeginEditing(textField: UITextField) {
            textField.placeholder = ""
        }

    
    
        // MARK: Start login
    
        @IBAction func startLogin(sender: AnyObject) {
            if userNameTextField.text!.isEmpty {
                debugLabel.text = "Username is empty"
            } else if passwordTextField.text!.isEmpty {
                debugLabel.text = "Provide a password"
            } else {
                debugLabel.text = ""
                self.setUIDisabled()
                self.getAccessToUdacity()
                self.renableUI()
                ParseClient.sharedInstance().getParseData(self){(success, errorString) in
                    if success{
                        self.completeLogin()
                    } else{
                        self.debugLabel.text = "Failed to download data"
                    }
                }
            }
        }

        @IBAction func createAccount(sender: AnyObject) {
            let linkToSignUp = "https://www.udacity.com/account/auth#!/signup"
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: linkToSignUp)!)
        }
    
// MARK: Authentication with fb
//        @IBAction func loginButtonTouch(sender: AnyObject) {
//            FacebookClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
//                    if success {
//                            self.completeLogin()
//                    } else {
//                            self.displayError(errorString)
//                    }
//             }
//        }
    
    
        // MARK: Complete login
        
        func completeLogin() {
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
        
        //MARK: Request Udacity Access
    
    func getAccessToUdacity(){
            
            /* 1. Set the parameters  &  2. Build the URL */
            let urlString =  "https://www.udacity.com/api/session"
            let url = NSURL(string: urlString)!
            
            /* 3. Configure the request */
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.userNameTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            
            /* 4. Make the request */
            let task = session.dataTaskWithRequest(request) { data, response, error in
                
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    
                    let alert = UIAlertController(title: "Udacity login failed", message: "An error ocurred while connecting to Udacity, try again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action) in
                        self.dismissViewControllerAnimated(false, completion: nil)
                        self.renableUI()
                    
                    }))
                    
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.presentViewController(alert, animated: false, completion:nil)
                        }
                        
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.presentViewController(alert, animated: false, completion:nil)
                        }
                        
                    } else {
                        print("Your request returned an invalid response!")
                        dispatch_async(dispatch_get_main_queue()){
                            self.presentViewController(alert, animated: false, completion:nil)
                        }
                    }
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* 5. Parse the data */

                var parsedResult: NSDictionary!
                do{
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
                } catch{
                    print("Failure on parsing!")
                }
                
                /* 6. Use the data! */
                for (key, value) in parsedResult{
                    if key as! String == "account"{
                        let userID = value.valueForKey("key")
                        self.appDelegate.userID = userID as? String
                    }else if key as! String == "session"{
                        let sessionId = value.valueForKey("id")
                        self.appDelegate.sessionID = sessionId as? String
                    }else{
                        dispatch_async(dispatch_get_main_queue()){
                            self.debugLabel.text = "Key wasn't found in Udacity response"
                        }
                    }
                }
            }
            /* 7. Start the request */
            task.resume()
        }
    
    func callParseAPI(){
    
        /* 1. Set the parameters */
        
        //*& 2. Build the URL */
        let urlString = "https://api.parse.com/1/classes/StudentLocation"
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        
        /* Add  App Id and REST API Id */
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("The request returned no data")
                return
            }
            
            let parsedResult: AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }catch{
                parsedResult = nil
                print("We failed at parsing the JSON: \(data)")
                return
            }
            
            guard let results = parsedResult["results"] as? [[String : AnyObject]] else {
                print("Cannot find key 'results' in \(parsedResult)")
                self.appDelegate.dataFromParse = nil
                self.appDelegate.dataFailed = error
                return
            }
            
            var arrayToAddCorrectedLocs: [AnyObject] = [AnyObject]()
            var newt: Set<NSObject> = Set<NSObject>()
            
            for dictionary in results{
                for (key, value) in dictionary{
                    if key == "mapString"{
                        if value as! String != "Udacity"{
                            newt.insert(dictionary)
                        }
                    }
                }
            }
            
            for dictionary in newt{
                arrayToAddCorrectedLocs.append(dictionary)
            }
            
            // Remove an array of objects
            self.appDelegate.dataFromParse = arrayToAddCorrectedLocs
            self.renableUI()
        }
        task.resume()
    }
    
    
    // MARK: Disable UI
    
    func setUIDisabled(){
        userNameTextField.alpha  = 0.2
        userNameTextField.userInteractionEnabled = false
        userNameTextField.placeholder = "Your email here"
        
        passwordTextField.alpha = 0.2
        passwordTextField.userInteractionEnabled = false
        passwordTextField.placeholder = "Your password here"
        
        activityIndicatorView.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    func renableUI(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidden = true
        
        userNameTextField.userInteractionEnabled = true
        userNameTextField.alpha = 1
        passwordTextField.userInteractionEnabled = true
        passwordTextField.alpha = 1
    }

}

// MARK: Tap function

extension LoginViewController {
    func initTap(){
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
}

extension LoginViewController {
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}


