//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by J_Eff on 28.03.2026.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTest {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 20]
        //Then
        XCTAssertNil(value)
    }
}
