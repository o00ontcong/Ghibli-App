//
//  FilmDetailScreen.swift
//  GhibliSwiftUIApp
//
//  Created by ThanhCong on 8/11/25.
//
import SwiftUI
struct FilmDetailScreen: View {
    let film: Film
    
    @State private var viewModel = FilmDetailViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: film.bannerImage))
            Text(film.title)
            Divider()
            Text("Character")
                .font(.title3)
            switch viewModel.state {
            case .idle:
                Text("No Film yet")
            case .loading:
                ProgressView{
                    Text("Loading")
                }
            case .loaded(let people):
                ForEach(people){ person in
                    Text(person.name)
                }
            case .error(let error):
                Text("Error: \(error)")
                    .foregroundStyle(Color.pink)
            }
        }
        .padding()
        .task(id: film) {
            print("Doing task: \(viewModel.state)")
            await viewModel.fetch(for: film)
            print("Doing task: \(viewModel.state)")
        }
    }
}

import Playgrounds

#Preview  {
    FilmDetailScreen(film: Film.example)
}
