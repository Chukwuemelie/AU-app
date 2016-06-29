//
//  LoginViewController.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/3/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Firebase
import UIKit

class TutorLogIn : UIViewController {
    
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBAction func exitTutorLogin(){
        self.dismissViewControllerAnimated(true, completion: {})
    
    
    }
    //Checking to see if the user is logged in
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //if we have the uid stored, the user is already logged in - no need to sign up
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_TUTOR_REF.authData != nil {
            
            self.performSegueWithIdentifier("TutorCurrentlyLoggedIn", sender: nil)
            
            
        }
    }
    
    
    @IBAction func tryLogin(sender: AnyObject){
        
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        if email != nil && password != nil {
            
            //Login with the Firebase's authUser method
            
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your email address and password")
                    
                }else{
                    //Be sure the correct uid is stored
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    //Enter the app
                    
                    self.performSegueWithIdentifier("TutorCurrentlyLoggedIn", sender: nil)
                    
                    
                }
                
            })
            
        }
            
        else {
            
            //There was a problem with login
            
            self.loginErrorAlert("Oops!", message: "Please enter your email  address and password")
            
        }
        
    }
    
    
    func loginErrorAlert(title: String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction (title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "TutorCurrentlyLoggedIn" {
            
            let destinationController = segue.destinationViewController as! TutorWelcome
            
            
            
            
            
        }
        
        
    }
}


