//
//  FilmListView.swift
//  GhibliSwiftUIApp
//
//  Created by ThanhCong on 7/11/25.
//

import SwiftUI
struct FilmListView: View {
    
    var filmViewModel: FilmViewModel = .init()
    var body: some View {
        NavigationStack {
            switch filmViewModel.state {
            case .idle:
                Text("No Film yet")
            case .loading:
                ProgressView{
                    Text("Loading")
                }
            case .loaded(let films):
                List(films) { film in
                    NavigationLink(value : film) {
                        Text(film.title)
                    }
                }
                .navigationDestination(for: Film.self) { film in
                    FilmDetailScreen(film: film)
                }
            case .error(let error):
                Text("Error: \(error)")
                    .foregroundStyle(Color.pink)
            }
        }
        .task {
            await filmViewModel.fetch()
        }

        
    }
}
#Preview {
    
    @State @Previewable var vm  = FilmViewModel(service: MockGhibliService())
    
    FilmListView(filmViewModel: vm)
}
