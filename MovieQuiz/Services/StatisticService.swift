//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by J_Eff on 04.03.2026.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
    }
    
    private var totalCorrectAnswers: Int {
        get {storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)}
        set {storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)}
    }
    
    var gamesCount: Int {
        get {storage.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set(newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult {
        get {
            let bestCorrect = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let bestTotal = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let bestDate = storage.object(forKey: Keys.bestGameDate.rawValue)
            
            let gameResult: GameResult = GameResult.init(correct: bestCorrect, total: bestTotal, date: bestDate as? Date ?? Date())
            
            return gameResult
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount == 0 {
            return 0
        } else {
            return (Double(totalCorrectAnswers) / Double(gamesCount * 10)) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count
        gamesCount += 1
        
        let currentGame: GameResult = GameResult(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
