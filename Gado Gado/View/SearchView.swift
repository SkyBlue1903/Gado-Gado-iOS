//
//  SearchView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 19/10/23.
//

import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
  func searchGames(_ query: String, from data: SharedData) -> [Game] {
    let filteredGames = data.allGames.filter { game in
      if let title = game.title {
        return title.lowercased().contains(query.lowercased())
      }
      return false // Return false if title is nil
    }
    return filteredGames
  }
  
  func searchArticle(_ query: String, from data: SharedData) -> [Article] {
    let filteredGames = data.allArticles.filter { game in
      if let title = game.title {
        return title.lowercased().contains(query.lowercased())
      }
      return false // Return false if title is nil
    }
    return filteredGames
  }
}



struct SearchView: View {
  @State private var search: String = ""
  @State private var show = false
  @StateObject private var viewModel = SearchViewModel()
  @StateObject var sharedData: SharedData
  @State private var segment: SearchType = .all
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16, content: {
      SearchBarView(searchText: $search, onCommit: {
        print("Submit")
      })
      Picker("Search Segment", selection: $segment){
        Text("All")
          .tag(SearchType.all)
        Text("Games")
          .tag(SearchType.games)
        Text("Articles")
          .tag(SearchType.articles)
      }
      .padding(.horizontal)
      .pickerStyle(.segmented)
      List {
        if segment == .all {
          ForEach(viewModel.searchArticle(self.search, from: sharedData), id: \.self) { article in
            NavigationLink(destination: ArticleDetailView(data: article)) {
              VStack(alignment: .leading) {
                Text(article.title ?? "")
                  .lineLimit(1)
                Text("Article")
                  .font(.caption)
                  .foregroundColor(Color.gray)
              }
            }
          }
          ForEach(viewModel.searchGames(self.search, from: sharedData), id: \.self) { game in
            NavigationLink(destination: GameDetailView(data: game)) {
              VStack(alignment: .leading) {
                Text(game.title ?? "")
                  .lineLimit(1)
                Text("Game")
                  .font(.caption)
                  .foregroundColor(Color.gray)
              }
            }
          }
        } else if segment == .articles {
          ForEach(viewModel.searchArticle(self.search, from: sharedData), id: \.self) { article in
            NavigationLink(destination: ArticleDetailView(data: article)) {
              VStack(alignment: .leading) {
                Text(article.title ?? "")
                  .lineLimit(1)
                Text("Article")
                  .font(.caption)
                  .foregroundColor(Color.gray)
              }
            }
          }
        } else if segment == .games {
          ForEach(viewModel.searchGames(self.search, from: sharedData), id: \.self) { game in
            NavigationLink(destination: GameDetailView(data: game)) {
              VStack(alignment: .leading) {
                Text(game.title ?? "")
                  .lineLimit(1)
                Text("Game")
                  .font(.caption)
                  .foregroundColor(Color.gray)
              }
            }
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Search")
    })
    .padding(.top)
  }
}

#Preview {
  NavigationView {
    SearchView(sharedData: SharedData())
  }
}

