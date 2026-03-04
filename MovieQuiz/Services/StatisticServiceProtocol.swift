//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by J_Eff on 03.03.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}

