//
//  ViewController.swift
//  Psychologist
//
//  Created by xu on 15/9/15.
//  Copyright (c) 2015年 xu. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: sender)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nvc = destination as? UINavigationController{
            destination = nvc.visibleViewController
        }
        
        if let hvc = destination as? HappinessViewController{
            if let identifier = segue.identifier{
                switch identifier {
                case "sad" :
                    hvc.happiness = 0;                    
                case "happiness" :
                    hvc.happiness = 100;
                case "meh" :
                    hvc.happiness = 50;
                default:
                    hvc.happiness = 100;
                }
            }
        }
    }

}

