//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by xu on 15/9/17.
//  Copyright (c) 2015年 xu. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController: HappinessViewController , UIPopoverPresentationControllerDelegate{
    
    override var happiness : Int{
        didSet{
            diagnosticHistory += [happiness]
        }
    }

    private var defaults = NSUserDefaults.standardUserDefaults()
    
    
    var diagnosticHistory :[Int]{
        get{
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
        set {
            defaults.setObject(newValue, forKey:History.DefaultsKey)
        }
    }
    
    private struct History {
        
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController{
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default:
                break
            }
        }
        
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
