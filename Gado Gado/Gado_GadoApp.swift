//
//  Gado_GadoApp.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import Firebase

class SharedData: ObservableObject {
  @Published var allGames = [Game]()
  @Published var allArticles = [Article]()
  
  func initial(games: [Game], articles: [Article]) async {
    DispatchQueue.main.async {
      self.allGames = games
      self.allArticles = articles
    }
  }
}

@main
struct Gado_GadoApp: App {
  @State private var isLoggedIn = true
  @State private var tabSelection: RootTab = .today
  @StateObject private var sharedData = SharedData()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      NavigationView {
        TabView(selection: $tabSelection) {
          TodayView()
            .tabItem {
              Label("Today", systemImage: "doc.text.image")
            }
            .tag(RootTab.today)
          if isLoggedIn {
            ExperienceView()
              .tabItem {
                Label("Experience", systemImage: "dpad")
              }
              .tag(RootTab.experience)
          }
          SearchView(sharedData: sharedData)
            .tabItem {
              Label("Search", systemImage: "magnifyingglass")
            }
            .tag(RootTab.search)
          RootView()
            .tabItem {
              Label("Profile", systemImage: "person")
            }
            .tag(RootTab.profile)
        }
        .navigationTitle(tabSelection == .experience ? "Experience" : tabSelection == .search ? "Search" : "")
        .navigationBarTitleDisplayMode(.inline)
      }
      .environmentObject(sharedData)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase configured!")
    return true
  }
}
