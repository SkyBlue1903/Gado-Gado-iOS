//
//  AuthManager.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 27/08/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

final class AuthManager {
  
  static let instance = AuthManager()
  private init() { }
  
  @discardableResult
  func createUser(email: String, password: String, fullname: String, username: String) async throws {
    let auth = try await Auth.auth().createUser(withEmail: email, password: password)
    let result = AuthUser(user: auth.user)
    
    var fsData: [String: Any] = [
      "id": result.uid,
      "date": Timestamp()
    ]
    
    if let email = result.email {
      fsData["email"] = email
    }
    if let photoUrl = result.photoUrl {
      fsData["image"] = photoUrl
    }
    
    fsData["about"] = ""
    fsData["address"] = ""
//    fsData["birthdate"] = Date()?? maybe // MARK: Birthday are required to verify user
    fsData["password"] = password
    fsData["fullName"] = fullname
//    fsData["gender"] = gender /// Disabled because of inefficient form
    fsData["username"] = username
    fsData["deviceOs"] = getCurrentiOS()
    fsData["deviceModel"] = UIDevice.modelName
    
    try await Firestore.firestore().collection("developer").document(result.uid).setData(fsData, merge: false)
  }
  
  func getAuthUser() throws -> AuthUser {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    return AuthUser(user: auth)
  }
  
  /// Please run `getAuthUser()` first before using this func as user info detail
  func getFSUser(user: AuthUser) async throws -> FSUser {
    let snapshot = try await Firestore.firestore().collection("developer").document(user.uid).getDocument()
    
    guard let data = snapshot.data(), let id = data["id"] as? String else {
      throw URLError(.badServerResponse)
    }
    
    let email = data["email"] as? String
    let fullname = data["fullname"] as? String
    let about = data["about"] as? String
    let address = data["address"] as? String
    let gender = data["gender"] as? String
    //    let id = data["id"] as? String
    let birthdate = data["birthdate"] as? String
    let photoUrl = user.photoUrl
    
    return FSUser(uid: id, email: email, photoUrl: photoUrl, fullname: fullname, about: about, address: address, gender: gender, birthdate: birthdate)
  }
  
  func logoutUser() throws {
    try Auth.auth().signOut()
  }
}
