//
//  TodayGameView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 13/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TodayGameView: View {
  
  var data: Game
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    NavigationLink(destination: GameDetailView(data: data)) {
      VStack(alignment: .leading, spacing: 16.0) {
        WebImage(url: URL(string: "\(data.image ?? "")"))
          .placeholder {
            ZStack {
              Color.gray
                .opacity(0.2)
              ProgressView()
            }
          }
          .resizable()
          .clipped()
        LazyVStack(alignment: .leading) {
          Text("\(data.title ?? "")")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
          HStack(spacing: 4.0) {
            Text(ExtensionManager.instance.relativeTime(from: data.date ?? Date()))
          }
          .foregroundColor(.gray)
          .padding(.bottom, 16)
        }
        .padding(.horizontal)
      }
      .frame(height: getRect().size.height * 0.3)
      .background(colorScheme == .dark ? Color(.darkDefaultBg) : Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .shadow(radius: 20)
      .frame(maxWidth: .infinity)
    }
  }
}

struct TodayGameView_Previews: PreviewProvider {
  static var previews: some View {
    TodayGameView(data: Game(id: "123", title: "Cities Skylines II", urlSite: "", image: "", imageFilename: "", date: Date(), genres: ["Simulation", "Strategy"], platforms: ["Windows", "PS4", "Xbox One"], developer: "Paradox Interactive", desc: "Build your own cities!", engines: ["Unreal Engine"]))
  }
}
