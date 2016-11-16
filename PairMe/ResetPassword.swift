//
//  ResetPassword.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 8/17/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import Firebase

class ResetPassword: UIViewController {
    
    
    @IBOutlet var textfield: UITextField!
    @IBAction func resetPassword(){
        
        if self.textfield.text == "" {
            
            
            self.loginErrorAlert("No email entered", message: "Please enter an email address")
            
        }

        FIRAuth.auth()?.sendPasswordReset(withEmail: textfield.text!, completion: { (error) in
            
            
            if error != nil {
                
                self.loginErrorAlert("Email not found", message: "Please enter another email address")
            
            }
            else {
            
                self.loginErrorAlert("Reset Email Sent", message: "Please check your email address and change your password")
            
            
            }
            
        })
    
        
    }
    override func viewDidLoad() {
        
        
        
    }
    
    func loginErrorAlert(_ title: String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction (title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    


}
