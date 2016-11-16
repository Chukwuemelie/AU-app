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
    
    var fullname: String = ""
    
    @IBAction func exitTutorLogin(){
        self.dismiss(animated: true, completion: {})
    
    
    }
    //Checking to see if the user is logged in
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //if we have the uid stored, the user is already logged in - no need to sign up
        
        if UserDefaults.standard.value(forKey: "uid") != nil && FIRAuth.auth()?.currentUser != nil {
            
            self.performSegue(withIdentifier: "TutorCurrentlyLoggedIn", sender: nil)
            
            
        }
    }
    
    
    @IBAction func tryLogin(_ sender: AnyObject){
        
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        if email != nil && password != nil {
            
            //Login with the Firebase's authUser method
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!){ (authData, error)in
                
                if error != nil  {
                    
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your email address and password")
                    
                }else{
                    
                    
                    UserDefaults.standard.setValue(authData!.uid, forKey: "uid")
                    
                    //Check whether the user is a tutor or student
                    let userID = UserDefaults.standard.value(forKey: "uid") as! String
                    let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
                    _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
                    _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users")
                    
                    _ = _TUTOR_REF.child(userID).observe(FIRDataEventType.value, with: { (snapshot) in
                        
                        print(snapshot.value)
                        
                        if "\(snapshot.value)" == "Optional(<null>)"{
                            self.loginErrorAlert("Oops!", message: "uhmm. I think you are a student :) Please go to the tutor login.")
                            
                        }
                            
                            
                            
                        else{
                            
                            
                            
                            //Enter the app
                            self.performSegue(withIdentifier: "TutorCurrentlyLoggedIn", sender: nil)
                            
                        }
                        
                    })
                    
                }
                
            }

            
        }
            
        else {
            
            //There was a problem with login
            
            self.loginErrorAlert("Oops!", message: "Please enter your email  address and password")
            
        }
        
    }
    
    
    func loginErrorAlert(_ title: String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction (title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TutorCurrentlyLoggedIn" {
            
            
            
            
            //Getting the name of the tutor
            let userID = UserDefaults.standard.value(forKey: "uid") as! String
            let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
            _ = _TUTOR_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
                
                
                if let tutorInfo = snapshot.value as? NSDictionary {
                    print("\(tutorInfo)")
                    let firstname = tutorInfo["firstName"] as? String
                    let lastname =  tutorInfo["lastname"] as? String
                    if (tutorInfo["firstName"]) != nil {
                        
                        self.fullname = "\(firstname!) " + "\(lastname!)"}
                    
                }
                
                print(self.fullname)
                let destinationController = segue.destination as! TutorHome
                print(self.fullname)
                destinationController.name = self.fullname
            })
            
            

          
            
        }
        
        
    }
}


