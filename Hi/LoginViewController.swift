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
    
    var udacityClient = UdacityClient.sharedInstance()
    var parseClient = ParseClient.sharedInstance()
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
    
    session = NSURLSession.sharedSession()
    self.initTap()
    
    userNameTextField.leftView = mail
    settingStyling(userNameTextField)
    userNameTextField.placeholder = "Your email here"
    
    passwordTextField.leftView = password
    settingStyling(passwordTextField)
    passwordTextField.placeholder = "Your password here"
    
    self.renableUI()
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
    self.renableUI()
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

        func textFieldShouldReturn(passwordTextField: UITextField) -> Bool {
            self.startLogin(passwordTextField)
            return true
        }
    
        // MARK: Start login
    
        @IBAction func startLogin(sender: AnyObject) {
            if userNameTextField.text!.isEmpty {
                debugLabel.text = "Username is empty"
            } else if passwordTextField.text!.isEmpty {
                debugLabel.text = "Provide a password"
            } else {
                debugLabel.text = ""
                activityIndicatorView.alpha = 1.0
                activityIndicatorView.startAnimating()
                UdacityClient.sharedInstance().loginToUdacity(userNameTextField.text!, password: passwordTextField.text!){ (success, error) in
                    if success {
                        UdacityClient.sharedInstance().getNameForUdacitystudent(){(success, error) in
                            if success{
                                ParseClient.sharedInstance().callParseAPI(){(success,error) in
                                    if success{
                                        self.completeLogin()
                                    } else{
                                        self.alertOnFailure("Failed", message: "Failed to fetch data")
                                    }
                                }
                            }else{
                                self.alertOnFailure("Failed", message: "Failed on get userKey")
                            }
                        }
                    }else{
                        self.alertOnFailure("Failed", message: "Wrong username/password combination")
                        self.displayError(error)
                        self.renableUI()
                    }
                }
            }
        }
    
        @IBAction func createAccount(sender: AnyObject) {
            let linkToSignUp = "https://www.udacity.com/account/auth#!/signup"
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: linkToSignUp)!)
        }

    
        // MARK: Complete login
        func completeLogin() {
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
        
        //MARK: Display error if login fails
        func displayError(errorString: String?){
            dispatch_async(dispatch_get_main_queue()){
                if let errorString = errorString{
                    self.debugLabel.text = errorString
                }
            }
        }

    /* Helper */
    func alertOnFailure(title: String!, message: String!){
        dispatch_async(dispatch_get_main_queue()){
            self.activityIndicatorView.alpha = 0.0
            self.activityIndicatorView.stopAnimating()
            let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Got it", style: .Default, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        }
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
        userNameTextField.text = ""
        userNameTextField.alpha = 1
        passwordTextField.userInteractionEnabled = true
        passwordTextField.alpha = 1
        passwordTextField.text = ""
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


