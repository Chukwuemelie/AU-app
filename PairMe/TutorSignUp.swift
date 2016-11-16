//
//  TutorSignUp.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 6/15/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TutorSignUp: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordValTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    
    var fullname: String = ""
    
    
    
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
        var firstName = firstNameTextField.text
        var lastName = lastNameTextField.text
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
                        authData, err in
                        
                        firstName!.replaceSubrange(firstName!.startIndex...firstName!.startIndex, with: String(firstName![firstName!.startIndex]).capitalized)
                        
                        lastName!.replaceSubrange(lastName!.startIndex...lastName!.startIndex, with: String(lastName![lastName!.startIndex]).capitalized)
                        
                        let tutor = ["provider": (authData!.providerID) , "email": email!, "username": username!, "firstName": firstName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), "lastname":lastName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), "school":school!]
                        
                        //Seal the deal in DataService.swift
                        
                        DataService.dataService.createNewTutorAccount((authData?.uid)!, tutor: tutor)
                        
                        
                        
                    })
                    
                    //Store the uid for future access - handy!
                    
                    UserDefaults.standard.setValue(result?.uid, forKey: "uid")
                }
                
                //Enter the app
                
                self.performSegue(withIdentifier: "NewTutorLoggedIn", sender:nil)
                
            })
            
            
        }else{
            signupErrorAlert("Oops!", message: "Don't forget to fill all the blanks and make sure the passwords match")
            
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewTutorLoggedIn" {
            
            
            
            
            //Getting the name of the tutor
            let userID = UserDefaults.standard.value(forKey: "uid") as! String
            let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
            var nameStudentHandler = _TUTOR_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
                
                
                if let tutorInfo = snapshot.value as? NSDictionary {
                    print("\(tutorInfo)")
                    var firstname = tutorInfo["firstName"] as? String
                    var lastname =  tutorInfo["lastname"] as? String
                    if let name = tutorInfo["firstname"] {
                        
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

