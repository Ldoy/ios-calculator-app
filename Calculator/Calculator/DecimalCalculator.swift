
struct DecimalCalculator {
    
    var numStack = Stack<String>()
    var operatorStack = Stack<DecimalOperator>()
    
    var current: String = "0"
    
    /// 스택에서 이전 연산자를 꺼내어 연산
    mutating func operatePrev(_ prevOperator: DecimalOperator) {
        guard let firstPop = numStack.pop(), let secondPop = numStack.pop() else {
            print("입력된 값이 없습니다.")
            return
        }
        
        guard let new: Double = Double(firstPop), let old: Double = Double(secondPop) else {
            print("오류, 계산기가 초기화 됩니다.")
            reset()
            return
        }
        
        let newValue: Double
        
        switch prevOperator {
        case .plus:
            newValue = old + new
        case .minus:
            newValue = old - new
        case .multiple:
            newValue = old * new
        case .divide:
            guard new != 0 else {
                print("오류")
                return
            }
            newValue = old / new
        }
        
        numStack.push(String(newValue))
    }
    
    /// 스택에서 모든 연산자를 꺼내어 연산
    mutating func useAllOperator() {
        guard !operatorStack.elements.isEmpty else {
            return
        }
        
        for _ in 1...operatorStack.count() {
        guard let someOperator = operatorStack.pop() else {
            return
        }
            
        operatePrev(someOperator)
        }
    }
    
    /// 스택에서 이전 연산자를 확인 후, 연산을 결정
    mutating func checkPrevOperator() {
        if operatorStack.elements.last == .multiple || operatorStack.elements.last == .divide {
            guard let someOperator = operatorStack.pop() else {
                print("오류")
                return
            }
            operatePrev(someOperator)
        }
    }
    
    /// 연산자가 입력되었을 때 공통으로 동작할 함수
    mutating func calculate(_ operator: DecimalOperator) {
        numStack.push(current)
        
        switch `operator` {
        case .plus, .minus: useAllOperator()
        case .multiple, .divide: checkPrevOperator()
        }
        
        operatorStack.push(`operator`)
        
        guard let peekValue = numStack.peek() else {
            print("오류")
            return
        }
        current = peekValue
    }
}

// MARK: - BasicCalculatable
extension DecimalCalculator: BasicCalculatable {
    mutating func plus() {
        calculate(.plus)
    }
    
    mutating func minus() {
        calculate(.minus)
    }
    
    mutating func reset() {
        numStack.elements = []
        operatorStack.elements = []
        current = "0"
    }
    
    mutating func printResult() {
        numStack.push(current)
        useAllOperator()
        
        guard let peekValue = numStack.peek() else {
            print("오류")
            return
        }
        current = peekValue
    }
}

// MARK: - 10진 계산기에서만 가능한 연산
extension DecimalCalculator {
    mutating func multiple() {
        calculate(.multiple)
    }
    
    mutating func divide() {
        calculate(.divide)
    }
}
