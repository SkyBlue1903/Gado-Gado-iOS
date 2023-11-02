//
//  UtilityModifier.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 02/11/23.
//

import SwiftUI

struct HiddenModifier: ViewModifier {
  let isHidden: Bool
  
  func body(content: Content) -> some View {
    if isHidden {
      content.hidden()
    } else {
      content
    }
  }
}
