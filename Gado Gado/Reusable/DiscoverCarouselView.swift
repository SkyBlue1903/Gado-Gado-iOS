//
//  DiscoverCarouselView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 17/08/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

struct DiscoverCarouselView: View {
  
  @State private var index: Int = 0
  @State private var showDetail: Bool = false
  var items: [Game]
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      TabView(selection: $index) {
        ForEach(items.indices, id: \.self) { each in
          ZStack {
            Color.gray
              .opacity(0.2)
            ProgressView()
            WebImage(url: URL(string: items[each].image ?? ""))
              .resizable()
              .scaledToFill()
              .clipped()
            ZStack(alignment: .leading) {
              VisualEffect(colorTint: .black, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
              NavigationLink(destination: GameDetailView(currentGame: items[each]), label: {
                HStack {
                  VStack(alignment: .leading, spacing: 5) {
                    Text(items[each].title ?? "")
                      .lineLimit(1)
                      .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold))
                    if items[each].platforms != nil {
                      PlatformIconView(platforms: items[each].platforms)
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
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: -getRect().height * 0.04)
          }
          .frame(width: getRect().width)
        }
      }
      .tabViewStyle(.page)
    }
  }
}

struct DiscoverCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DiscoverCarouselView(items: [Game(id: "1", title: "Cities Skylines II", urlSite: "", image: "", imageFilename: "", date: Date(), genres: ["Simulation"], platforms: ["Windows"], developer: "Paradox Interative", desc: "", engines: ["Unreal Engine"])])
    }
  }
}
