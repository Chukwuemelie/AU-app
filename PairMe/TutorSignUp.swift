//
//  TutorSignUp.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 6/15/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Foundation
import UIKit


class TutorSignUp: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordValTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 0{
            
            
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                
            }
            
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        leadingConstraint.active = true
        dismissViewControllerAnimated(true, completion: nil)
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        trailingConstraint.active = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        topConstraint.active = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.active = true
        
    }
    
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func createAccount(sender: AnyObject){
        let school = schoolTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let username = userNameTextField.text
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        let passwordVal = passwordValTextField.text
        
        
        if username != "" && email != "" && password != "" &&  school != "" && firstName != "" && lastName != "" && password == passwordVal {
            
            //Set up the email and password for the user
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    //There was a problem
                    
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again")
                    
                }else{
                    
                    //Create and Login in the user using authUser
                    
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        
                        let tutor = ["provider": authData.provider! , "email": email!, "username": username!, "firstName": firstName!, "lastname":lastName!, "school":school!]
                        
                        //Seal the deal in DataService.swift
                        
                        DataService.dataService.createNewTutorAccount(authData.uid, tutor: tutor)
                        
                        
                        
                    })
                    
                    //Store the uid for future access - handy!
                    
                    NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                }
                
                //Enter the app
                
                self.performSegueWithIdentifier("NewTutorLoggedIn", sender:nil)
                
            })
            
            
        }else{
            signupErrorAlert("Oops!", message: "Don't forget to fill all the blanks and make sure the passwords match")
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
}
