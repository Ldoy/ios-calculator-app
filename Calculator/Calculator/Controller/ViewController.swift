//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
	
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var prevNumberLabel: UILabel!
    var count = 0

    var currentNumberString = ""{
        didSet {
            let value = inputStorage[count]
            
            if let valueType = try? CalculatorComponent.convertToComponentType(from: value), valueType == .operator {
                prevNumberLabel.text? = currentNumberLabel.text ?? "0"
                currentNumberLabel.text = "0"
            }
            
            self.currentNumberLabel.text? += value
            count += 1
        }
    }
    
	private let calculator: Calculatorable = Calculator()
	private let zero = "0"
	private var inputStorage: [String] = ["+"]
		
	override func viewDidLoad() {
		super.viewDidLoad()
        currentNumberString = "여기엔 아무거나 들어가도 되요 근데 뭐라도 들어가야 해요"
	}
	
	private func updateChangableOperator(with: String) {
		guard let lastElement = inputStorage.last else {
			inputStorage.append(zero)
			inputStorage.append(with)
			return
		}
		
		if let lastType = try? CalculatorComponent.convertToComponentType(from: lastElement) {
			if lastType == .operator && with != lastElement {
				let lastIndex = inputStorage.count-1
				inputStorage[lastIndex] = with
			} else if lastType == .number {
				inputStorage.append(with)
			}
		}
	}
	
    @IBAction func touchUpNumberButton(_ sender: UIButton) {
        inputStorage.append("\(sender.tag)")
        currentNumberString = "숫자가 클릭됨"
    }
    
    @IBAction func touchUpDoubleZeroButton(_ sender: UIButton) {
        inputStorage.append("00")
    }
    
    @IBAction func touchUpDotButton(_ sender: UIButton) {
        inputStorage.append(".")
	}
	
	@IBAction func touchUpDivideButton(_ sender: UIButton) {
		updateChangableOperator(with: "/")
	}
	
	@IBAction func touchUpMultiplyButton(_ sender: UIButton) {
		updateChangableOperator(with: "*")
	}
	
	@IBAction func touchUpMinusButton(_ sender: UIButton) {
		updateChangableOperator(with: "-")
	}
	
	@IBAction func touchUpPlusButton(_ sender: UIButton) {
		updateChangableOperator(with: "+")
	}
	
	@IBAction func touchUpEqualButton(_ sender: UIButton) {
		let result = calculator.calculate(input: inputStorage)
	}
	
	@IBAction func touchUpAllClearButton(_ sender: UIButton) {
		inputStorage.removeAll()
	}
	
	@IBAction func touchUpClearEntryButton(_ sender: UIButton) {
		guard let lastValue = inputStorage.last,
			  let lastType = try? CalculatorComponent.convertToComponentType(from: lastValue),
			  lastType != .operator else {
			return
		}
		
		if lastType == .equalSign {
			inputStorage.removeAll()
		} else if lastType == .number {
			inputStorage.popLast()
		}
	}
	
	@IBAction func touchUpConvertSignButton(_ sender: UIButton) {
		inputStorage.append("⁺⁄₋")
	}
	
}

