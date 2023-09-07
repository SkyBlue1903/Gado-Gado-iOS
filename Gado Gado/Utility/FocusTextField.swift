//
//  FocusTextField.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 06/09/23.
//

import SwiftUI
import UIKit
import Focuser

enum FormFields {
  case email, password, addGenre
}

extension FormFields: FocusStateCompliant {
  
  static var last: FormFields {
    .password
  }
  
  var next: FormFields? {
    switch self {
    case .addGenre:
      return .addGenre
    default: return nil
    }
  }
}
