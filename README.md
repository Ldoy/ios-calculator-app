## iOS 커리어 스타터 캠프

### 계산기 프로젝트 저장소

- 이 저장소를 자신의 저장소로 fork하여 프로젝트를 진행합니다
---

### Flowchart

|Reader|Calculator|
|---|---|
|![image](./flowchart/reader.png)|![image](./flowchart/calculator.png)|


---

### 키워드
학습은 했으나 제대로 반영하지 못한 것은 뒤에 x표시

* Protocol
* Extension
* 자료구조와 알고리즘, 특히 Stack
* NSNumber, NSLocale, Locale (x)
* NumberFormmater (x)
* Stack View, Scroll View
* tag
* mutating
---
* XCTest
* Unit Test
* TDD
* Break Point
* Error Handling
---
* UML (x)
* POP
* OOP
* SOLID
    * SRP   단일책임 원칙
    * OCP   개방페쇄 원칙
    * LSP   리스코브 치환 원칙
    * ISP   인터페이스 분리 원칙
    * DIP   의존성 역전 원칙
* Delegate Pattern (x)
---
* 부동소수점 오류
* Postfix Expression, Infix Exrpression
---

### SOLID
고품질의 코드를 작성하는 데에 준수할 수 있는 5가지 원칙.
고품질의 코드를 작성한다는 것은, 그만큼 나의 가치가 커진다는 것이다.
코드도 재사용이 쉬워지고, 유지보수도 쉬워지고, 또 처음엔 느리더라도 나중엔 빠른 개발이 가능하다.
그만큼 나의 시간이 늘어나고, 더 공부할 수 있고, 더 발전할 수 있다.


### 𝜶: Protocol with Extension (POP)
스위프트에서 POP를 사용하게 되면, SOLID를 손쉽게 준수할 수 있다.
조금 걱정되는 것은 볼륨이 커질수록, 접근제어자를 잘 사용하지 않는다면 파악해야하는 내용이 많아질 수 있다는 점이다.


### 𝝎: Unit Test (+ TDD)
더 잘 테스트를 하기 위해서는 역시 SOLID를 잘 준수할 수 밖에 없게 된다.
또한 테스트코드를 작성함으로써 해당 코드는 신뢰할 수 있게 된다.
내가 작성한 코드를 다른 사람도 쉽게 신뢰하고 지나칠 수 있다는 것은 의사소통의 레벨부터 시작해서 아주 값진 가치이다.
TDD는 솔직히 아직 잘 와닿지 않고 테스트를 기반으로 개발을 해나간다는 것은 쉬워보이지 않지만,
꼭 TDD를 하지 않더라도 어떤 핵심 코드들의 Unit Test는 반드시 해야만 하겠다는 걸 배울 수 있었다.
