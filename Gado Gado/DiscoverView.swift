//
//  BrowseView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import SwiftlySearch
import VisualEffectView

struct DiscoverView: View {
  
  @State private var scrollPosition: CGPoint = .zero
  @State private var opacityLevel: Double = 0
  @State private var search: String = ""
  @Environment(\.colorScheme) var colorScheme
  @State private var statusBarHeight: CGFloat = 0
  @State private var showDetail: Bool = false
  
  var body: some View {
    //    NavigationView {
    GeometryReader { geometry in
      VisualEffect(colorTint: colorScheme == .dark ? .black : .white, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
        .frame(height: statusBarHeight)
        .offset(y: min(-statusBarHeight, 0))
        .zIndex(10)
        .opacity(opacityLevel)
//        .background(.thickMaterial)
      ScrollView {
        VStack(spacing: 0) {
          ZStack {
            DiscoverCarouselView()
              .frame(width: getRect().width, height: getRect().height * 0.5)
            Text("Discover")
              .foregroundColor(Color.white)
              .padding(.leading)
              .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
              .frame(maxWidth: getRect().width, alignment: .leading)
              .frame(height: getRect().height * 0.325, alignment: .top) // MARK: Needs responsive for smaller iPhones
          }
          
          Group {
            //// Add Category here (by VStack)
            VStack {
              HStack {
                Text("HTML 5")
                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
                Spacer()
                NavigationLink(destination: EmptyView()) {
                  Text("See All")
                    .font(.body)
                }
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
              ForEach(1...3, id: \.self) { each in
                NavigationLink(destination: Text("Hii Iam inside")) {
                  HStack {
                    Image("sample-header")
                      .resizable()
                      .frame(width: 90, height: 90)
                      .scaledToFill()
                      .cornerRadius(10)
                    VStack(alignment: .leading, spacing: 0) {
                      Text("Lorem ipsum lorem ipsum lorem ipsum lorem ipsum")
                        .lineLimit(1)
                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                      Text("a month ago")
                        .lineLimit(1)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .font(.caption)
                    }
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .frame(height:100)
                } // MARK: Needs responsive for smaller iPhones
                Divider()
              }
              
              
              /// ** ANOTHER CONTENT
            }
            VStack {
              HStack {
                Text("HTML 5")
                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
                Spacer()
                NavigationLink(destination: EmptyView()) {
                  Text("See All")
                    .font(.body)
                }
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
              ForEach(1...3, id: \.self) { each in
                NavigationLink(destination: Text("Hii Iam inside")) {
                  HStack {
                    Image("sample-header")
                      .resizable()
                      .frame(width: 90, height: 90)
                      .scaledToFill()
                      .cornerRadius(10)
                    VStack(alignment: .leading, spacing: 0) {
                      Text("Lorem ipsum lorem ipsum lorem ipsum lorem ipsum")
                        .lineLimit(1)
                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                      Text("a month ago")
                        .lineLimit(1)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .font(.caption)
                    }
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .frame(height:100)
                } // MARK: Needs responsive for smaller iPhones
                Divider()
              }
              
              
              /// ** ANOTHER CONTENT
            }
          }
          .padding(.horizontal)
          .padding(.top, getRect().height * 0.05)
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
        .onChange(of: self.scrollPosition) { newValue in
          
        }
      }
      .coordinateSpace(name: "scroll")
      .edgesIgnoringSafeArea(.top)
      .onAppear {
        statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
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
