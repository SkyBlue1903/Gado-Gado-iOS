//
//  Model.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 26/08/23.
//

import Foundation
import FirebaseAuth

struct Game: Hashable, Codable {
  var id: String
  var title: String?
  var urlSite: String?
  var image: String?
  var imageFilename: String?
  var date: Date?
  var genres: [String]?
  var platforms: [String]?
  var developer: String?
  var desc: String?
  var engines: [String]?
}

struct AuthUser {
  let uid: String
  let email: String?
  let photoUrl: String?
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.photoUrl = user.photoURL?.absoluteString
  }
}

struct FSUser {
  let uid: String
  let email: String?
  let photoUrl: String?
  let fullname: String?
  let about: String?
  let address: String?
  let gender: String?
  let birthdate: String?
  init(uid: String, email: String?, photoUrl: String?, fullname: String?, about: String?, address: String?, gender: String?, birthdate: String?) {
    self.uid = uid
    self.email = email
    self.photoUrl = photoUrl
    self.fullname = fullname
    self.about = about
    self.address = address
    self.gender = gender
    self.birthdate = birthdate
  }
}
