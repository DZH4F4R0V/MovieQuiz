//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by J_Eff on 22.03.2026.
//

import Testing
import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            handler(num1 + num2)
        }
    }
    
    func substraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

struct MovieQuizTests {
    
    @Test func addition()  {
        //Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        //Then
        #expect(result == 4)
    }

}
