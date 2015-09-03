//
//  CalculatorBrain.swift
//  calculator
//
//  Created by xu on 15/8/29.
//  Copyright (c) 2015年 xu. All rights reserved.
//

import Foundation
class CalculatorBrain {
    
    enum Op{
        case Operand(Double)
        case Operator(Character)
    }
    
    private var postfixStack = [Op]()
    private var operatorStack = [Character]()
    private var calStack = [Double]()


    func pushOperand(operand : Double){
        postfixStack.append(Op.Operand(operand))
        println("stack:\(postfixStack.debugDescription)");

    }
    
    
    func pushOperator(oper : Character){
        if(operatorStack.isEmpty){
            operatorStack.append(oper)
        }else{
            var jump = false
            while(!operatorStack.isEmpty && !jump){
                var preOper = operatorStack.removeLast()
                switch(preOper){
                case "+","-":
                    if(oper != "×" && oper != "÷"){
                        postfixStack.append(Op.Operator(preOper))
                    }else{
                        operatorStack.append(preOper)
                        
                        jump = true
                    }
                    break
                case "×","÷":
                    postfixStack.append(Op.Operator(preOper))
                    break
                default:
                    break
                }
            }
             operatorStack.append(oper)
        }
       
        println("stack:\(postfixStack.debugDescription)");
        
    }
    
    func performOperation() -> Double?{
        if(operatorStack.isEmpty){
            println("表达式输入有误！");
            return nil;
        }
        while(!operatorStack.isEmpty){
            let lastOper = operatorStack.removeLast()
            postfixStack.append(Op.Operator(lastOper))

        }
        return evaluate();
    }
        
    
    func clear(){
        postfixStack.removeAll()
        operatorStack.removeAll()
        calStack.removeAll()
    }
    
    
    private func evaluate() -> Double?{
        let count = postfixStack.count
        for(var i = 0; i < count; i++){
            var curOp = postfixStack[i]
            switch(curOp){
            case Op.Operand(let operand):
                calStack.append(operand)
                break;
            case Op.Operator(let oper):
                let op2 = calStack.removeLast();
                let op1 = calStack.removeLast();
                let tempResult = operate(oper, op1 : op1,op2 : op2)
                if(tempResult != nil){
                    calStack.append(tempResult!)
                }else{
                    return nil
                }
                break
            default:
                return nil
            }
            
        }
        let result = calStack.removeLast()
        postfixStack.removeAll()
        postfixStack.append(Op.Operand(result))
        return result;
    }
    
    private func operate(oper : Character, op1 : Double, op2 : Double) ->Double?{
        switch(oper){
        case "+":
            return op1 + op2;
        case "−":
            return op1 - op2;
        case "×":
            return op1 * op2
        case "÷":
            if(op2 == 0){
                return nil
            }
            return op1 / op2
        default:
            break
        }
        return nil
    }
}