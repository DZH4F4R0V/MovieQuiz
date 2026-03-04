//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by J_Eff on 01.03.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
