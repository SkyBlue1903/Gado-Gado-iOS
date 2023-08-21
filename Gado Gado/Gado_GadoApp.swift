//
//  Gado_GadoApp.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI


@main
struct Gado_GadoApp: App {
  
  @State private var isLoggedIn = false
  @State private var tabSelection: RootTab = .today
  
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
          DiscoverView()
            .tabItem {
              Label("Discover", systemImage: "safari")
            }
            .tag(RootTab.discover)
          ProfileView()
            .tabItem {
              Label("Profile", systemImage: "person")
            }
            .tag(RootTab.profile)
        }
        .accentColor(Color(hex: "#7DCE13"))
      }
    }
  }
}
