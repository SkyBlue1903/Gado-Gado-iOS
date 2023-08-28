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

struct TextFieldFormStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(height: 45)
  }
}

struct CustomButtonStyle: View {
  
  var title: String?
  var color: Color?
  
  var body: some View {
    HStack {
      Text("\(title ?? "")")
        .foregroundColor(color ?? .blue)
      Spacer()
    }
    .frame(height: 44)
  }
}

struct CustomButtonFormStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .frame(maxWidth: .infinity)
      .foregroundColor(.white)
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
