//
//  ViewController.swift
//  PairMe
//
//  Created by Raluchukwu Onwubuya on 3/20/16.
//  Copyright © 2016 emelieonw. All rights reserved.
//
import Firebase
import UIKit

class ViewController: UIViewController {
    
   

    @IBOutlet weak var SignUpTutor: UIButton!
    @IBOutlet weak var SignUpStudent: UIButton!
    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue){
    
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var shouldAutorotate : Bool {
        // Lock autorotate
        return false
    }
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        // Only allow Portrait
        return UIInterfaceOrientation.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

