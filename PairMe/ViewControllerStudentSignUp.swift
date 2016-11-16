//
//  ViewControllerStudentSignUp.swift
//  PairMe
//
//  Created by Raluchukwu Onwubuya on 3/20/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerStudentSignUp: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (indexPath as NSIndexPath).row == 0{
            
        
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            
            
            }
        
        
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        leadingConstraint.isActive = true
        dismiss(animated: true, completion: nil)
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.isActive = true
        
    }
    
       
    func signupErrorAlert(_ title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    


    @IBAction func createAccount(_ sender: AnyObject){
        let school = schoolTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let username = userNameTextField.text
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        let passwordVal = passwordValTextField.text
        
        
        if username != "" && email != "" && password != "" &&  school != "" && firstName != "" && lastName != "" && password == passwordVal {
            
                //Set up the email and password for the user
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { result, error in
                    
                    if error != nil {
                        
                        //There was a problem
                        
                        self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again")
                        
                    }else{
                        
                        //Create and Login in the user using authUser
                        
                       FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: {
                            (authdata, error) in
                        
                        
                         
                        let user: [String : String] = ["provider": (authdata?.providerID)!, "email": email!, "username": username!, "firstName": firstName!, "lastname":lastName!, "school":school!]
                            
                            //Seal the deal in DataService.swift
                            
                            DataService.dataService.createNewAccount((authdata?.uid)!, user: user)
                            
                         
                            
                        })
                        
                        //Store the uid for future access - handy!
                        
                        UserDefaults.standard.setValue(result?.uid, forKey: "uid")
                    }
                    
                    //Enter the app
                                       
                    self.performSegue(withIdentifier: "NewUserLoggedIn", sender:nil)
                    
                })
                
                
            }else{
                signupErrorAlert("Oops!", message: "Don't forget to fill all the blanks and make sure the passwords match")
                
                
            

                
                }

            
            
            
        
            
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewUserLoggedIn" {
            
            let destinationController = segue.destination as! WelccomeViewController
            
            destinationController.nameText  = firstNameTextField.text
            
            
            print(destinationController.nameText)
            
            
            
        }
    
    
    
    
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

