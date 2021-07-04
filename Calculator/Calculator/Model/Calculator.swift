import Foundation

let zero = "0"

enum ErrorCase: Error {
	case unknownInputCase
	case dividedByZero
}

enum AccessibleOperator: String {
	case plus = "+", minus = "-", multiply = "*", divide = "/"
}

enum CalculatorComponent {
	case number
	case `operator`
	case equalSign
	case allClear
	case clearEntry
	case signConverter
	case dot
    
    static func checkValueIsDouble(value: String) -> Bool {
        if Double(value) != nil {
            return true
        } else {
            return false
        }
    }
	
	static func convertToComponentType(from userInput: String) throws -> Self {
		switch userInput {
		case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "00", "." :
			return .number
		case "/", "*", "+", "-" :
			return .operator
		case "=" :
			return .equalSign
		case "AC" :
			return .allClear
		case "CE" :
			return .clearEntry
		case "⁺⁄₋" :
			return .signConverter
		default:
            if checkValueIsDouble(value: userInput) {
                return .number
            } else {
                throw ErrorCase.unknownInputCase
            }
		}
	}
}

protocol Calculatorable {
	func calculate(input: [String]) -> String
}

protocol PostfixExpression {
	func convertToPostfix(fromInfix input: [String]) -> [String]
	func calculatePostfix(postfix: [String]) throws -> Double
}

extension PostfixExpression {
	private func checkPriority(A a: String, isLowerThenB b: String) -> Bool {
		if ["+", "-"].contains(a), ["*", "/"].contains(b) {
			return true
		}
		return false
	}
	
	func makeInfixExpression(from: [String]) throws -> [String] {
		var infixExpression = [String]()
		var infixNumberString = ""
		var converterCount = 0
		
		for userInput in from {
			let userInputType = try? CalculatorComponent.convertToComponentType(from: userInput)
            
			switch userInputType {
			case .number:
				infixNumberString += userInput
			case .operator:
				converterCount = 0
				infixExpression.append(infixNumberString)
				infixExpression.append(userInput)
				infixNumberString = ""
			case .signConverter:
				converterCount += 1
				if converterCount % 2 == 1 {
					infixNumberString = AccessibleOperator.minus.rawValue + infixNumberString
				} else {
					infixNumberString.remove(at: infixNumberString.startIndex)
				}
			default:
                if CalculatorComponent.checkValueIsDouble(value: userInput) {
                    infixNumberString += userInput
                } else {
                    throw ErrorCase.unknownInputCase
                }
			}
		}
		
		infixExpression.append(infixNumberString)
		
		return infixExpression
	}
	
	func convertToPostfix(fromInfix input: [String]) -> [String] {
		var postfix = [String]()
		var stack = Stack<String>()
		
		for currentElement in input {
			if let _ = Double(currentElement) {
				postfix.append(currentElement)
			} else {
				if let lastElement = stack.pop() {
					if checkPriority(A: lastElement, isLowerThenB: currentElement) {
						stack.push(element: lastElement)
						stack.push(element: currentElement)
					} else {
						postfix.append(lastElement)
						stack.push(element: currentElement)
					}
					
				} else {
					stack.push(element: currentElement)
				}
			}
		}
		
		while stack.peek() != nil {
			if let element = stack.pop() {
				postfix.append(element)
			}
		}
		
		return postfix
	}
	
	func calculatePostfix(postfix: [String]) throws -> Double {
		var stack = Stack<String>()
		var popedValueFromStack: Double {
			return Double(stack.pop() ?? zero) ?? .zero
		}
		
		for element in postfix {
			let elementType = AccessibleOperator.init(rawValue: element)
			switch elementType {
			case .plus:
				let next = popedValueFromStack
				let prev = popedValueFromStack
				stack.push(element: String(prev + next))
			case .minus:
				let next = popedValueFromStack
				let prev = popedValueFromStack
				stack.push(element: String(prev - next))
			case .multiply:
				let next = popedValueFromStack
				let prev = popedValueFromStack
				stack.push(element: String(prev * next))
			case .divide:
				let next = popedValueFromStack
				let prev = popedValueFromStack
				
				if next == .zero {
					throw ErrorCase.dividedByZero
				} else {
					stack.push(element: String(prev / next))
				}
			default:
				stack.push(element: element)
			}
		}
		
		return popedValueFromStack
	}
}

struct Calculator: Calculatorable, PostfixExpression {
    
	private let numberFormatter = NumberFormatter()
	private let maximumSignificantDigits = 20
	private let currentLocale = "en_US"
	
	init() {
		numberFormatter.numberStyle = .decimal
		numberFormatter.roundingMode = .halfUp
		numberFormatter.maximumSignificantDigits = maximumSignificantDigits
		if let USLocale = NSLocale().displayName(forKey: .countryCode, value: currentLocale) {
			numberFormatter.locale = NSLocale(localeIdentifier: USLocale) as Locale
		}
	}
	
	func formatting(number: Double) -> String? {
		return numberFormatter.string(from: NSNumber(value: number))
	}
	
	func castToIntFrom(double: Double) -> Int? {
		if double.truncatingRemainder(dividingBy: 1) == .zero {
			return Int(double)
		} else {
			return nil
		}
	}
	
	func castToStringFrom(number: Double) -> String {
		let castedValue = castToIntFrom(double: number)
		
		if let intValue = castedValue {
			return String(intValue)
		}
			else {
            let double = number
			return String(double)
		}
	}
	
    
	func calculate(input: [String]) -> String {
		let notANumber = "NaN"
		
		guard let infix = try? makeInfixExpression(from: input) else {
			return notANumber
		}
		
		let postfix = convertToPostfix(fromInfix: infix)
		
		guard let calculatedValue = try? calculatePostfix(postfix: postfix) else {
			return notANumber
		}
		
		return castToStringFrom(number: calculatedValue)
	}
	
}
