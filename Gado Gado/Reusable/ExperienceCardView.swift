//
//  ExperienceCardView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 18/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExperienceCardView: View {
  @Environment(\.colorScheme) var colorScheme
  var data: Game
  
  var body: some View {
    HStack {
      WebImage(url: URL(string: data.image ?? ""))
        .placeholder {
          ZStack {
            Color.gray
              .opacity(0.2)
            ProgressView()
          }
        }
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150)
        .frame(maxHeight: .infinity)
        .clipped()
      
      VStack(alignment: .leading) {
        Group {
          Text(data.title ?? "")
            .font(.headline)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .foregroundColor(.accentColor)
          Text(data.desc ?? "")
            .font(.callout)
            .foregroundColor(.gray)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
        }
        Spacer()
        Text(ExtensionManager.instance.relativeTime(from: data.date ?? Date()))
          .font(.caption2)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.vertical)
      Spacer()
    }
    .background(colorScheme == .light ? Color.white : Color(.darkDefaultBg))
    .cornerRadius(10)
    .shadow(radius: 5)
  }
}

struct ExperienceCardView_Previews: PreviewProvider {
  static var previews: some View {
    ExperienceCardView(data: Game(id: "", title: "Cities Skylines II", urlSite: "", image: "", imageFilename: "", date: Date(), genres: ["Simulation"], platforms: ["Windows"], developer: "Paradox Interactie", desc: "", engines: ["Unreal Engine"]))
  }
}
