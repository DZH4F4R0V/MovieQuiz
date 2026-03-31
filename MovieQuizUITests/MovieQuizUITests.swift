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
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Раунд окончен"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Раунд окончен")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Раунд окончен"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
//
