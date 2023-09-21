//
//  ArticleManager.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 12/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ArticleManager {
  
  static let instance = ArticleManager()
  private init() { }
  
  func getArticlesCollection() async throws -> [Article] {
    var tempArray = [Article]()
    let snapshot = try await Firestore.firestore().collection("artikels").getDocuments()
    for doc in snapshot.documents {
      let data = doc.data()
      let timestamp = data["date"] as? Timestamp
      let date = timestamp?.dateValue() as? Date
      let content = data["artikel"] as? String
      let imgFile = data["filename"] as? String
      let imgUrl = data["gambarArtikel"] as? String
      let id = data["id"] as? String ?? ""
      let title = data["judulArtikel"] as? String
      let game = data["judulPermainan"] as? String
      let author = data["namaPenulis"] as? String
      let platforms = data["platform"] as? [String]
      let subtitle = data["subJudulArtikel"] as? String
      let article = Article(id: id, content: content, date: date, imageFilename: imgFile, image: imgUrl, title: title, game: game, author: author, platforms: platforms, subtitle: subtitle)
      tempArray.append(article)
    }
    return tempArray
  }
}
