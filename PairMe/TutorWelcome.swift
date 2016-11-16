//
//  TutorWelcome.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 6/16/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class TutorWelcome: UITableViewController {
    
    
      
    @IBOutlet weak var nav: UINavigationBar!
    
    
    @IBAction func refreshtable(_ sender: AnyObject) {
   
        tableView.reloadData()
    
    }
 
    var scheduleList = [(student:String, time: String)]()
    let _BASE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
    let userID = UserDefaults.standard.value(forKey: "uid") as! String
    let _TUTOR_REF = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors/")
    let _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        var info : AnyObject?
        var fullname : String = ""
        var nameStudentHandler = _TUTOR_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
            
            
            var appointmentArrray = [(student:String, time: String)]()
            var tutorInfo = snapshot.value! as? NSDictionary
            var firstname = tutorInfo?["firstName"] as? String
            var lastname =  tutorInfo?["lastname"] as? String
            info = snapshot.value! as AnyObject?
            
            
            var fullname = "\(firstname!) " + "\(lastname!)"
            
            
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
                        
                        self.scheduleList = appointmentArrray
                        
                    }
                }
            })
            
        })
    }
    override func viewDidLoad() {
        
        
        
       
        var info : AnyObject?
        var fullname : String = ""
        var nameStudentHandler = _TUTOR_REF.child("\(userID)").observe(FIRDataEventType.value, with: { (snapshot) in
            
            
            var appointmentArrray = [(student:String, time: String)]()
            var tutorInfo = snapshot.value! as! NSDictionary
            var firstname = tutorInfo["firstName"] as? String
            var lastname =  tutorInfo["lastname"] as? String
            info = snapshot.value! as AnyObject?
            
            
            var fullname = "\(firstname!) " + "\(lastname!)"
            
            
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
                    
                    self.scheduleList = appointmentArrray
                    
                    }
                }
            })
            
        })
        
       
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(scheduleList.count)
        return scheduleList.count
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorAppointment", for: indexPath) as! TutorAppointment
        
        cell.nameTutee.text = scheduleList[(indexPath as NSIndexPath).row].student
        cell.timeBooked.text = scheduleList[(indexPath as NSIndexPath).row].time
        cell.imageView!.image = UIImage(named:"tutoring_image")

        
        //creating circular images
        cell.tutorIcon.layer.cornerRadius = 29.0
        cell.tutorIcon.clipsToBounds = true
        
        return cell
        
        
    }

    
    
    
}
