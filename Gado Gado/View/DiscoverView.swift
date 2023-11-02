//
//  BrowseView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

struct DiscoverView: View {
  
  @State private var scrollPosition: CGPoint = .zero
  @State private var opacityLevel: Double = 0
  @State private var search: String = ""
  @Environment(\.colorScheme) var colorScheme
  @State private var statusBarHeight: CGFloat = 0
  @State private var showDetail: Bool = false
  
  @State private var carousel = [Game]()
  @State private var windowsGames = [Game]()
  @State private var androidGames = [Game]()
  @State private var html5Games = [Game]()
  
  var body: some View {
    GeometryReader { geometry in
      VisualEffect(colorTint: colorScheme == .dark ? .black : .white, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
        .frame(height: statusBarHeight)
        .offset(y: min(-statusBarHeight, 0))
        .zIndex(10)
        .opacity(opacityLevel)
      ScrollView {
        VStack(spacing: 0) {
          ZStack {
            DiscoverCarouselView(items: carousel)
              .frame(width: getRect().width, height: getRect().height * 0.5)
            Text("Discover")
              .foregroundColor(Color.white)
              .padding(.leading)
              .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
              .frame(maxWidth: getRect().width, alignment: .leading)
              .frame(height: getRect().height * 0.325, alignment: .top) // MARK: Needs responsive for smaller iPhones
          }
//          Group {
//            //// Add Category here (by VStack)
//            VStack {
//              HStack {
//                Text("Windows")
//                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//                Spacer()
//                NavigationLink(destination: DiscoverPlatformView(platform: "Windows", allGames: windowsGames)) {
//                  Text("See All")
//                    .font(.body)
//                }
//              }
//              .frame(maxWidth: .infinity, alignment: .leading)
//              .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//              ForEach(windowsGames.prefix(3), id: \.self) { each in
//                NavigationLink(destination: GameDetailView(currentGame: each)) {
//                  HStack {
//                    WebImage(url: URL(string: each.image ?? ""))
//                      .resizable()
//                      .placeholder {
//                        ZStack {
//                          Color.gray
//                            .opacity(0.2)
//                          ProgressView()
//                        }
//                        .frame(width: 90, height: 90)
//                      }
//                      .scaledToFill()
//                      .frame(width: 90, height: 90)
//                      .clipped()
//                      .cornerRadius(10)
//                    VStack(alignment: .leading, spacing: 0) {
//                      Text(each.title ?? "")
//                        .lineLimit(1)
//                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
//                      Text(ExtensionManager.instance.relativeTime(from: each.date ?? Date()))
//                        .lineLimit(1)
//                        .foregroundColor(Color.gray.opacity(0.5))
//                        .font(.caption)
//                    }
//                  }
//                  .frame(maxWidth: .infinity, alignment: .leading)
//                  .frame(height:100)
//                } // MARK: Needs responsive for smaller iPhones
//                Divider()
//              }
//              
//              
//              /// ** ANOTHER CONTENT
//            }
//            VStack {
//              HStack {
//                Text("Android")
//                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//                Spacer()
//                NavigationLink(destination: DiscoverPlatformView(platform: "Android", allGames: androidGames)) {
//                  Text("See All")
//                    .font(.body)
//                }
//              }
//              .frame(maxWidth: .infinity, alignment: .leading)
//              .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//              ForEach(androidGames.prefix(3), id: \.self) { each in
//                NavigationLink(destination: GameDetailView(currentGame: each)) {
//                  HStack {
//                    WebImage(url: URL(string: each.image ?? ""))
//                      .resizable()
//                      .placeholder {
//                        ZStack {
//                          Color.gray
//                            .opacity(0.2)
//                          ProgressView()
//                        }
//                        .frame(width: 90, height: 90)
//                      }
//                      .scaledToFill()
//                      .frame(width: 90, height: 90)
//                      .clipped()
//                      .cornerRadius(10)
//                    VStack(alignment: .leading, spacing: 0) {
//                      Text(each.title ?? "")
//                        .lineLimit(1)
//                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
//                      Text(ExtensionManager.instance.relativeTime(from: each.date ?? Date()))
//                        .lineLimit(1)
//                        .foregroundColor(Color.gray.opacity(0.5))
//                        .font(.caption)
//                    }
//                  }
//                  .frame(maxWidth: .infinity, alignment: .leading)
//                  .frame(height:100)
//                } // MARK: Needs responsive for smaller iPhones
//                Divider()
//              }
//              
//              
//              /// ** ANOTHER CONTENT
//            }
//            VStack {
//              HStack {
//                Text("HTML 5")
//                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//                Spacer()
//                NavigationLink(destination: DiscoverPlatformView(platform: "HTML 5", allGames: html5Games)) {
//                  Text("See All")
//                    .font(.body)
//                }
//              }
//              .frame(maxWidth: .infinity, alignment: .leading)
//              .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
//              ForEach(html5Games.prefix(3), id: \.self) { each in
//                NavigationLink(destination: GameDetailView(currentGame: each)) {
//                  HStack {
//                    WebImage(url: URL(string: each.image ?? ""))
//                      .resizable()
//                      .placeholder {
//                        ZStack {
//                          Color.gray
//                            .opacity(0.2)
//                          ProgressView()
//                        }
//                        .frame(width: 90, height: 90)
//                      }
//                      .scaledToFill()
//                      .frame(width: 90, height: 90)
//                      .clipped()
//                      .cornerRadius(10)
//                    VStack(alignment: .leading, spacing: 0) {
//                      Text(each.title ?? "")
//                        .lineLimit(1)
//                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
//                      Text(ExtensionManager.instance.relativeTime(from: each.date ?? Date()))
//                        .lineLimit(1)
//                        .foregroundColor(Color.gray.opacity(0.5))
//                        .font(.caption)
//                    }
//                  }
//                  .frame(maxWidth: .infinity, alignment: .leading)
//                  .frame(height:100)
//                } // MARK: Needs responsive for smaller iPhones
//                Divider()
//              }
//              
//              
//              /// ** ANOTHER CONTENT
//            }
//            /// end category here
//          }
//          .padding(.horizontal)
//          .padding(.top, getRect().height * 0.05)
        }
        .background(GeometryReader { geometry in
          Color.clear
            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
        })
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
          self.scrollPosition = value
          
          let minScrollPosition: CGFloat = -getRect().height * 0.5 + statusBarHeight
          let maxScrollPosition: CGFloat = -(getRect().height * 0.5) + statusBarHeight + 50
          
          if self.scrollPosition.y < minScrollPosition {
            opacityLevel = 1
          } else if self.scrollPosition.y > maxScrollPosition {
            opacityLevel = 0
          } else {
            let opacityRange = minScrollPosition - maxScrollPosition
            let positionWithinRange = self.scrollPosition.y - maxScrollPosition
            opacityLevel = Double(positionWithinRange / opacityRange)
          }
        }
      }
      .coordinateSpace(name: "scroll")
      .edgesIgnoringSafeArea(.top)
      .onAppear {
        statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
        Task {
            let windows = try await GameManager.instance.discoverByPlatform("Windows")
          let android = try await GameManager.instance.discoverByPlatform("Android")
          let html5 = try await GameManager.instance.discoverByPlatform("HTML 5")
          DispatchQueue.main.async {
            self.windowsGames = windows
            self.androidGames = android
            self.html5Games = html5
            
            let item1 = ExtensionManager.instance.randomArray(windows, count: Int.random(in: 1...3))
            let item2 = ExtensionManager.instance.randomArray(android, count: Int.random(in: 1...3))
            let item3 = ExtensionManager.instance.randomArray(html5, count: 1)
            self.carousel = item1 + item2 + item3
          }
        }
      }
    }
  }
}

struct DiscoverView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DiscoverView()
    }
  }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
  }
}
