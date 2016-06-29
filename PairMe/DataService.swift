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
    
    private var _BASE_REF_ = Firebase(url: "\(BASE_URL)")
    private var _USER_REF_ = Firebase(url: "\(BASE_URL)/users")
    private var _TUTOR_REF_ = Firebase(url: "\(BASE_URL)/tutors")
    
    var BASE_REF: Firebase{
        
        return _BASE_REF_
        
    }
    
    
    var USER_REF: Firebase{
        return _USER_REF_
    
    
    }
    
    var CURRENT_USER_REF: Firebase{
    
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser
    
    
    }
    
    var TUTOR_REF: Firebase{
        return _TUTOR_REF_
    }
    
    var CURRENT_TUTOR_REF: Firebase{
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentTutor = Firebase(url: "\(BASE_REF)").childByAppendingPath("tutors").childByAppendingPath(userID)
        
        return currentTutor

    }

    
    

    func createNewAccount(uid: String, user: Dictionary<String, String>){
    
        USER_REF.childByAppendingPath(uid).setValue(user)
    
    
    }
    
    func createNewTutorAccount(uid: String, tutor: Dictionary<String, String>){
        TUTOR_REF.childByAppendingPath(uid).setValue(tutor)

    }


}
