//
//  DiscoverPlatformView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 17/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverPlatformView: View {
  
  @State var platform: String
  @State var allGames: [Game]
  @Environment(\.colorScheme) var colorScheme
  
    var body: some View {
      ScrollView(.vertical) {
        ForEach(allGames, id: \.self) { each in
          NavigationLink(destination: GameDetailView(currentGame: each)) {
            HStack {
              WebImage(url: URL(string: each.image ?? ""))
                .resizable()
                .placeholder {
                  ZStack {
                    Color.gray
                      .opacity(0.2)
                    ProgressView()
                  }
                  .frame(width: 90, height: 90)
                }
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipped()
                .cornerRadius(10)
              VStack(alignment: .leading, spacing: 0) {
                Text(each.title ?? "")
                  .lineLimit(1)
                  .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                Text(ExtensionManager.instance.relativeTime(from: each.date ?? Date()))
                  .lineLimit(1)
                  .foregroundColor(Color.gray.opacity(0.5))
                  .font(.caption)
              }
              Spacer()
              Image(systemName: "chevron.right")
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height:100)
          } // MARK: Needs responsive for smaller iPhones
          Divider()
            
        }
        .padding(.leading)
      }
      .navigationTitle("Discover \(platform) Games")
    }
}

struct DiscoverPlatformView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        DiscoverPlatformView(platform: "iOS", allGames: [Game(id: "1", title: "Cities Skylines II", urlSite: "", image: "", imageFilename: "", date: Date(), genres: ["Simulation"], platforms: ["xbox"], developer: "Paradox Interactive", desc: "Hello", engines: ["Unreal Engine"])])
      }
    }
}
