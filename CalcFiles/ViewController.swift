//
//  ViewController.swift
//  Calculator
//
//  Created by Nicholas Raptis on 4/8/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingNumber = false
    
    let brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTypingNumber){
        
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        
        if userIsInTheMiddleOfTypingNumber
        {
            enter()
        }
        
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
        /*
        switch(operation)
        {
        case "*": performOperation{$0 * $1}
        case "+": performOperation{$0 + $1}
        case "/": performOperation{$1 / $0}
        case "-": performOperation{$1 - $0}
        case "⎇": performUnaryOperation{sqrt($0)}
            
            
            
            
        //case "/":
        //case "+":
        //case "-":
        default: break
        }
        */
        
    }
    
    /*
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performUnaryOperation(operation: Double -> Double){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func multiply(op1: Double, op2: Double) -> Double{
        return op1 * op2
    }
    
    
    var operandStack = Array<Double>()
    */

    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        //operandStack.append(displayValue)
        //print(operandStack)
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var displayValue:Double{
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
    }


}

