//
//  FilmViewModel.swift
//  GhibliSwiftUIApp
//
//  Created by ThanhCong on 7/11/25.
//

import Foundation
import Observation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decoding(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .decoding(let e): return "Decoding Error: \(e.localizedDescription)"
        case .networkError(let e): return "Network Error: \(e.localizedDescription)"
        }
    }

}

@Observable
class FilmViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Film])
        case error(String)
    }
    
    var state: State = .idle
    var films: [Film] = []
    private let service: GhibliService
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    func fetch() async {
        
        guard state == .idle else { return }
        
        state = .loading
        do {
            let films = try await self.service.fetchFilms()
            self.state = .loaded(films)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
}
