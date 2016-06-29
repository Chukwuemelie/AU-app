//
//  MySchedule.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/8/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import CoreData

var schedule: [Schedule] = []

var fetchResultController: NSFetchedResultsController!

class MySchedule: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        let fetchRequest = NSFetchRequest(entityName: "Schedule")
        let sortDescriptor = NSSortDescriptor(key:"name", ascending: true
        )
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchResultController.delegate = self
            
            
            do{
                try fetchResultController.performFetch()
                schedule = fetchResultController.fetchedObjects as! [Schedule]
            }catch{
                
                print(error)
            }
            
            
        }
        
        
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellMySchedule", forIndexPath: indexPath) as! MyScheduleViewCell
        
        
        cell.nameTutor.text = schedule[indexPath.row].name
        cell.subject.text = schedule[indexPath.row].subject
        cell.schedule.text = schedule[indexPath.row].tutorSchedule
        cell.imageview.image = UIImage(named: schedule[indexPath.row].image)
        
        print(cell.nameTutor.text)
        print(cell.subject.text)
        print(cell.schedule.text)
        print(cell.imageview.image)
        
        
        //creating circular images
        cell.imageview.layer.cornerRadius = 29.0
        cell.imageview.clipsToBounds = true
        
        return cell
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Delete button
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            //Delete it from the schedule array
            schedule.removeAtIndex(indexPath.row)
            
            //Delete the row from the database
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            
                let scheduleToDelete = fetchResultController.objectAtIndexPath(indexPath) as! Schedule
                managedObjectContext.deleteObject(scheduleToDelete)
            
                do {
                    try managedObjectContext.save()
                    
                }catch {
                    
                    print(error)
                    
                }
                

            }
            
        })
        
        return [deleteAction]
        
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
   
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndex = newIndexPath{
            
                tableView.insertRowsAtIndexPaths([_newIndex], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if let _indexPath = indexPath {
            
                tableView.deleteRowsAtIndexPaths( [_indexPath], withRowAnimation: .Fade)
            }
            
        case .Update:
            
            if let _indexPath = indexPath {
            
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        
        schedule = controller.fetchedObjects as! [Schedule]
        
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    override func viewDidDisappear(animated: Bool) {
        fetchResultController = nil;
    }
}
