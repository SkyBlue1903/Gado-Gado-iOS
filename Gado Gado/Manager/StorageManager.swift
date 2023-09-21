//
//  StorageManager.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 04/09/23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
  static let instance = StorageManager()
  private init() { }
  private let storage = Storage.storage().reference()
  private var imageReference: StorageReference {
    storage.child("app").child("images")
  }
  
  func saveImgProf(data: Data, userId: String = "") async throws -> (path: String, name: String) {
    let meta = StorageMetadata()
    meta.contentType = "image/jpeg"
    
    let path = "\(userId.isEmpty ? UUID().uuidString.lowercased() : userId).jpeg"
    let returnedMetadata = try await imageReference.child(path).putDataAsync(data, metadata: meta)
    
    guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
      throw URLError(.badServerResponse)
    }
    let imageUrl = try await imageReference.child(path).downloadURL()
    return (imageUrl.absoluteString, returnedName)
  }
  
  func delImgProf() async throws {
    let auth = try await AuthManager.instance.getAuthUser()
    try await imageReference.child(auth.uid + ".jpeg").delete()
  }
}
