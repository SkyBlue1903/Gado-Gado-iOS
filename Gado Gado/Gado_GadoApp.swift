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
  var body: some Scene {
    WindowGroup {
      TabView {
        TodayView()
          .tabItem {
            Label("Today", systemImage: "doc.text.image")
          }
        if isLoggedIn {
          ExperienceView()
            .tabItem {
              Label("Experience", systemImage: "dpad")
            }
        }
        BrowseView()
          .tabItem {
            Label("Browse", systemImage: "square.grid.2x2")
          }
        ProfileView()
          .tabItem {
            Label("Profile", systemImage: "person")
          }
      }
    }
  }
}
