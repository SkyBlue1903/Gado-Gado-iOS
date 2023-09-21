//
//  TodayArticleView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 13/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TodayArticleView: View {
  
  var data: Article
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    NavigationLink(destination: ArticleDetailView(data: data)) {
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
        VStack(alignment: .leading, spacing: 5) {
          Text("\(data.title ?? "")")
            .font(.headline)
            .lineLimit(1)
          HStack(spacing: 5) {
            Text(ExtensionManager.instance.relativeTime(from: data.date ?? Date()))
            Text("•")
              .font(.title3)
              .lineLimit(1)
            Text("\(data.subtitle ?? "")")
              .lineLimit(1)
          }
          .foregroundColor(Color.gray)
          .font(.caption)
          HStack(spacing: 8) {
            HStack(spacing: 2) {
              Image(systemName: "gamecontroller.fill")
              Text("\(data.game ?? "")")
                .lineLimit(1)
            }
            
            HStack(spacing: 2) {
              Image(systemName: "person.fill")
              Text("\(data.author ?? "")")
                .lineLimit(1)
            }
          }
          .font(.footnote)
          .foregroundColor(.gray)
          .padding(.bottom, 16)
        }
        .padding(.horizontal)
      }
      .frame(height: getRect().size.height * 0.35)
      .background(colorScheme == .dark ? Color(.darkDefaultBg) : Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .shadow(radius: 20)
      .frame(maxWidth: .infinity)
    }
  }
}

struct TodayArticleView_Previews: PreviewProvider {
    static var previews: some View {
      TodayArticleView(data: Article(id: "123", content: "Lorem Ipsum", date: Date(), imageFilename: "", image: "", title: "Merencanakan Kota dengan Penuh Strategi", game: "Cities Skylines II", author: "Paradox Interactive", platforms: ["PS5", "Xbox Series X", "Windows"], subtitle: "Ayo bangun kotamu!"))
    }
}
