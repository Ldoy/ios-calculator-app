//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var prevNumberLabel: UILabel!
    var storageIndex = 0
    
    var isOperator = false {
        didSet {
            storageIndex += 1
            
            let value = inputStorage[storageIndex]
            
            if self.isOperator {
                prevNumberLabel.text? = currentNumberLabel.text ?? zero
                currentNumberLabel.text = zero
                return
            }
            
            if self.currentNumberLabel.text == zero {
                self.currentNumberLabel.text? = value
            } else {
                self.currentNumberLabel.text? += value
            }
        }
    }
    
    var isConvertSign = false {
        didSet {
            storageIndex += 1
            
            guard let currentText = self.currentNumberLabel.text else {
                return
            }
            
            if self.isConvertSign {
                self.currentNumberLabel.text = "-" + currentText
            } else if let index = currentText.firstIndex(of: "-") {
                self.currentNumberLabel.text?.remove(at: index)
            } else {
                self.isConvertSign = !self.isConvertSign
                storageIndex -= 1
            }
        }
    }
    
    private let calculator: Calculatorable = Calculator()
    private let zero = "0"
    private var inputStorage: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentNumberLabel.text = zero
        storageIndex = 0
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
            } else {
                inputStorage.append(with)
            }
        }
    }
    
    @IBAction func touchUpNumberButton(_ sender: UIButton) {
        inputStorage.append(sender.tag.description)
        isOperator = false
    }
    
    @IBOutlet weak var stackViewTest: UIStackView!
    @IBOutlet weak var testTest: UIStackView!
    
    @IBOutlet weak var operatorTest: UILabel!
    
    @IBOutlet weak var scrollViewTest: UIScrollView!
    
    @IBAction func touchUpDoubleZeroButton(_ sender: UIButton) {
        inputStorage.append("00")
        isOperator = false
    }
    
    @IBAction func touchUpDotButton(_ sender: UIButton) {
        inputStorage.append(".")
        isOperator = false
    }
    @IBOutlet weak var anchor: NSLayoutConstraint!
    
    @IBAction func touchUpDivideButton(_ sender: UIButton) {
        updateChangableOperator(with: "/")
        isOperator = true
        
        
        let label = UILabel()
        label.text = currentNumberLabel.text ?? "0"
        testTest.addArrangedSubview(label)
        
        scrollViewTest.setContentOffset(CGPoint(
                                            x: 0,
                                            y: scrollViewTest.contentSize.height
                                                + scrollViewTest.contentInset.bottom
                                                - scrollViewTest.bounds.height)
                                        , animated: false)
    }
    
    @IBAction func touchUpMultiplyButton(_ sender: UIButton) {
        updateChangableOperator(with: "*")
        isOperator = true
    }
    
    @IBAction func touchUpMinusButton(_ sender: UIButton) {
        updateChangableOperator(with: "-")
        isOperator = true
    }
    
    @IBAction func touchUpPlusButton(_ sender: UIButton) {
        updateChangableOperator(with: "+")
        isOperator = true
    }
    
    @IBAction func touchUpEqualButton(_ sender: UIButton) {
        let result = calculator.calculate(input: inputStorage)
    }
    
    @IBAction func touchUpAllClearButton(_ sender: UIButton) {
        inputStorage.removeAll()
        currentNumberLabel.text = zero
        storageIndex = 0
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
            let _ = inputStorage.popLast()
        }
    }
    
    @IBAction func touchUpConvertSignButton(_ sender: UIButton) {
        inputStorage.append("⁺⁄₋")
        isConvertSign = !isConvertSign
    }
    
}

