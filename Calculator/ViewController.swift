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
    
    var isFirstInput = true;
    
    var tempDigit : String? = nil
    
    var brain = CalculatorBrain()
    
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digitStr = sender.currentTitle!;
        if !isFirstInput{
            display.text = display.text!+digitStr;
        }else{
            display.text = digitStr;
            isFirstInput = false;
        }
        
        if tempDigit == nil {
            tempDigit = digitStr;
        }else{
            tempDigit = tempDigit! + digitStr
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        isFirstInput = true
        displayValue = 0
        brain.clear()
        tempDigit = nil
    }
  
    
    @IBAction func operate(sender: UIButton) {
        var operation = sender.currentTitle!
       
        if(!isFirstInput){
            if tempDigit != nil {
                let digit = NSNumberFormatter().numberFromString(tempDigit!)!.doubleValue;
                brain.pushOperand(digit)
                tempDigit = nil
            }
            display.text = display.text!+operation
            let oper = operation.removeAtIndex( advance(operation.startIndex,0))
            brain.pushOperator(oper)
           
        }
        
    }
    
    
    @IBAction func enter() {
        if tempDigit != nil {
            let digit = NSNumberFormatter().numberFromString(tempDigit!)!.doubleValue;
            brain.pushOperand(digit)
            tempDigit = nil
        }
        if let result = brain.performOperation(){
            displayValue = result
        }
        else{
            displayValue = 0
            isFirstInput = true
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

