//
//  ScheduleTime.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/15/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import EventKit
import EventKitUI
import Firebase

class ScheduleTime: UIViewController {
    
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var bookTimeButton: UIButton!
    
    
    
    var scheduleWithTime: Tutors!
    var schedule: Schedule!
    
    func datePickerValueChanged(_ datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMMM dd yyyy, HH:mm"
        let bookedTime = dateFormatter.string(from: datePicker.date)
        timeLabel.text = bookedTime
        self.bookTimeButton.isEnabled = true
    }


    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        datePicker.addTarget(self, action: #selector(ScheduleTime.datePickerValueChanged), for: UIControlEvents.valueChanged)
            self.bookTimeButton.isEnabled = false
        
        
    }
    
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date, alarm:EKAlarm){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.alarms = [alarm]
        
        do {
            
            try eventStore.save(event, span: .thisEvent)
        }catch{
        
            print("Did not save to calendar")
        
        }
    }
    
    @IBAction  func bookTime(){
        var key: String = "n"
        let eventStore = EKEventStore()
        var startDate = Date()
        startDate = datePicker.date
        let endDate = startDate.addingTimeInterval(60 * 60) // One hour
        let alarm:EKAlarm = EKAlarm(relativeOffset: -300)
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "Tutoring with \(self.scheduleWithTime.name)", startDate: startDate, endDate: endDate, alarm:alarm)
            })
        } else {
            createEvent(eventStore, title: "Tutoring with \(self.scheduleWithTime.name)", startDate: startDate, endDate: endDate,alarm: alarm)
        }
        
        self.performSegue(withIdentifier: "ShowMySchedule", sender: nil)

        
        //Storing the schedule in Firebase
       
        _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
        _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users")
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        let _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
        
        let usernameRef = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users/\(userID)/firstName/")
        
        var nameStudent: AnyObject?
        
       
        _ = usernameRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            nameStudent = snapshot.value! as AnyObject?
            let match = [
                
                "student" : "\(nameStudent!)",
                "time": "\(self.timeLabel.text!)"
            ]
            
            
             key = _SCHEDULE_REF_.child("\(self.scheduleWithTime.name)").childByAutoId().key
            _SCHEDULE_REF_.child("\(self.scheduleWithTime.name)/\(key)").updateChildValues(match)
            
            
            //Storing the Data
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                self.schedule  = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: managedObjectContext) as! Schedule
                
                self.schedule.name = self.scheduleWithTime.name
                self.schedule.image =  self.scheduleWithTime.image
                self.schedule.subject = self.scheduleWithTime.subject
                self.schedule.tutorSchedule = self.timeLabel.text!
                self.schedule.scheduleID = key
                
                
                
                //Testing to see if the data is saved in CoreData correctly
                print(self.schedule.name)
                print(self.schedule.image)
                print(self.schedule.subject)
                print(self.schedule.tutorSchedule)
                print(key)
                
                do {
                    
                    try managedObjectContext.save()
                    
                    
                    
                } catch {
                    
                    print (error)
                    return
                    
                }
                
                
                
                
            }
            
        
            
            
        })
        //Retrieving the user name
        let bookedApt = UIAlertController(title: "Done", message: "We have scheduled an appointment with \(self.scheduleWithTime.name)", preferredStyle: .alert)
        bookedApt.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(bookedApt, animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
