//
//  MySchedule.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/8/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import Firebase
import EventKitUI

var schedule: [Schedule] = []

var fetchResultController: NSFetchedResultsController<NSManagedObject>!

class MySchedule: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        let sortDescriptor = NSSortDescriptor(key:"name", ascending: true
        )
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<NSManagedObject>, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchResultController.delegate = self
            
            
            do{
                try fetchResultController.performFetch()
                schedule = fetchResultController.fetchedObjects as! [Schedule]
            }catch{
                
                print(error)
            }
            
            
        }
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMySchedule", for: indexPath) as! MyScheduleViewCell
        
        
        cell.nameTutor.text = schedule[(indexPath as NSIndexPath).row].name
        cell.subject.text = schedule[(indexPath as NSIndexPath).row].subject
        cell.schedule.text = schedule[(indexPath as NSIndexPath).row].tutorSchedule
        cell.imageview.image = UIImage(named: schedule[(indexPath as NSIndexPath).row].image)
        
        print(cell.nameTutor.text)
        print(cell.subject.text)
        print(cell.schedule.text)
        print(cell.imageview.image)
        
        
        //creating circular images
        cell.imageview.layer.cornerRadius = 29.0
        cell.imageview.clipsToBounds = true
        
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
         var eventStore : EKEventStore = EKEventStore()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMMM dd yyyy, HH:mm"
        
        print(schedule[(indexPath as NSIndexPath).row].tutorSchedule)
        let bookedTime = dateFormatter.date(from: schedule[(indexPath as NSIndexPath).row].tutorSchedule)
        let tutorName = schedule[(indexPath as NSIndexPath).row].name
        let scheduleID = schedule[(indexPath as NSIndexPath).row].scheduleID
        print(tutorName);
        
        print (bookedTime)
        var startDate = bookedTime
        var endDate = bookedTime!.addingTimeInterval(60*60)
        
        print(startDate,endDate)
        
        var event:EKEvent = EKEvent(eventStore: eventStore)
        event.title = "Tutoring with \(schedule[(indexPath as NSIndexPath).row].name)"
        event.startDate = startDate!
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        print(event)
        var predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate, calendars: nil)
        var eventToBeDeleted = eventStore.events(matching: predicate) as [EKEvent]!
        print(eventToBeDeleted)
        func deleteEvent(_ Events: [EKEvent]){
        
            //Delete event from calendar
            for i in eventToBeDeleted!{
                do {try eventStore.remove(i, span: .thisEvent)}catch{ print (error)}
            }
        }
        
        // Delete button
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: { (action, indexPath) -> Void in
            //Delete Event from Calendar
            
            deleteEvent(eventToBeDeleted!)
            
            //Delete it from the schedule array
            schedule.remove(at: (indexPath as NSIndexPath).row)
            
            //Deleting it from the Firebase Datebase
            _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
            _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users")
            let userID = UserDefaults.standard.value(forKey: "uid") as! String
            let _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule/")
            
            _ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users/\(userID)/firstName/")
            
            let appointmentToBeDeleted = _SCHEDULE_REF_.child("\(tutorName)/\(scheduleID)")
            appointmentToBeDeleted.removeValue()
            
            //Delete the row from the database
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext{
            
                let scheduleToDelete = fetchResultController.object(at: indexPath) as! Schedule
                managedObjectContext.delete(scheduleToDelete)
            
                do {
                    try managedObjectContext.save()
                    
                }catch {
                    
                    print(error)
                    
                }
            }
            
        })
        
        return [deleteAction]
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let _newIndex = newIndexPath{
            
                tableView.insertRows(at: [_newIndex], with: .fade)
            }
            
        case .delete:
            if let _indexPath = indexPath {
            
                tableView.deleteRows( at: [_indexPath], with: .fade)
            }
            
        case .update:
            
            if let _indexPath = indexPath {
            
                tableView.reloadRows(at: [_indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        schedule = controller.fetchedObjects as! [Schedule]
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fetchResultController = nil;
    }
}
