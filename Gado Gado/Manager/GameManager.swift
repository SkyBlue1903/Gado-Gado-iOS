//
//  GameManager.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 27/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class GameManager {
  
  static let sharedInstance = GameManager() // Singleton
  private init() { }
  
  func getGamesCollection() async throws -> [Game] {
    var tempArray = [Game]()
    let querySnapshot = try await Firestore.firestore().collection("games").getDocuments()
    
    for doc in querySnapshot.documents {
      let data = doc.data()
      let timestamp = data["date"] as? Timestamp
      let date = timestamp?.dateValue() as? Date
      let genres = data["genres"] as? [String]
      let id = data["id"] as? String ?? ""
      let image = data["image"] as? String
      let imageFilename = data["imageFilename"] as? String
      let platforms = data["platforms"] as? [String]
      let title = data["title"] as? String
      let urlSite = data["urlSite"] as? String
      let developer = data["developer"] as? String
      let desc = data["desc"] as? String
      let engines = data["engines"] as? [String]
      
      let game = Game(id: id, title: title, urlSite: urlSite, image: image, imageFilename: imageFilename, date: date, genres: genres, platforms: platforms, developer: developer, desc: desc, engines: engines)
      tempArray.append(game)
    }
    
    return tempArray
  }
  
}
