## iOS 커리어 스타터 캠프

### 계산기 프로젝트 저장소

- 이 저장소를 자신의 저장소로 fork하여 프로젝트를 진행합니다
---

### Flowchart

|Reader|Calculator|
|---|---|
|![image](./flowchart/reader.png)|![image](./flowchart/calculator.png)|

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

![TIL_Tacocat_0623%20899e3498160145ec80d0ea139b6be9ce/Screen_Shot_2021-06-24_at_12.41.35.png](TIL_Tacocat_0623%20899e3498160145ec80d0ea139b6be9ce/Screen_Shot_2021-06-24_at_12.41.35.png)

- **[BinaryInterger](https://developer.apple.com/documentation/swift/binaryinteger)** : The BinaryInteger protocol is the basis for all the integer types provided by the standard library

→ 수박의 방식 : NSNumber를 사용해서 `Double`로 바꿔보자

- [NSNumber](https://developer.apple.com/documentation/foundation/nsnumber)란? An object wrapper for primitive scalar numeric values.
    - 초기의(원시의) 스칼라  숫자 값을 C scalar (numeric) type으로 wrap해주는 아이
    - readOnly property 를 제공하며 Boolea, Int(int16, int32등), Float, Double등의 값을 바꿀 수 있다.
    - `Toll-Free Bridging` : 즉 NSNumber타입인 경우 Core Foundation의 함수 호출 파라미터와 Objective-C의 수신자로서 사용가능한 타입이다. 즉 타입을 바꿀 필요가 없다(?)
        - means that you can use the same data type as the parameter to a Core Foundation function call or as the receiver of an Objective-C message
    - 언제 사용?
        - NumberFormatter의 `string(from:)` 메소드의 경우 from 의 인자로 NSNumber타입만 가능하기 때문에 이 메소드를 쓸 때 타입캐스팅으로(as) NSNumber로 바꾼 후 string(from:)메소드 [사용](https://www.hackingwithswift.com/example-code/language/what-is-nsnumber)

2. Protocol만들고 Extension을 따로 추가하면서 구현하는 이유가 무엇일까?

- 프로토콜을 내부에 함수구현이 안되기 때문에 특정 데이터 타입(Collection, Int등) 프로토콜에 세부 method를 구현해 주고 싶을 때 extension을 사용한다.

3. 프로젝트 코드에서 for loop로 구현한 것 말고 어떻게 다르게 구현할 수 있을까?
