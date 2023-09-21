//
//  Gado_GadoApp.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import Firebase

@main
struct Gado_GadoApp: App {
  
  @State private var isLoggedIn = true
  @State private var tabSelection: RootTab = .today
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  //  init() {
  //    FirebaseApp.configure()
  //    print("Firebase configured check 1")
  //  }
  
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
          RootView()
            .tabItem {
              Label("Profile", systemImage: "person")
            }
            .tag(RootTab.profile)
        }
      }
//      .accentColor(Color(.primaryApp))
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase configured! check 2")
    return true
  }
}
