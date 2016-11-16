//
//  LoginViewController.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/3/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        
        let ref = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
        
       
        
    }
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
        //Checking to see if the user is logged in

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //if we have the uid stored, the user is already logged in - no need to sign up
        
        if UserDefaults.standard.value(forKey: "uid") != nil && FIRAuth.auth()?.currentUser != nil {
        
            self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
        
        
        }
    }
    
    @IBAction func tryLogin(_ sender: AnyObject){
        
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        if email != nil && password != nil {
            
            //Login with the Firebase's authUser method
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!){ (authData, error)in
                
                if error != nil {
                    
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your email address and password")
                    
                }else{
                    //Be sure the correct uid is stored
                    
                    UserDefaults.standard.setValue(authData!.uid, forKey: "uid")
                    
                    //Check whether the user is a tutor or student
                    let userID = UserDefaults.standard.value(forKey: "uid") as! String
                    let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
                    let _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
                    let _USER_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users")
                    
                    var tutorNode = _USER_REF_.child(userID).observe(FIRDataEventType.value, with: { (snapshot) in
                        
                        print(snapshot.value)
                        
                        if "\(snapshot.value)" == "Optional(<null>)"{
                            self.loginErrorAlert("Oops!", message: "uhmm. I think you are a tutor :) Please go to the student login.")
                            
                        }
                            
                            
                            
                        else{
                            
                            
                            
                            //Enter the app
                            self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
                            
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
        if segue.identifier == "CurrentlyLoggedIn" {
            
            //Getting the name of the tutor
            let userID = UserDefaults.standard.value(forKey: "uid") as! String
            let _STUDENT_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users/")
            var nameStudentHandler = _STUDENT_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
                
                var fullname: String = ""
                if let studentInfo = snapshot.value as? NSDictionary {
                    print("\(studentInfo)")
                    var firstname = studentInfo["firstName"] as? String
                    print("The first name:  \(firstname)")
                    var lastname =  studentInfo["lastname"] as? String
                    if let name = studentInfo["firstName"] {
                        
                        fullname = "\(firstname!) " + "\(lastname!)"}
                        print(fullname)
                }
                
                print("This is the \(fullname)")
                let destinationController = segue.destination as! WelccomeViewController
                print(fullname)
                destinationController.nameText = fullname
                print(" This is a nameText : \(destinationController.nameText!))")
            })
            
            
            
            
            
        }
        
        
        

    }
}


