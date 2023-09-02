//
//  GameDetailView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 22/08/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

struct GameDetailView: View {
  
  var currentGame: Game?
  
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
  
  var headerParallax: some View {
    VStack(spacing: 15) {
      GeometryReader { proxy -> AnyView in
        
        let minY = proxy.frame(in: .global).minY
        DispatchQueue.main.async {
          self.offset = minY
          //          print("OFFSET:", self.offset) // MARK: Disable this for debugging
        }
        return AnyView (
          ZStack(alignment: .bottom) {
            WebImage(url: URL(string: "\(currentGame?.image ?? "")"))
              .placeholder {
                // Placeholder Image View
                Image("sample-header") // Replace with the name of your placeholder image asset
                  .resizable()
              }
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: getRect().width, height: minY > 0 ? getRect().height * 0.4 + minY : getRect().height * 0.4, alignment: .center)
            Group {
              VisualEffect(colorTint: .black, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
              HStack {
                VStack(alignment: .leading, spacing: 5) {
                  Text("\(currentGame?.title ?? "")")
                    .lineLimit(1)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold))
                  PlatformIconView(platforms: currentGame?.platforms)
                  .font(.caption)
                }
                Spacer()
                Button {
                  isShareSheetPresented.toggle()
                } label: {
                  Image(systemName: "square.and.arrow.up")
                }
              }
              .foregroundColor(Color.white)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal)
            }
            .frame(maxWidth:getRect().width - 32)
            .frame(height: 70)
            .cornerRadius(10)
            .offset(y: -16)
          }
            .frame(height: minY > 0 ? getRect().height * 0.4 + minY : nil)
            .offset(y: minY > 0 ? -minY : 0)
        )
      }
    }
    .ignoresSafeArea(.all, edges: .top)
  }
  
  var body: some View {
    //    NavigationView {
    GeometryReader { geometry in
      VStack(alignment: .leading, spacing: 0) {
        Button {
          presentation.wrappedValue.dismiss()
        } label: {
          Circle()
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.075)
            .overlay(Image(systemName: "chevron.left"))
            .foregroundColor(Color(.primaryApp))
            .opacity(btnHidden == true ? 0 : 1)
            .animation(.default, value: btnHidden == true ? 0 : 1)
            .padding(.top, 8)
        }
        
      }
      //      .frame(height: getRect().height * 0.1)
      //      .frame(maxWidth: getRect().width, alignment: .leading)
      .padding(.horizontal, 16)
      .zIndex(1)
      //        .background(.thickMaterial)
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          headerParallax
          VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 5) {
              Text("Overview")
                .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
              Text("\(currentGame?.desc ?? "No description")")
            }
            VStack(alignment: .leading, spacing: 5) {
              Text("Information")
                .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
              Divider()
              Group {
                DisclosureGroup("Developer") {
                  Text("\(currentGame?.developer ?? "No information")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                DisclosureGroup("Genre") {
                  Text(convertArrayToString(currentGame?.genres ?? ["No information"]))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                DisclosureGroup("Engine") {
                  Text(convertArrayToString(currentGame?.engines ?? ["No information"]))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                HStack {
                  Link("Developer Website", destination: URL(string: "\(currentGame?.urlSite ?? "https://google.com")")!)
                    .padding(.vertical, 6)
                  Spacer()
                  Image(systemName: "safari")
                }
                .foregroundColor(Color.accentColor)
                
                Divider()
              }
              .foregroundColor(colorScheme == .light ? Color.black : Color.white)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, getRect().height * 0.4)
          .padding(.bottom, getRect().height * 0.1)
          .padding(.horizontal, 16)
          
        }
        .background(GeometryReader { geometry in
          Color.clear
            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
        })
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
          self.scrollPosition = value
          
          let minScrollPosition: CGFloat = -getRect().height * 0.4 + (statusBarHeight + 44)
          let maxScrollPosition: CGFloat = -(getRect().height * 0.4) + (statusBarHeight + 44)
          
          let minScrollPositionBtn: CGFloat = -getRect().height * 0.25 + (statusBarHeight + 44)
          let maxScrollPositionBtn: CGFloat = -(getRect().height * 0.25) + (statusBarHeight + 44)
          
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
      .coordinateSpace(name: "scroll")
      .edgesIgnoringSafeArea(.top)
      .onAppear {
        statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
        btnHidden = false
      }
      .sheet(isPresented: $isShareSheetPresented, content: {
        TextShareSheetView(activityItems: ["Hey there! I've got some epic news for you – this incredible game called \"\(currentGame?.title ?? "")\" that's totally awesome! And guess what? It's available on \(convertArrayToString(currentGame?.platforms ?? ["some"])) platforms. Time to level up this  \(convertArrayToString(currentGame?.genres ?? ["action"])), so what are you waiting for?"])
      })
      .navigationTitle("Cities Skylines")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isShareSheetPresented.toggle()
          } label: {
            Image(systemName: "square.and.arrow.up")
          }
        }
      }
      .navigationBarHidden(barHidden)
      .animation(.default, value: barHidden)
    }
  }
  
  func actionSheet() {
    guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
    let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
  }
  
  func convertArrayToString(_ array: [String]) -> String {
    return array.joined(separator: ", ")
  }
  
}

struct GameDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GameDetailView(currentGame: Game(id: "123", title: "Cities Skylines II", urlSite: "https://www.paradoxinteractive.com", image: "sample-header", imageFilename: "123", date: Date(), genres: ["Simulation", "Strategy"], platforms: ["Xbox", "PS5", "Windows"], developer: "Paradox Interactive", desc: "Raise a city from the ground up and transform it into a thriving metropolis with the most realistic city builder ever. Push your creativity and problem-solving to build on a scale you've never experienced. With deep simulation and a living economy, this is world-building without limits.\n\n You Make It Happen. You Make It Yours. You Make Cities. Raise a city from the ground up and transform it into a thriving metropolis with the most realistic city builder ever. Push your creativity and problem-solving to build on a scale you've never experienced. With deep simulation and a living economy, this is world-building without limits.\n\n You Make It Happen. You Make It Yours. You Make Cities. ", engines: ["Unreal Engine 5"]))
    }
  }
}
