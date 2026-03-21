//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by J_Eff on 01.03.2026.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
