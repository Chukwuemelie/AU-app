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
    
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var nameText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
        print("Name \(nameText)")
        
        
            name.text = nameText
        
        
        image.image  = UIImage(named:"yellow")
        print(name.text)

    }
    
    
}
