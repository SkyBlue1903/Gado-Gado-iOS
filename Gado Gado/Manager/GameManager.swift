//
//  GameManager.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 27/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class GameManager {
  
  static let instance = GameManager() // Singleton
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
  
  func addExperience(title: String, dev: String, desc: String, urlPage: String, platforms: [String], genres: [String], imgName: String = "", imgUrl: String = "") async throws {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    
    let autoID =  Firestore.firestore().collection("games").document().documentID
    let saveData: [String: Any] = [
      "date": Timestamp(),
      "desc": desc,
      "developer": dev,
      "genres": genres,
      "uid": auth.uid,
//      "id":
      "platforms": platforms,
      "title": title,
      "urlSite": urlPage,
      /// for Images and Path are available in `StorageManager.swift
      "imageFilename": imgName,
      "image": imgUrl
    ]
    print("SAVED EXPERIENCE DOCUMENTID:", autoID)
    try await Firestore.firestore().collection("games").document(autoID).setData(saveData, merge: true)
  }
}
