import Foundation

struct Stack<T> {
    private var storedValue: [T] = []
    
    func peek() -> T? {
        guard let peekedValue = self.storedValue.last else {
            return nil
        }
        
        return peekedValue
    }
    
    mutating func pop() -> T? {
        guard let popedValue = self.storedValue.popLast() else {
            return nil
        }
        
        return popedValue
    }
    
    mutating func push(element: T){
        self.storedValue.append(element)
    }
}
