//
//  TutorHomePage.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 8/16/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class TutorHome: ViewController {


    
    @IBOutlet weak var tutorName: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var name: String?
    var scheduleListIni = [(student:String, time: String)]()
    let _BASE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
    let userID = UserDefaults.standard.value(forKey: "uid") as! String
    let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
    let _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        var info : AnyObject?
        var fullname : String = ""
        var nameStudentHandler = _TUTOR_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
            
            
            var appointmentArrray = [(student:String, time: String)]()
            var tutorInfo = snapshot.value! as! NSDictionary
            
            var firstname = tutorInfo["firstName"] as? String
            var lastname =  tutorInfo["lastname"] as? String
            info = snapshot.value! as AnyObject?
            
            
            
            
            if let name = tutorInfo["firstName"] {
                
                let fullnameIn = "\(firstname!) " + "\(lastname!)"
                fullname = fullnameIn
                print(fullname)
                var schedule = self._SCHEDULE_REF_.child("\(fullname)").observe(FIRDataEventType.value, with: { (snapshot) in
                    
                    if "\(snapshot.value)" != "Optional(<null>)"{
                        if let scheduleDict = snapshot.value as! NSDictionary?{
                            print("\(scheduleDict)")
                            
                            
                            var appointment: (student: String, time: String)
                            //Looping through the Dictionary
                            
                            for item in scheduleDict {
                                
                                let aps = item.value as! NSDictionary
                                print("\(aps["student"])")
                                appointment.student = aps["student"] as! String
                                appointment.time = aps["time"] as! String
                                appointmentArrray.append(appointment)
                                
                            }
                            
                            self.scheduleListIni = appointmentArrray
                            
                            
                        }
                        
                    }
                    
                })
                
            }
        })
        
        print("My full name is \(name)")
        
        
        imageView.image  = UIImage(named:"yellow")
        tutorName.text = name

    }
    
    override func viewDidLoad() {
        
                        
    }
    

    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tutorAppointment" {
            
            let destinationController = segue.destination as! TutorWelcome
            
             destinationController.scheduleList = scheduleListIni
            
            
            
        }
        

    }





}
