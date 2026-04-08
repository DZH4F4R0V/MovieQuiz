//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by J_Eff on 29.03.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        
        app.launchArguments = ["-ui-testing"]
        
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }
    
    private func waitForFirstQuestion() {
        let indexLabel = app.staticTexts["Index"]
        _ = indexLabel.waitForExistence(timeout: 10)
    }
    
    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        waitForFirstQuestion()
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        let indexLabel = app.staticTexts["Index"]
        let predicate = NSPredicate(format: "label == '2/10'")
        expectation(for: predicate, evaluatedWith: indexLabel, handler: nil)
        waitForExpectations(timeout: 10)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testIndexLabel() {
        let indexLabel = app.staticTexts["Index"]
        _ = indexLabel.waitForExistence(timeout: 10)
        
        app.buttons["Yes"].tap()
        
        let predicate = NSPredicate(format: "label == '2/10'")
        expectation(for: predicate, evaluatedWith: indexLabel, handler: nil)
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        waitForFirstQuestion()
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        let indexLabel = app.staticTexts["Index"]
        let predicate = NSPredicate(format: "label == '2/10'")
        expectation(for: predicate, evaluatedWith: indexLabel, handler: nil)
        waitForExpectations(timeout: 5)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertShowed() {
        waitForFirstQuestion()
        
        let indexLabel = app.staticTexts["Index"]
        
        for i in 1...10 {
            app.buttons["Yes"].tap()
            
            let nextIndex = i == 10 ? "10/10" : "\(i+1)/10"
            let predicate = NSPredicate(format: "label == %@", nextIndex)
            let expectation = XCTNSPredicateExpectation(predicate: predicate, object: indexLabel)
            XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
        }
        
        let alert = app.alerts["Раунд окончен"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.label == "Раунд окончен")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        waitForFirstQuestion()
        
        let indexLabel = app.staticTexts["Index"]
        
        for i in 1...10 {
            app.buttons["No"].tap()
            
            let nextIndex = i == 10 ? "10/10" : "\(i+1)/10"
            let predicate = NSPredicate(format: "label == %@", nextIndex)
            let expectation = XCTNSPredicateExpectation(predicate: predicate, object: indexLabel)
            XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
        }
        
        let alert = app.alerts["Раунд окончен"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        alert.buttons.firstMatch.tap()
        
        let alertVanished = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: alert
        )
        let indexReset = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "label == '1/10'"),
            object: indexLabel
        )
        
        XCTAssertEqual(XCTWaiter.wait(for: [alertVanished, indexReset], timeout: 5), .completed)
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
//
