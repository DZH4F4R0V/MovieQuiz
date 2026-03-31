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
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        sleep(10)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(10)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testIndexLabel() {
        sleep(10)
        
        app.buttons["Yes"].tap()
        
        let indexLabel = app.staticTexts["Index"]
        let QuestionIndexLabel = indexLabel.label
        
        XCTAssertEqual(QuestionIndexLabel, "2/10")
    }
    
    func testNoButton() {
        sleep(10)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(10)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertShowed() {
        sleep(3)
        for _ in 0..<11 {
            app.buttons["Yes"].tap()
            
            sleep(3)
        }
        
        let alertShown = app.alerts["Раунд окончен"]
        XCTAssertTrue(alertShown.exists)
        
        XCTAssertEqual(alertShown.label, "Раунд окончен")
        XCTAssertEqual(alertShown.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        for _ in 0..<11 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alertShown = app.alerts["Раунд окончен"]
        alertShown.buttons.firstMatch.tap()
        
        sleep(3)
        
        let index = app.staticTexts["Index"]
        
        XCTAssertFalse(alertShown.exists)
        XCTAssertEqual(index.label, "1/10")
    }
}
