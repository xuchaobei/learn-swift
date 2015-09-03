//
//  ViewController.swift
//  calculator
//
//  Created by xu on 15/8/29.
//  Copyright (c) 2015年 xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var display: UILabel!
    
    var isFirstDigit = true;
    
    var brain = CalculatorBrain()
    
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digitStr = sender.currentTitle!;
        if !isFirstDigit{
            display.text = display.text!+digitStr;
        }else{
            display.text = digitStr;
            isFirstDigit = false;
        }
        let digit = NSNumberFormatter().numberFromString(digitStr)!.doubleValue;
        brain.pushOperand(digit)
    }
    
    @IBAction func clear(sender: UIButton) {
        isFirstDigit = true
        displayValue = 0
        brain.clear()
    }
  
    
    @IBAction func operate(sender: UIButton) {
        var operation = sender.currentTitle!
       
        if(!isFirstDigit){
            display.text = display.text!+operation
            let oper = operation.removeAtIndex( advance(operation.startIndex,0))
            brain.pushOperator(oper)
           
        }
        
    }
    
    
    @IBAction func enter() {
       
        if let result = brain.performOperation(){
            displayValue = result
        }
        else{
            displayValue = 0
            isFirstDigit = true
            brain.clear()
        }
        
    }
    
    
     var displayValue : Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue;
        }
        set{
            display.text = "\(newValue)"
        }
    }

}

