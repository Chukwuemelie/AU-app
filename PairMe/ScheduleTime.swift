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

class ScheduleTime: UIViewController {
    
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    var scheduleWithTime: Tutors!
    var schedule: Schedule!
    
    func datePickerValueChanged(datePicker: UIDatePicker){
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMMM dd, HH:mm"
        let bookedTime = dateFormatter.stringFromDate(datePicker.date)
        timeLabel.text = bookedTime
        
    }


    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        datePicker.addTarget(self, action: #selector(ScheduleTime.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    
        
        
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            
            try eventStore.saveEvent(event, span: .ThisEvent)
        }catch{
        
            print("Did not save to calendar")
        
        }
    }
    
    @IBAction  func bookTime(){
        
        let eventStore = EKEventStore()
        var startDate = NSDate()
        startDate = datePicker.date
        
        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "Tutoring with \(self.scheduleWithTime.name)", startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore, title: "Tutoring with \(self.scheduleWithTime.name)", startDate: startDate, endDate: endDate)
        }
        
        self.performSegueWithIdentifier("ShowMySchedule", sender: nil)

        
        var ref = Firebase(url: "https://pairme.firebaseio.com")
        var matches = ref.childByAppendingPath("matches")
        
        var match = [
            
             "student" : NSUserDefaults.standardUserDefaults().stringForKey("uid") as! AnyObject,
             "tutor": "wewew"
        ]
        
        var matchRef = matches.childByAutoId()
        
        matchRef.setValue(match)
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            self.schedule  = NSEntityDescription.insertNewObjectForEntityForName("Schedule", inManagedObjectContext: managedObjectContext) as! Schedule
            
            self.schedule.name = scheduleWithTime.name
            self.schedule.image =  scheduleWithTime.image
            self.schedule.subject = scheduleWithTime.subject
            self.schedule.tutorSchedule = timeLabel.text!
            
            //Testing to see if the data is saved in CoreData correctly
            print( self.schedule.name)
            print(self.schedule.image)
            print(self.schedule.subject)
            print(self.schedule.tutorSchedule)
            
            
            do {
                
                try managedObjectContext.save()
                
                
                
            } catch {
                
                print (error)
                return
                
            }
            
            
            
            
        }
        
        
        
        let bookedApt = UIAlertController(title: "Done", message: "We have scheduled an appointment with \(self.scheduleWithTime.name)", preferredStyle: .Alert)
        bookedApt.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(bookedApt, animated: true, completion: {})
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
