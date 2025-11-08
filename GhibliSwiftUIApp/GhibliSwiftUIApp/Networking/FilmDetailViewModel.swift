//
//  FilmDetailViewModel.swift
//  GhibliSwiftUIApp
//
//  Created by ThanhCong on 7/11/25.
//

import  Foundation
import Observation
@Observable
class FilmDetailViewModel {
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([Person])
        case error(String)
    }
    var state  : State = .idle
    var people: [Person] = []
    
    private let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film) async{
        guard self.state != .loading else { return }
        self.state = .loading
        print("Doing task: \(state)")

        var loadedPeople :[Person] = []
        do {
            try await withThrowingTaskGroup(of: Person.self) { group in
                for personInfoURL in film.people {
                    group.addTask {
                        return try await self.service.fetchPerson(from: personInfoURL)
                    }
                }
                
                for try await person in group {
                    loadedPeople.append(person)
                }
            }
            
            state = .loaded(loadedPeople)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
        
    }
}

import Playgrounds
#Playground {
    let vm = FilmDetailViewModel()
    
    let film = MockGhibliService().fetchFilm()
    await vm.fetch(for: film)
    
    switch vm.state {
    case .idle: print("idle")
    case .loading: print("loading")
    case .loaded(let people):
        print(people.count)
    case .error( let error ):
        print("Error: \(error)")
    }
    
}
