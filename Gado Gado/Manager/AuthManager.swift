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
//    fsData["password"] = password
    fsData["fullName"] = fullname
    //    fsData["gender"] = gender /// Disabled because of inefficient form
    fsData["username"] = username
    fsData["deviceOs"] = getCurrentiOS()
    fsData["deviceModel"] = UIDevice.modelName
    fsData["lastAccess"] = Timestamp()
    
    try await Firestore.firestore().collection("developer").document(result.uid).setData(fsData, merge: false)
  }
  
  @discardableResult
  func signInUser(email: String, password: String) async throws -> FSUser {
    /// Sign in with Auth, then update some data to Firestore
    let auth = try await Auth.auth().signIn(withEmail: email, password: password)
    let result = AuthUser(user: auth.user)
    
    var fsData: [String: Any] = [
      "lastAccess": Timestamp(),
      "deviceOs": getCurrentiOS(),
      "deviceModel": UIDevice.modelName
    ]
    try await Firestore.firestore().collection("developer").document(result.uid).setData(fsData, merge: true)
    
    /// Retrieve User data from Firestore
    return try await getFSUser(user: result)
  }
  
  func getAuthUser() throws -> AuthUser {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    return AuthUser(user: auth)
  }
  
  /// Please run `getAuthUser()` or `signInUser()` first before using this func as user info detail
  func getFSUser(user: AuthUser) async throws -> FSUser {
    let snapshot = try await Firestore.firestore().collection("developer").document(user.uid).getDocument()
    
    guard let dataFetched = snapshot.data(), let id = dataFetched["id"] as? String else {
      throw URLError(.badServerResponse)
    }
    
    let email = dataFetched["email"] as? String
    let fullname = dataFetched["fullName"] as? String /// warning typo
    guard let usernameAt = dataFetched["username"] as? String else {
      throw URLError(.badServerResponse)
    }
    let about = dataFetched["about"] as? String
    let address = dataFetched["address"] as? String
    let gender = dataFetched["gender"] as? String
    let birthdate = dataFetched["birthdate"] as? String
    let photoUrl = dataFetched["imageProfile"] as? String
    return FSUser(uid: id, email: email, photoUrl: photoUrl, fullname: fullname, username: usernameAt, about: about, address: address, gender: gender, birthdate: birthdate)
  }
  
  func logoutUser() throws {
    try Auth.auth().signOut()
  }
  
  func resetPassword(email: String) async throws {
    try await Auth.auth().sendPasswordReset(withEmail: email)
  }
  
  func updatePassword(password: String) async throws {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    
    try await auth.updatePassword(to: password)
//    try await Firestore.firestore().collection("developer").document(auth.uid).setData(["password": password], merge: true)
    
    try logoutUser()
  }
  
  func updateEmail(email: String) async throws {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    try await auth.updateEmail(to: email)
    try await Firestore.firestore().collection("developer").document(auth.uid).setData(["email": email], merge: true)
    
    try logoutUser()
  }
  
  func deleteUser(userId: String) async throws {
    guard let auth = Auth.auth().currentUser else {
      throw URLError(.badURL)
    }
    try await Firestore.firestore().collection("developer").document(userId).delete()
    try await auth.delete()
  }
  
  
}
