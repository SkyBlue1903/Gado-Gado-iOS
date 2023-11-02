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
import FirebaseStorage

final class GameManager {
  static let instance = GameManager() // Singleton
  private init() { }
  private let storage = Storage.storage().reference()
  private var imageReference: StorageReference {
    storage.child("app").child("images")
  }
  
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
//    guard let auth = Auth.auth().currentUser else {
//      throw URLError(.badServerResponse)
//    }
    
    let autoID =  Firestore.firestore().collection("games").document().documentID
    let saveData: [String: Any] = [
      "date": Timestamp(),
      "desc": desc,
      "developer": dev,
      "genres": genres,
//      "uid": auth.uid,
      "id": autoID,
      "platforms": platforms,
      "title": title,
      "urlSite": urlPage,
      /// for Images and Path are available in `StorageManager.swift
      "imageFilename": imgName,
      "image": imgUrl
    ]
    try await Firestore.firestore().collection("games").document(autoID).setData(saveData, merge: true)
  }
  
  func editExperience(gameId: String, title: String, dev: String, desc: String, urlPage: String, platforms: [String], genres: [String], imgName: String, imgUrl: String) async throws {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    
    let saveData: [String: Any] = [
      "date": Timestamp(),
      "desc": desc,
      "developer": dev,
      "genres": genres,
      "platforms": platforms,
      "title": title,
      "urlSite": urlPage,
      /// for Images and Path are available in `StorageManager.swift
      "imageFilename": imgName,
      "image": imgUrl
    ]
    try await Firestore.firestore().collection("games").document(gameId).setData(saveData, merge: true)
  }
  
  func delExperience(gameId: String, withImage: Bool, imgFilename: String = "") async throws {
    try await Firestore.firestore().collection("games").document(gameId).delete()
    if withImage {
      try await delImgExp(imgFilename: imgFilename, delRefOnly: true)
    }
  }
  
  func delImgExp(gameId: String = "", imgFilename: String, delRefOnly: Bool) async throws {
    if delRefOnly {
      try await imageReference.child(imgFilename).delete()
    } else {
      try await imageReference.child(imgFilename).delete()
      let data: [String: Any] = [
        "image": FieldValue.delete(),
        "imageFilename": FieldValue.delete()
      ]
      try await Firestore.firestore().collection("games").document(gameId).setData(data, merge: true)
    }
  }
  
  func discoverByPlatform(_ platform: String) async throws -> [Game] {
    var tempArray = [Game]()
    
    let gameRef = try await Firestore.firestore().collection("games").whereField("platforms", arrayContains: platform).getDocuments()
    for doc in gameRef.documents {
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
  
  func searchByTitle(_ gameTitle: String) async throws -> Game? {
    let ref = try await Firestore.firestore().collection("games").whereField("title", isEqualTo: gameTitle).getDocuments()
    guard let doc = ref.documents.first else {
      return nil
    }
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
    return Game(id: id, title: title, urlSite: urlSite, image: image, imageFilename: imageFilename, date: date, genres: genres, platforms: platforms, developer: developer, desc: desc, engines: engines)
  }
  
  func userExperiences() async throws -> [Game] {
    var tempArray = [Game]()
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    let ref = try await Firestore.firestore().collection("games").whereField("uid", isEqualTo: auth.uid).getDocuments()
    for doc in ref.documents {
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
      tempArray.append(Game(id: id, title: title, urlSite: urlSite, image: image, imageFilename: imageFilename, date: date, genres: genres, platforms: platforms, developer: developer, desc: desc, engines: engines))
    }
    return tempArray
  }
  
}
