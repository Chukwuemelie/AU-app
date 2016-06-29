//
//  Schedule.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/8/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Foundation
import CoreData

class Schedule: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var tutorSchedule: String
    @NSManaged var timeWhenBooked: String
    @NSManaged var subject: String
    @NSManaged var image: String
    
}
