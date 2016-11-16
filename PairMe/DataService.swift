//
//  DataService.swift
//  PairMe
//
//  Created by Raluchukwu Onwubuya on 4/14/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import Foundation
import Firebase


class DataService{
    
    static let dataService = DataService()
    
    fileprivate var _BASE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)")
    fileprivate var _USER_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/users")
    fileprivate var _TUTOR_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/tutors")
    fileprivate var _SCHEDULE_REF_ = FIRDatabase.database().reference(fromURL: "\(BASE_URL)/schedule")
    
    var BASE_REF: FIRDatabaseReference{
        
        return _BASE_REF_
        
    }
    
    
    var USER_REF: FIRDatabaseReference{
        return _USER_REF_
    
    
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference{
    
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        let currentUser = FIRDatabase.database().reference(fromURL: "\(BASE_URL)").child(byAppendingPath: "users").child(byAppendingPath: userID)
        
        return currentUser
    
    
    }
    
    var TUTOR_REF: FIRDatabaseReference{
        return _TUTOR_REF_
    }
    
    var CURRENT_TUTOR_REF: FIRDatabaseReference{
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        let currentTutor = FIRDatabase.database().reference(fromURL: "\(BASE_URL)").child(byAppendingPath: "tutors").child(byAppendingPath: userID)
        
        return currentTutor

    }
    
    var SCHEDULE_REF: FIRDatabaseReference{
        
        return SCHEDULE_REF
        
    }
    

    func createNewAccount(_ uid: String, user: Dictionary<String, String>){
    
        USER_REF.child(byAppendingPath: uid).setValue(user)
    
    
    }
    
    func createNewTutorAccount(_ uid: String, tutor: Dictionary<String, String>){
        TUTOR_REF.child(byAppendingPath: uid).setValue(tutor)

    }


}
