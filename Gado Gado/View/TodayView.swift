//
//  ContentView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

struct TodayView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var statusBarHeight: CGFloat = 0
  @State private var currentDate: String = ""
  @State private var selectedSegment: Int = 0
  
  @State private var allGames = [Game]()
  @State private var allArticles: [Article] = []
  @State private var segmentHeight: CGFloat = 0
  @State private var vstackHeight: CGFloat = 0.0
  @State var savedArticles: [Article] = []
  
  var body: some View {
    GeometryReader { geometry in
      Rectangle()
        .fill(colorScheme == .light ? Color.white : Color.black)
        .frame(height: statusBarHeight + vstackHeight)
        .offset(y: min(-statusBarHeight, 0))
        .zIndex(1)
      VStack(alignment: .leading, spacing: 0) {
        Text(currentDate.uppercased())
          .font(.footnote)
          .foregroundColor(.gray)
          .fontWeight(.medium)
        Text("Today")
          .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
        Picker("Today Segment", selection: $selectedSegment) {
          Text("All Games")
            .tag(0)
          Text("All Articles")
            .tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.top, 15)
      }
      .zIndex(2)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal)
      .padding(.bottom, -1)
      .padding(.top, 20)
      .background(
        GeometryReader { innerGeometry in
          Color.clear.onAppear {
            vstackHeight = innerGeometry.size.height + 10
          }
        }
      )
//        .foregroundColor(colorScheme == .dark ? .black : .white)
//      NavigationView {
        ScrollView(.vertical) {
          if selectedSegment == 0 {
            ForEach(allGames, id: \.self) { game in
              TodayGameView(data: game)
            }
            .padding([.bottom, .horizontal])
          } else if selectedSegment == 1 {
            ForEach(allArticles, id: \.self) { article in
              TodayArticleView(data: article)
            }
            .padding([.bottom, .horizontal])
          }
        }
//        .onChange(of: savedArticles, { oldValue, newValue in
//          print("""
//Old value: \(oldValue)
//New value: \(newValue)
//\n
//""")
//        })
        .padding(.top, vstackHeight)
        .onAppear {
          statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
          
          let currentDate = Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let day = dateFormatter.string(from: currentDate)
          dateFormatter.dateFormat = "dd"
          let date = dateFormatter.string(from: currentDate)
          dateFormatter.dateFormat = "MMMM"
          let month = dateFormatter.string(from: currentDate)
          self.currentDate = "\(day), \(date) \(month)"
          
          Task {
            let games = try await GameManager.instance.getGamesCollection()
            let articles = try await ArticleManager.instance.getArticlesCollection()
            DispatchQueue.main.async {
              allGames = games
              allArticles = articles
            }
//            self.savedArticles = try await  
          }
        }
//      }
    }
  }
  
  
}

struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TodayView()
    }
  }
}




