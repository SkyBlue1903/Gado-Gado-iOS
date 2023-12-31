//
//  TextField.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 21/08/23.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
  
  @Environment(\.colorScheme) var colorScheme
  
  func body(content: Content) -> some View {
    content
      .padding()
      .frame(height: CGFloat(.heightTF))
      .background(colorScheme == .light ? Color.white : Color(hex: "1C1C1E"))
      .cornerRadius(10)
  }
}

struct TextFieldButtonStyle: ViewModifier {
  
  @Binding var isDisabled: Bool
  
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .frame(maxWidth: .infinity)
      .frame(height: CGFloat(.heightTF))
      .background(!isDisabled ? Color.accentColor : Color.gray.opacity(0.5))
      .cornerRadius(10)
      .disabled(!isDisabled ? false : true)
  }
}

struct CustomButtonStyle: View {
  
  var title: String?
  var titleInProgress: String?
  var color: Color?
  var inProgress: Bool?
  var isDisabled: Bool? /// Use this parameter if using custom `Color`
  
  var body: some View {
    HStack(spacing: 10) {
      Text("\(inProgress ?? false ? titleInProgress ?? "" : title ?? "")")
        .foregroundColor(isDisabled ?? false ? Color.gray : (inProgress ?? false ? Color.gray : color ?? Color.accentColor))
        .padding(.leading)
      ProgressView()
        .isHidden(inProgress ?? false ? false : true)
      Spacer()
    }
    .frame(height: CGFloat(.heightTF))
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
