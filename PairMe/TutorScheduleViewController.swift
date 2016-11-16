//
//  TutorScheduleViewController.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/6/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import CoreData


class TutorScheduleViewController: UITableViewController {
    
    var objects = [AnyObject]()
    var tutors :[Tutors] = [
        
        Tutors(name: "Chukwuemelie Onwubuya", image: "chuk.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm"),
        Tutors(name: "Raluchukwu Onwubuya", image: "ralu.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm"),
        Tutors(name: "Eric Coleman", image: "eric.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm"),
        Tutors(name: "Tinom Shokfai", image: "tinom.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm"),Tutors(name: "Esther Olunkunle", image: "esther.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm"),
        Tutors(name: "Taiwo Adelabu", image: "taiwo.jpg", subject: "Maths & Physics", schedule: "Weekdays 11am-12pm")
        
        
        
    ]
    
    var schedule: Schedule!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making the navigation bar
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TutorScheduleViewCell
        
        cell.name.text = tutors[(indexPath as NSIndexPath).row].name
        cell.subject.text = tutors[(indexPath as NSIndexPath).row].subject
        cell.schedule.text = tutors[(indexPath as NSIndexPath).row].schedule
        cell.imageview.image = UIImage(named: tutors[(indexPath as NSIndexPath).row].image)
        
        //creating circular images
        cell.imageview.layer.cornerRadius = 29.0
        cell.imageview.clipsToBounds = true
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Create and option menu
        let optionMenu = UIAlertController(title: "Appointment", message: "Would you like to book an appointment?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //Add actions to the option menu
        let cancelActions = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelActions)
        
        let indexPath = self.tableView.indexPathForSelectedRow
        let bookAppointment = UIAlertAction(title: "Schedule one with \(tutors[(indexPath! as NSIndexPath).row].name)", style: .default, handler: {(action:UIAlertAction) -> Void in
                
//                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//                    
//                    self.schedule  = NSEntityDescription.insertNewObjectForEntityForName("Schedule", inManagedObjectContext: managedObjectContext) as! Schedule
//                    
//                    self.schedule.name = self.tutors[indexPath!.row].name
//                    self.schedule.image =  self.tutors[indexPath!.row].image
//                    self.schedule.subject = self.tutors[indexPath!.row].subject
//                    self.schedule.tutorSchedule = self.tutors[indexPath!.row].schedule
//                    
//                    //Testing to see if the data is saved in CoreData correctly
//                    print( self.schedule.name)
//                    print(self.schedule.image)
//                    print(self.schedule.subject)
//                    print(self.schedule.tutorSchedule)
//                    
//                    
//                    do {
//                        
//                        try managedObjectContext.save()
//                        
//                        
//                        
//                    } catch {
//                        
//                        print (error)
//                        return
//                        
//                    }
//                    
//                    
//                    
//                    
//                }
//            
//                
//            
//            let bookedApt = UIAlertController(title: "Done", message: "We have scheduled an appointment with \(self.tutors[indexPath!.row].name)", preferredStyle: .Alert)
//            bookedApt.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//            self.presentViewController(bookedApt, animated: true, completion: nil)
            
            
            self.performSegue(withIdentifier: "ShowTimePicker", sender: nil )
        })
        
        optionMenu.addAction(bookAppointment)
        
        
        
        
        //Display menu
        self.present(optionMenu, animated: true, completion: nil)
            
        
        
    }
    
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimePicker" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ScheduleTime
                destinationController.scheduleWithTime = self.tutors[(indexPath as NSIndexPath).row]
                print(destinationController.scheduleWithTime)
            }
        }
    }

    
}





