//
//  GameDetailView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 22/08/23.
//

import SwiftUI
import VisualEffectView

struct GameDetailView: View {
  
  @State var offset: CGFloat = 0
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @State var offsetBg: CGFloat = 0
  @State private var statusBarHeight: CGFloat = 150
  @State private var opacityLevel: Double = 0
  @State private var barHidden: Bool = false
  @State private var btnHidden: Bool = false
  @State private var scrollPosition: CGPoint = .zero
  
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
            Image("sample-header")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: getRect().width, height: minY > 0 ? getRect().height * 0.4 + minY : getRect().height * 0.4, alignment: .center)
            Group {
              VisualEffect(colorTint: .black, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
              HStack {
                VStack(alignment: .leading, spacing: 5) {
                  Text("Cities Skylines")
                    .lineLimit(1)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold))
                  HStack {
                    Image(systemName: "xbox.logo")
                    Image(systemName: "playstation.logo")
                    Image(systemName: "network")
                  }
                  .font(.caption)
                }
                Spacer()
                Button {
                  actionSheet()
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
            .fill(colorScheme == .light ? Color.white : Color.black)
            .frame(width: UIScreen.main.bounds.width * 0.1)
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
              Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam hendrerit tristique lectus, sit amet imperdiet purus fringilla ut. Sed volutpat augue id arcu tincidunt hendrerit. Vivamus non libero vel dui bibendum euismod. Integer lacinia tortor nec odio suscipit, nec congue odio malesuada. Nunc non dui ac nisl convallis hendrerit. Fusce in congue nulla, non sagittis urna. Nunc finibus mi quis lectus vehicula interdum. Vivamus euismod dui vitae libero consectetur, ac tincidunt ante tincidunt. Ut volutpat facilisis justo, non elementum purus gravida a. Fusce malesuada, lorem nec varius lacinia, arcu dui tincidunt ex, et varius risus arcu at sem. Integer sit amet vehicula turpis. Etiam sed odio nec urna tristique iaculis. Nulla facilisi. Suspendisse ultrices lorem at ex auctor, ut congue tortor gravida. Sed vestibulum nulla a lectus feugiat, eget interdum justo vulputate. Pellentesque in ex ut nunc dignissim elementum. Maecenas ac leo tristique, volutpat dui in, lacinia orci. In hac habitasse platea dictumst. Nulla facilisi. Praesent tincidunt libero vel cursus feugiat. Curabitur euismod justo nec lectus tincidunt, et egestas odio faucibus. Proin auctor quam in augue luctus, nec dapibus turpis convallis. Sed bibendum tortor vitae lacinia dapibus.")
            }
            VStack(alignment: .leading, spacing: 5) {
              Text("Information")
                .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
              Divider()
              Group {
                DisclosureGroup("Developer") {
                  Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
                }
                Divider()
                DisclosureGroup("Genre") {
                  Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
                }
                Divider()
                DisclosureGroup("Engine") {
                  Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
                }
                Divider()
                Button {
                  
                } label: {
                  HStack {
                    Text("Developer Website")
                      .padding(.vertical, 6)
                    Spacer()
                    Image(systemName: "safari")
                  }
                  .foregroundColor(Color.accentColor)
                }
                Divider()
              }
              .foregroundColor(Color.black)
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
          print("SCROLL VALUE:", self.scrollPosition)
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
      .navigationTitle("Cities Skylines")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            actionSheet()
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

}

struct GameDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GameDetailView()
    }
  }
}
