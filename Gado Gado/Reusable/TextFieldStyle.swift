//
//  TextField.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 21/08/23.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .frame(height: CGFloat(.heightTF))
      .background(Color.gray.opacity(CGFloat(.fieldOpacity)))
      .cornerRadius(10)
  }
}

// ISHIDDEN STRUCT IS HERE

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
