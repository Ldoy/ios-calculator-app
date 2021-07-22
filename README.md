## iOS 커리어 스타터 캠프

### 계산기 프로젝트 저장소

- 이 저장소를 자신의 저장소로 fork하여 프로젝트를 진행합니다
---

### Flowchart

|Reader|Calculator|
|---|---|
|![image](./flowchart/reader.png)|![image](./flowchart/calculator.png)|


## 프로젝트 진행 중 생겼던 문제 상황
1. 후위표현식으로 바꾸는 for 루프의 에러를 어떻게 해결할 것인가
   -  모든 for loop 마다 프린트 해서 에러 해결함 
   -  고찰 : print보단 LLDB를 사용해서 다음번엔 해결 해 보자!

2. 스택구조 구현할 때 removeLast로 구현해서 생긴 에러 
   - popLast로 변경, removeLast 는 마지막 값을 반환해 주기 때문에 빈 배열인 경우 에러가 생김 
   
3. extension은 저장 프로퍼티 선언이 안됨
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
    
4. 반올림을 하는 방법 

    ```swift
    let numberFormatter = NumberFormatter()
    numberFormatter.roundingMode = .floor //  형식을 버림으로 지정
    ```

    → roundingMode에는 ceiling, floor, down, up, halfEven, halfDown, halfUP 이 있다. 

    [https://developer.apple.com/documentation/foundation/numberformatter/roundingmode](https://developer.apple.com/documentation/foundation/numberformatter/roundingmode)

    [https://twih1203.medium.com/swift5-numberformatter로-소수점-아래-자릿수-반올림-없이-자르기-ee33219e3cdd](https://twih1203.medium.com/swift5-numberformatter%EB%A1%9C-%EC%86%8C%EC%88%98%EC%A0%90-%EC%95%84%EB%9E%98-%EC%9E%90%EB%A6%BF%EC%88%98-%EB%B0%98%EC%98%AC%EB%A6%BC-%EC%97%86%EC%9D%B4-%EC%9E%90%EB%A5%B4%EA%B8%B0-ee33219e3cdd)
    

## 프로젝트 진행 중 의문점과 문제점들에 대한 고찰
날짜: July 3, 2021
작성자: Tacocat😺 
태그: 계산기, 프로젝트회고

# 계산기 프로젝트 회고

### 왜 스택을 사용하라고 했을까? 리스트와의 차이점과 장단점은 무엇일까? (ing)

- 스택 : 추상 자료형 ADT, 기능 자체가 정의 되어있는게 아님. 기능은 우리가 정의해야 하기 때문에 . 자료정리방식을 제한하기 위해 (왜냐면 배열은 정리방식이 너무 다양하기 때문에)
    - 스택을 구현할 때 `Array`로 구현하냐 `List`로 구현하냐의 차이
        - 리스트로 구현 시 `node`를 설정하게 되는데
    - 스택과 리스트 중 어떤것이 더 프로젝트 기능 구현에 적합한 것인지?
        - 스택 : 조금 더 쉬워서 중점적으로 사용하라고 했을까?
        - 리스트.....
- 리스트 :

### 왜 나는 Double로 바꾸자고 제안했을까?
'처음생각'
1. 기본 연산을 위해 '1번' 같이 구현했었는데 그렇다면 prev가 Double이고 next가 Int인 경우와 그 반대의 경우를 모두 구현해야 한다는 문제점이 생긴다. 
 - 그렇다면 모든 사용자 입력값을 Double로 바꾸는게 어떨까하는 생각이 들었다.(2번)
 - 아니면 Generic을 사용하고 스위프트 라이브러리가 제공하는 기본연산자를 사용하면 이 문제가 해결될까? (3번)

=> 찾아보았는데 어떤 타입 조합도 계산 가능하도록 하는 건 [어려운](https://speakerdeck.com/jessesquires/exploring-swifts-numeric-types-and-protocols?slide=25) 것 같다! 따라서 사용자의 모든 입력값을 Double로 바꿔서 해결하는 것이 좋을 것 같다.
    - 이유 : Float가 부동소수점 오류를 유발하며 7자리까지 나타낼 수 밖에 없기 때문

        ```swift
	// 1번
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
		
		//2번
        
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
    //3
    func convertToDouble<T: BinaryInteger> (from number: T) -> Double {
    	return Double("\(number).0") ?? 0.0
    }
    	
    let test = convertToDouble(from: 4)
    ```


'결과'
=> 모든 입력값을 Double로 타입캐스팅하고 계산했는데 부동소수점 오류가 생겼다 
    - 이유 : Float, Double 모두 부동소수점 오류는 생긴다
    - 부동소수점 오류 : 실수라는 무한한 크기의 수를 크기가 한정된 변수에 담을 수 없기 때문에 어느정도의 정보손실이 일어나는 것 

'해결을 위한 노력'
→ NSNumber를 사용해서 `Double`로 바꿔보자(by 수박)
이유 : readOnly property 를 제공하며 Boolea, Int(int16, int32등), Float, Double등의 값을 바꿀 수 있기 때문

- **[BinaryInterger](https://developer.apple.com/documentation/swift/binaryinteger)** : The BinaryInteger protocol is the basis for all the integer types provided by the standard library
- [NSNumber](https://developer.apple.com/documentation/foundation/nsnumber)란? An object wrapper for primitive scalar numeric values.
    - 초기의(원시의) 스칼라  숫자 값을 C scalar (numeric) type으로 wrap해주는 메소드
    - readOnly property 를 제공하며 Boolea, Int(int16, int32등), Float, Double등의 값을 바꿀 수 있다.
    - `Toll-Free Bridging` : 즉 NSNumber타입인 경우 Core Foundation의 함수 호출 파라미터와 Objective-C의 수신자로서 사용가능한 타입이다. 즉 타입을 바꿀 필요가 없다(?)
        - means that you can use the same data type as the parameter to a Core Foundation function call or as the receiver of an Objective-C message
    - 언제 사용?
        - NumberFormatter의 `string(from:)` 메소드의 경우 from 의 인자로 NSNumber타입만 가능하기 때문에 이 메소드를 쓸 때 타입캐스팅으로(as) NSNumber로 바꾼 후 string(from:)메소드 [사용](https://www.hackingwithswift.com/example-code/language/what-is-nsnumber)
 
 -> 결과 : 실패


'고찰'
=> Numeric을 더 잘 활용했어야 하는 생각이 든다. 


### 리팩토링이 힘든이유
- 코드의 리팩토링을 시도하고자 했지만 메소드가 잘 쪼개져 있지않아서 우선 오류파악이 힘들다.
- ***이유 : 객체지향 설계를 하지 않았기 때문인 것 같다.***
- 다음 부터는 SOLID 원칙을 생각하면서 메소드는 10줄 안에, 타입은 200줄 안에 쓰도록 시도해야겠다.

### 델리게이션 패턴을 프로젝트에 구현 할 수 있었을까?
- 해당 프로젝트에선 딱히 구현할 부분이 없었던 것 같다. 하지만 아래에 델리게이션 패턴에 대한 정리글을 남겨둔다. 
- 그동안 내가 정리했던 Delegation Pattern
- ***Delegation Pattern정리와 예시***
    - 그동안 헷갈렸던 ViewController 에서  `self.delegate` 으로 선언한 부분을 정리해 보자.
        1. 아래 코드는 네이버커넥트 재단의 ios 부스트 코스 강의 중 pickView에 관한 코드이다.
        2. 현재 다음과 같이 비유하고자 한다.(야곰의 비유) 

            `VC = UIImagePickerController의 비서`

            `UIImagePickerController = 사장님`

            `UIImagePickerControllerDelegate, UINavigationControllerDelegate = 비서자격이 될 수 있도록 하는 타입(프로토콜`)  ⇒ 이 프로토콜을 채택하기만 하면 어떤 것이던 비서가 될 수 있다. 

            VC기 Delegate 프로토콜을 *채택하면* 사장님(`UIImagePickerController`)이 기본으로 가지고 있는비서( `delegate static property`)에 *지원*(`UIImagePickerController`의 *delegate에 VC를 할당*) 할 수 있다. 

        3. 코드

        ```swift
        // 1️⃣
        class ViewController: UIViewController, UIImagePickerControllerDelegate,
         UINavigationControllerDelegate {

        	lazy var imagePicker: UIImagePickerController = {
        		let picker: UIImagePickerController = UIImagePickerController()
        		picker.sourceType = .photoLibrary

        		//2️⃣ 
        		picker.delegate = self

        		return picker
        	}()
        	
        	@IBOutlet weak var imageView: UIImageView!
        	
        	@IBAction func touchUpSelectImageButton(_ sender: UIButton) {
        		self.present(self.imagePicker, animated: true, completion: nil)
        	}
        	
        	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        		self.dismiss(animated: true, completion: nil)
        	}
        	
        	func imagePickerController(_ picker: UIImagePickerController, 
        didFinishPickingMediaWithInfo info: 
        [UIImagePickerController.InfoKey : Any]) {

        		// **2번의 예시**
        		if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] 
        as? UIImage {
        			self.imageView.image = originalImage
        		}
        		
        		self.dismiss(animated: true, completion: nil)
        	}
        }
        ```

        2-1 코드설명 

        - 1️⃣ : VC가 두 개의 Delegate 프로토콜을 채택하고 있다.
        - 2️⃣ : ~~다른 건 보지말고 윗 줄의 코드만 보자.~~ 현재 `picker`라는 `UIImagePickerController` 타입의 인스턴스가 자신이 가진 `delegate` 프토퍼티에 `VC`를 할당하였다. 
        즉 `picker` 라는 사장님이 비서로 `VC`를 채용한 것. 이제부터 사장님은 `VC`에게 여러 `user Event`에 대한 정보를 `ask` 하거나 `tell` 할 것이다.
            - **2번의 예시 ???**
                - `imagePickerController` 는 `Delegate`에게 사용자가 이미지나 동영상을 선택했는지 말해달라고 하는 인스턴스 메소드이다. 이 안에는 `view`를 `dismiss`하는 내용이 구현되어야 한다.

                    → 만약 `picker.delegate = self` 를 지정하지 않는다면 델리게이트가 없는 상태이므로 사진을 클릭해도 사진을 선택할 수 있는 창은 dismiss 되지만 if 구문이 실행되지 않는다.  = 즉 여기서 VC는  delegate의 역할은 하지 않지만 VC로서 dismiss되는 역할은 수행하고 있다.(?)

        - **사용자 custom Delegate Pattern**
            - UIKit에서 제공하는 delegate 가 아닌 사용자가 직접 만드는 경우 `비서` 와 `비서타입` 을 직접 구현해 주어야 한다. 이후 `사장` 에게 '**너는 비서를 가지고 있어**' 라고 비서타입의 `delegate` 프로퍼티를 구현하고 프로토콜을 이용해 비서타입에 대해 정의해 주어야 한다.
            - 따라서 직접 Delegate 타입을 만드는 경우 해당 메소드를 채택한 곳에서 메소드 내부를 구현해야 한다. (혹은 extension으로 미리 구현해 두거나)

        참고 : [UIImagePickerControllerDelegate](https://www.boostcourse.org/mo326/lecture/256094/?isDesc=false) , [imagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate/1619126-imagepickercontroller)

- **델리게이션의 출발 : 기본적으로 애플이 제공하는 코드의 확장성**

     → 왜 UITextField 자체 클래스에 프로토콜 만들어서 채택하지 않았는가? 

    프로토콜에 명시된 코드를 수정할 수 없는 문제가 있기 때문(retrun, 파라미터 타입 등에  이라던가는 제네릭으로 바꿀 수 있다고 생각이 드는데 파라미터 변수라던가, 그 이름이라던가 등에 관해선 변경 불가능 하기 때문에..?)

- ***델리게이션 패턴이란?***
    1. 프로토콜문법을 통해 메소드를 구현하는 가이드라인을 제공하지만 내부 구현을 자유롭게 한다.  
    2. 메소드로 message를 전달 할 때(혹은 주고 받을 때) receiver와 sender가 decoupled 된 관계를 가지도록 한다. 
    3. 역할을 구분 한다.
    4. SOLID 원칙을 지키려고 노력하는 패턴 중 하나라고 생각한다. 
        - 이유 : 의존관계 역전 원칙에 의하면 추상화에 의존하는 형태로 가야하며 개방-폐쇄 원칙에 따라 확장에는 열려있지만 변경에는 닫혀있기 때문(함수의 이름, 파라미터이름, 리턴타입 등은 바꿀 수 없기 때문)

- ***계산기 프로젝트에서 델리게이션 패턴을 이용하려 했다면 이렇게 할 수 있지 않았을까?***
    1. 사용자가 버튼을 눌렀을 때 해당 버튼에 설정한 `tag`나 `UIButton`의 sender Value를 추가할 지 물어보는 커스텀 Delegate Protocol을 만들기 
    2.  프로젝트 기술서에서 명시했던 조건을 만족하는지 `ask`하는 Delegate method를 구현
        - 예 : `=` 를 두 번 이상 눌렀을 때 한 번 누른것과 동일한 결과가 나오도록 하는 부분
        - extension이나 해당 delegate 프로토콜을 채택하는 class or struct를 하나 만들어서 delegate 프로토콜 메소드 바디 정의
        - 해당 method가 대답을 하면(return value) 그 대답에 따라 행동이 결정

	```swift
	// 웨더 리뷰 전 
	protocol ProjectDelegate {
		func isEqaulSignAlreadyInInputStorage() -> Bool
	}

	---------------------------------------------------

	struct CalculatorDelegate: ProjectDelegate {
		func isEqaulSignAlreadyInInputStorage() -> Bool {
			if inputStrage.contains("=") [
					return true
			}
			return false
		}
	}
	// 여기서 inputStorage는 사용자가 버튼으로 입력한 값을 저장한 String array

	---------------------------------------------------

	class ViewContorller: UIViewController {
		var delegate = CalculatorDelegate()

		@IBAction func touchUpEqualButton(_ sender: UIBotton) {
			if !delegate.isEqualSignAlreadyInInputStorage {
					// inputStrage에 저장한 사용자 입력 식을 계산하는 기능 수행
			}
		}
	}
	```

	```swift
	// 웨더 리뷰 후 
	protocol ProjectDelegate: AnyObject {
		func isEqaulSignAlreadyInInputStorage() -> Bool
	}

	---------------------------------------------------

	class Calculator {
		weak var delegate: ProjectDelegate?

		func add() {
			delegate.isEqaulSignAlreadyInInputStorage() 
		// isEqaulSignAlreadyInInputStorage()의 리턴값을 add() 가 가지게됨
		}

	}
	// 여기서 inputStorage는 사용자가 버튼으로 입력한 값을 저장한 String array

	---------------------------------------------------

	class ViewContorller: UIViewController, ProjectDelegate {
		let calculator = Calculator() // 1. 계산기 인스턴스 -> add 호출 시 delegate가

		override func viewDidLoad() {
			super.viewDidLoad()	
			calculator.delegate = self // 한번만 호출하면되기때문에 viewDidLoad에서 선언
		}

		func isEqaulSignAlreadyInInputStorage() {
			if inputStrage.contains("=") [
					return true
			}
			return false
		}

		@IBAction func touchUpEqualButton(_ sender: UIBotton) {
			// 버튼 누르면 calculator 객체 만들기
			calculator.add()
		}
	}
	```


### Protocol만들고 Extension을 따로 추가하면서 구현하는 이유가 무엇일까?
- 프로토콜을 내부에 함수구현이 안되기 때문에 특정 데이터 타입(Collection, Int등) 프로토콜에 세부 method를 구현해 주고 싶을 때 extension을 사용한다.

### 프로젝트 코드에서 for loop로 구현한 것 말고 어떻게 다르게 구현할 수 있을까?
- 고차함수(map, filter, reduce 등)을 이용할 수 있을 것이다
- forEach로 구현하면 성능 차이는 없지만 컴파일 최적화 관점에서 보았을 땐 좋다고 한다. 

### 프로젝트 진행을 위해 필요한 개념
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



1. Numeric
    - `protocol Numeric`
    - A type with values that support multiplication. = 값의 증대를 surpport
    - 아래와 같이 사용할 수 있다.

    ```swift
    extension Sequence where Element: Numeric {
        func doublingAll() -> [Element] {
            return map { $0 * 2 }
        }
    }
    ```

2. `Numeric`을 읽다 나온 `Sequence`
    - element에 연속적이고 반복적인 접근을 제공하는 타입 (A type that provides sequential, iterated access to its elements.)
    - 어떠한 sequence의 요소 혹은 값에 연속적인 접근이 가능한 경우 프로토콜 Sequnce 는 여러 기능을 제공한다.
        - `sequence` : Collection 과 Range 타입 등이 이에 해당한다고 한다.
            - a list of values that you can step through one at a time.

        - `sequence` : 하나씩 접근 가능한 값,  sequence들은 Sequence 로부터 inherit되었기 때문에 for loop 를 통해 반복 하는 기능 구현하지 않아도 됨. = 1번의 코드처럼 작성하지 않는 이유.

            ```swift
            let oneTwoThree = 1...4

            for number in oneTwoThree {
            	print(number)
            }
            // for in loop 는 요소에 반복해서 접근 가능한 기능 중 하나  

            --------------------------------------------
            // 1번
            let array = ["A", "B", "C"]

            for i in array {
            	if i is "A" {
            		print("YES")
            		break
            	} else {
            		}
            }

            ----------------------------------------------
            //2번
            let array = ["A", "B", "C"]

            if arrray.contains("B") {
            	print("YES")
            } else {
            	print("No")
            }
            ```

	1. Repeated Access
	    - for in loop는 반복되는 대상이 Collection 이 아닌 경우 임의의 순서대로 진행된다.
	    - nondestructive iteration 를 위해선 반복되는 대상이  Collection protocol 에 따르도록 해야한다.
	    - consumable 이 OOP에서 가지는 [의미](https://stackoverflow.com/questions/7296674/what-is-meant-by-the-term-consumable-with-regards-to-object-orientation), ~~갑자기 궁금해서 찾아봄~~
		- 파라미터로 사용 가능한 경우
		    - 예 : 오브젝트 A가 오브젝트 B의 파라미터로 쓰일 수 있는 경우 = Object A is consumable by Object B

	2. Conforming to the Sequence Protocol
	    - 만약 custom 타입에 각 요소에 연속적이고 반복적인 접근이 필요하다면 해당 타입에 `Sequence` 프로토콜을 채택해서 `makeIteratator`()를 사용해라

		```swift
		var testArray = ["A", "B"].makeIterator()
		while let test = testArray.next() {
			print(test)
		}

		// makeInteratro 는 array의 interator의 instance를 반환한다
		// next 메소드의 경우 testArray의 다음값을 의미한다. 
		//while 루프에서 next 요소가 있을 때까지 루프를 돌린다는 의미
		```
		
	    - 만약 custom 타입에 내부에 iterate 기능을 하는 메소드가 있다면 `IteratorProtocol` 를 채택해라

	5. Expected Performance
	    - sequence  는 O(1) 을 제공하기 때문에 문서에 따로 기록되어 있지 않는 이상 sequence를 traverse하는 루틴은 O(n) 이다.
	    - Big(O) [Notation](https://www.youtube.com/watch?v=BEVnxbxBqi8&list=PL7jH19IHhOLMdHvl3KBfFI70r9P0lkJwL&index=4) : 함수 내부에서 함수를 실행하기 위해 구현된 step과 input 관계를 표기하는 방법
	    1. Constant Time, O(1)
		- 인풋에 상관없이 항상 스텝 수가 일정

		```swift
		func consTantFunc(_ input: Int...) {
			print(input)
		}
		// input에 어떤 값이 들어오더라도 (예 : 1,2,3,4,5....) 함수 내부에서
		// 이 input을 처리하는 step은 print(input) 한 스텝 뿐!
		```

	    2. O(N)

	    - 인풋이 증가하면 N배 만큼 스텝수가 증가
		- 2N, 3N 이던 항상 N 으로 표기 (이유 : 여기서 전달하고자 하는 바는 인풋이 증가하면 스텝이 증가한다는 메세지 이므로!)

		EX)  원칙적으론 2N 이라고 표현해야 하지만 1번 함수와 2번 함수의 Big O Notation은 동일하다.

		```swift
		// 1번

		func oOfN(_ input: [String]) {
			for i in input {
				print(i)
			}
		} 
		---------------------------------
		//2번

		func oOfN(_ input: [String]) {
			for i in input {
				print(i)
			}

			for i in input {
				print(i)
			}
		} 
		```

	     3. Quadratic Time,  O(n^2) 

	    - Nested Loop가 있는 경우 발생
	    - 인풋이 10개라면 필요한 단계는 10의 제곱인 100개가 됨!

		```swift
		func oOfNSquare(_ input: [String]) {
			for i in input {
				print(i)
					for i in input {
						print(i)
				}
			}
		} 
		```

	    4. Logarithmic Time

	    - Binary Search 할 때 많이 쓰임
	    - 인풋값이 증가해도 일정한 시간이 걸림
	    [https://media.springernature.com/original/springer-static/image/chp%3A10.1007%2F978-1-4842-3988-9_1/MediaObjects/465726_1_En_1_Fig1_HTML.jpg](https://media.springernature.com/original/springer-static/image/chp%3A10.1007%2F978-1-4842-3988-9_1/MediaObjects/465726_1_En_1_Fig1_HTML.jpg)

### 프로젝트 코드에서 작성한 것 중 생각하지 않고 넘어간 것을 알아보자 (ing)

- import Foundation
- @testable?
- NSNumber


### 리뷰어의 리뷰
- guard let을 단수타입체크, nil체크 용도로 사용하는 경우 flatMap을 이용해 보자
- 아래와 같이 사용해 보자!

```swift
func calculate(input: [String]) -> String {
		let notANumber = "NaN"
		
		//1번
		guard let infix = try? makeInfixExpression(from: input) else {
			return notANumber
		}
		//2번
		**let infix2 = try? makeInfixExpression(from: input).flatMap { $0 }**
		.
		.
		.
		.
	}
```





### 이번 프로젝트를 통해 내가 부족 or 필요하다고 느낀 것

1. `autolayout` - 왠지 이걸 썼어야 step3의 기능을 만족할 수 있었을 것 같다. 
2. `Naming`이 아직 어렵다 → 네이밍을 잘 할 수 있는 방법???




