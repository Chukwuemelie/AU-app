//
//  WelccomeViewController.swift
//  PairMe
//
//  Created by Chuk Onwubuya on 5/3/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//

import UIKit
import Firebase

class WelccomeViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    
    
    var nameText: String!
    var imageField: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = nameText
        print(name.text)
    
        
       
    
    }
    
    
}
