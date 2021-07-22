## iOS 커리어 스타터 캠프

### 계산기 프로젝트 저장소

- 이 저장소를 자신의 저장소로 fork하여 프로젝트를 진행합니다
---

### Flowchart

|Reader|Calculator|
|---|---|
|![image](./flowchart/reader.png)|![image](./flowchart/calculator.png)|


###프로젝트 진행을 위해 필요한 개념
- Protocol
- UML
- Unit Test, TDD
- 자료구조(특히 Stack)와 알고리즘
- Extension
- NSNumber, NSLocale, Locale
- Delegate Pattern
- NumberFormmater
- Error Handling
- mutating
- Postfix, Infix Expression
- 부동소수점 오류
- OOP, POP
- tag
- IBAction, IBOutlet
- XCTest
- 브레이크 포인트
- StackView, ScrollView
- Code Coverage
- Performance Tests
- SOLID
    - Single Responsibility Principle (SRP) 단일책임원칙
    - Open-Closed Principle (OCP) 개방폐쇄 원칙
    - Liskov Substitution Principle (LSP) 리스코브 치환 원칙
    - Interface Segregation Principle (ISP) 인터페이스 분리 원칙
    - Dependency Inversion Principle (DIP) 의존성 역성 원칙


##프로젝트 진행 중 생겼던 문제 상황
1. 후위표현식으로 바꾸는 for 루프의 에러를 어떻게 해결할 것인가
   -  모든 for loop 마다 프린트 해서 에러 해결함 
   -  고찰 : print보단 LLDB를 사용해서 다음번엔 해결 해 보자!

2. 스택구조 구현할 때 removeLast로 했더니 에러 → popLast로 변경, removeLast 는 마지막 값을 반환해 주기 때문에 빈 배열인 경우 에러가 생김 
3. 반올림 어떻게 하지?

    ```swift
    let numberFormatter = NumberFormatter()
    numberFormatter.roundingMode = .floor //  형식을 버림으로 지정
    ```

    → roundingMode에는 ceiling, floor, down, up, halfEven, halfDown, halfUP 이 있다. 

    [https://developer.apple.com/documentation/foundation/numberformatter/roundingmode](https://developer.apple.com/documentation/foundation/numberformatter/roundingmode)

    [https://twih1203.medium.com/swift5-numberformatter로-소수점-아래-자릿수-반올림-없이-자르기-ee33219e3cdd](https://twih1203.medium.com/swift5-numberformatter%EB%A1%9C-%EC%86%8C%EC%88%98%EC%A0%90-%EC%95%84%EB%9E%98-%EC%9E%90%EB%A6%BF%EC%88%98-%EB%B0%98%EC%98%AC%EB%A6%BC-%EC%97%86%EC%9D%B4-%EC%9E%90%EB%A5%B4%EA%B8%B0-ee33219e3cdd)
    
4. extension은 저장 프로퍼티 선언이 안됨

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/62cc0498-6965-4b45-8f96-568502d26ae3/Screen_Shot_2021-06-29_at_15.48.52.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/62cc0498-6965-4b45-8f96-568502d26ae3/Screen_Shot_2021-06-29_at_15.48.52.png)

- 대체 가능 코드

    ```swift
    extension Calculatorable {
    	struct Holder {
    		static let numberFormatter = Numberformatter()
    		static let zero = "0"
    		static let maximumsignificantDigits = 20
    		static currentLocale = "en_US"
    		}
    }
    ```

## 프로젝트 진행 중 의문점과 문제점들에 대한 고찰

1. 프로젝트 코드에서 아래와 같이 구현했었는데 그렇다면 prev가 Double이고 next가 Int인 경우와 그 반대의 경우를 모두 구현해야 한다는 문제점이 생긴다. 그렇다면 모든 사용자 입력값을 Double로 바꾸는게 어떨까하는 생각이 들었다. 아니면 Generic을 사용하면 이 문제가 해결될까?
    - 찾아보았는데 어떤 타입 조합도 계산 가능하도록 하는 건 [어려운](https://speakerdeck.com/jessesquires/exploring-swifts-numeric-types-and-protocols?slide=25) 것 같다! 따라서 사용자의 모든 입력값을 Double로 바꿔서 해결하는 것이 좋을 것 같다.

        ```swift
        func plus(prev: Int, next: Int) -> Int {
        		return prev + next
        	}
        	
        	func minus(prev: Int, next: Int) -> Int {
        		return prev - next
        	}
        	
        	func multiply(prev: Int, next: Int) -> Int {
        		return prev * next
        	}
        	
        	func divide(value: Int, by: Int) throws -> Double {
        		if by == 0 {
        			throw ErrorCase.dividedByZero
        		} else {
        			return Double(value) / Double(by)
        			
        		}
        	}
        	
        	func plus(prev: Double, next: Double) -> Double {
        		return prev + next
        	}
        	
        	func minus(prev: Double, next: Double) -> Double {
        		return prev - next
        	}
        	
        	func multiply(prev: Double, next: Double) -> Double {
        		return prev * next
        	}
        	
        	func divide(value: Double, by: Double) throws -> Double {
        		if by == 0 {
        			throw ErrorCase.dividedByZero
        		} else {
        			return value / by
        		}
        	}
        ```

    ```swift
    func convertToDouble<T: BinaryInteger> (from number: T) -> Double {
    	return Double("\(number).0") ?? 0.0
    }
    	
    let test = convertToDouble(from: 4)
    ```

- **[BinaryInterger](https://developer.apple.com/documentation/swift/binaryinteger)** : The BinaryInteger protocol is the basis for all the integer types provided by the standard library

→ 수박의 방식 : NSNumber를 사용해서 `Double`로 바꿔보자

- [NSNumber](https://developer.apple.com/documentation/foundation/nsnumber)란? An object wrapper for primitive scalar numeric values.
    - 초기의(원시의) 스칼라  숫자 값을 C scalar (numeric) type으로 wrap해주는 아이
    - readOnly property 를 제공하며 Boolea, Int(int16, int32등), Float, Double등의 값을 바꿀 수 있다.
    - `Toll-Free Bridging` : 즉 NSNumber타입인 경우 Core Foundation의 함수 호출 파라미터와 Objective-C의 수신자로서 사용가능한 타입이다. 즉 타입을 바꿀 필요가 없다(?)
        - means that you can use the same data type as the parameter to a Core Foundation function call or as the receiver of an Objective-C message
    - 언제 사용?
        - NumberFormatter의 `string(from:)` 메소드의 경우 from 의 인자로 NSNumber타입만 가능하기 때문에 이 메소드를 쓸 때 타입캐스팅으로(as) NSNumber로 바꾼 후 string(from:)메소드 [사용](https://www.hackingwithswift.com/example-code/language/what-is-nsnumber)

=> 하지만 이렇게 Double 바꾸고 계산하니 부동소수점 오류가 생겼다 
    - 이유 : Float, Double 모두 부동소수점 오류는 생긴다
    - 부동소수점 오류 : 실수라는 무한한 크기의 수를 크기가 한정된 변수에 담을 수 없기 때문에 어느정도의 정보손실이 일어나는 것 
        

2. Protocol만들고 Extension을 따로 추가하면서 구현하는 이유가 무엇일까?
- 프로토콜을 내부에 함수구현이 안되기 때문에 특정 데이터 타입(Collection, Int등) 프로토콜에 세부 method를 구현해 주고 싶을 때 extension을 사용한다.

3. 프로젝트 코드에서 for loop로 구현한 것 말고 어떻게 다르게 구현할 수 있을까?
- 고차함수(map, filter, reduce 등)을 이용할 수 있을 것이다
- forEach로 구현하면 성능 차이는 없지만 컴파일 최적화 관점에서 보았을 땐 좋다고 한다. 
