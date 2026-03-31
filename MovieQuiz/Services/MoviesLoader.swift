//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by J_Eff on 21.03.2026.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(useMock: Bool, handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        
        return url
    }
    
    func loadMovies(useMock: Bool = false, handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        if useMock {
            loadMockMovies(handler: handler)
            return
        }
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let moviesList = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(moviesList))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func loadMockMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "mockData", withExtension: "json") else {
            handler(.failure(NSError(domain: "mock", code: 0)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let moviesList = try JSONDecoder().decode(MostPopularMovies.self, from: data)
            handler(.success(moviesList))
        } catch {
            handler(.failure(error))
        }
    }
}
