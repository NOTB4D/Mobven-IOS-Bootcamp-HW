//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Semih Emre ÜNLÜ on 26.12.2021.
//

import Foundation

class CalculatorBrain {
    //istenen işlemler + - * / bonus C CE =

    private var accumulator: Double = 0

    var result: Double {
        get {
            return accumulator
        }
    }

    func performOperation(_ operation: String) {
        if let constant = operations[operation] {
            switch constant{
            
            case .Constant(let constantValue):
                accumulator = constantValue
            
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            
            case .BinaryOperation(let function):
                executeWaitingBinaryOperation()
                waiting = WaitingOperation(binaryFunc: function, firstOperand: accumulator)
            
            case .Equals:
                executeWaitingBinaryOperation()
            
            case .ClearEntry:
                accumulator = 0
            
            case .Clear:
                waiting?.firstOperand = 0
                accumulator = 0
                executeWaitingBinaryOperation()
            }
            
        }
    }
    private func executeWaitingBinaryOperation(){
        if waiting != nil{
           accumulator = waiting!.binaryFunc(waiting!.firstOperand, accumulator)
           waiting = nil
       }

    }
    private var waiting:  WaitingOperation?
    
    private struct WaitingOperation{
        var binaryFunc: (Double,Double) -> Double
        var firstOperand: Double
        
    }
    
    func setOperand(_ value: Double) {
        accumulator = value
    }
    
    private var operations : Dictionary<String,Operation> = [
        "√" : Operation.UnaryOperation(sqrt),
        "×" : Operation.BinaryOperation({ return $0 * $1 }),
        "÷" : Operation.BinaryOperation({ return $0 / $1 }),
        "+" : Operation.BinaryOperation({ return $0 + $1 }),
        "−" : Operation.BinaryOperation({ return $0 - $1 }),
        "=" : Operation.Equals,
        "CE" : Operation.ClearEntry,
        "C" : Operation.Clear({ _ in 0.0})
        
    ]
    
   private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double)-> Double)
        case Equals
        case Clear((Double) -> Double)
        case ClearEntry
    }
}
