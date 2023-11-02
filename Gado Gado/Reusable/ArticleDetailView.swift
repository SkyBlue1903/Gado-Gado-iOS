//
//  ArticleDetailView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 14/09/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

@MainActor
final class ArticleDetailViewModel: ObservableObject {
  @Published var favoriteArticles: [String] = []
  
  func bookmark(articleId: String, save: Bool) async throws {
    if save {
      try await AuthManager.instance.bookmarkArticle(articleId: articleId, save: save)
      favoriteArticles.removeLast()
    }
  }
}

struct ArticleDetailView: View {
  
  var data: Article?
  @State private var gameData: Game?
  @State var offset: CGFloat = 0
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @State var offsetBg: CGFloat = 0
  @State private var statusBarHeight: CGFloat = 150
  @State private var opacityLevel: Double = 0
  @State private var barHidden: Bool = false
  @State private var btnHidden: Bool = false
  @State private var scrollPosition: CGPoint = .zero
  @State private var isShareSheetPresented = false
  @StateObject private var viewModel = ArticleDetailViewModel()
  //  @Binding var saved: [Article]
  
  var headerParallax: some View {
    VStack(spacing: 15) {
      GeometryReader { proxy -> AnyView in
        
        let minY = proxy.frame(in: .global).minY
        DispatchQueue.main.async {
          self.offset = minY
          //                    print("OFFSET:", self.offset) // MARK: Disable this for debugging
        }
        return AnyView (
          ZStack(alignment: .bottom) {
            WebImage(url: URL(string: data?.image ?? ""))
              .placeholder {
                ProgressView()
              }
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: getRect().width, height: minY > 0 ? getRect().height * 0.4 + minY : getRect().height * 0.4, alignment: .center)
          }
            .frame(height: minY > 0 ? getRect().height * 0.4 + minY : nil)
            .offset(y: minY > 0 ? -minY : 0)
        )
      }
    }
    .ignoresSafeArea(.all, edges: .top)
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(alignment: .leading, spacing: 0) {
        Button {
          presentation.wrappedValue.dismiss()
        } label: {
          Circle()
            .fill(Color.white)
            .frame(width: 40)
            .overlay(Image(systemName: "chevron.left"))
            .opacity(btnHidden == true ? 0 : 1)
            .animation(.default, value: btnHidden == true ? 0 : 1)
            .padding(.top, 8)
        }
      }
      .padding(.horizontal, 16)
      .zIndex(1)
      ZStack {
        ScrollView(.vertical) {
          VStack(spacing: 0) {
            headerParallax
            VStack(alignment: .leading, spacing: 20) {
              VStack(alignment: .leading, spacing: 15) {
                Text(data?.title ?? "")
                  .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
                VStack(alignment: .leading, spacing: 5) {
                  Text("\(ExtensionManager.instance.relativeTime(from: data?.date ?? Date())) • \(data?.subtitle ?? "")")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.gray)
                    .font(.headline)
                  HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                    Text(data?.author ?? "")
                      .lineLimit(1)
                  }
                  .foregroundColor(.gray)
                }
                Text(data?.content ?? "")
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, getRect().height * 0.4)
            .padding(.bottom, getRect().height * 0.1)
            .padding(.horizontal, 16)
            
          }
          .background(GeometryReader { geometry in
            Color.clear
              .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("articleScroll")).origin)
          })
          .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            self.scrollPosition = value
            
            let minScrollPosition: CGFloat = -getRect().height * 0.4 + (statusBarHeight)
            let maxScrollPosition: CGFloat = -(getRect().height * 0.4) + (statusBarHeight)
            
            let minScrollPositionBtn: CGFloat = -getRect().height * 0.35 + (statusBarHeight)
            let maxScrollPositionBtn: CGFloat = -(getRect().height * 0.35) + (statusBarHeight)
            
            if self.scrollPosition.y < minScrollPosition {
              barHidden = false
            } else if self.scrollPosition.y > maxScrollPosition {
              barHidden = true
            }
            
            if self.scrollPosition.y < minScrollPositionBtn {
              btnHidden = true
            } else if self.scrollPosition.y > maxScrollPositionBtn {
              btnHidden = false
            }
          }
        }
        .coordinateSpace(name: "articleScroll")
        .edgesIgnoringSafeArea(.top)
        .onAppear {
          statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
          btnHidden = false
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(barHidden)
        .animation(.default, value: barHidden)
        VStack {
          Spacer()
          
          ZStack(alignment: .leading) {
            VisualEffect(colorTint: .black, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
            NavigationLink(destination: GameDetailView(data: gameData), label: {
              HStack {
                VStack(alignment: .leading, spacing: 5) {
                  Text(data?.game ?? "")
                    .lineLimit(1)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold))
                  if data?.platforms != nil {
                    PlatformIconView(platforms: data?.platforms)
                      .font(.caption)
                  }
                }
                Spacer()
                Image(systemName: "chevron.right")
              }
            })
            .foregroundColor(Color.white)
            .padding(.horizontal)
          }
          .frame(maxWidth:getRect().width - 32)
          .frame(height: 70)
          .cornerRadius(10)
          .padding(.bottom)
          .onAppear {
            Task {
              do {
                try await self.gameData = GameManager.instance.searchByTitle(data?.game ?? "")
                viewModel.favoriteArticles = try await AuthManager.instance.getBookmark()
              }
            }
          }
        }
      }
    }
  }
  
  func convertArrayToString(_ array: [String]) -> String {
    return array.joined(separator: ", ")
  }
}

struct ArticleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ArticleDetailView()
    }
  }
}
