//
//  LoginViewController.swift
//  Jokes
//
//  Created by Abdelrahman Mohamed on 5/2/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            self.performSegueWithIdentifier(CurrentlyLoggedIn, sender: nil)
        }
    }
    
    @IBAction func tryLogin(sender: AnyObject) {
        
        let email = emailField.text
        let pwd = passwordField.text
        
        if email != "" && pwd != "" {

            DataService.dataService.BASE_REF.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    
                    print(error)
                    self.showErrorAlert("Oops", message: "Check your username and password.")
                                        
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(CurrentlyLoggedIn, sender: nil)
                }
            })
    
        } else {
            self.showErrorAlert("Oops! Email and Password Required", message: "You must enter an email and a password")
        }
    }
    
    @IBAction func loginFB(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with Facebook. \(accessToken)")
                
                DataService.dataService.BASE_REF.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        print("Login Failed. \(error)")
                    } else {
                        print("Logged In! \(authData)")
                        
                        let user = ["provider": authData.provider!]
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(CurrentlyLoggedIn, sender: nil)
                    }
                })
            }
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
