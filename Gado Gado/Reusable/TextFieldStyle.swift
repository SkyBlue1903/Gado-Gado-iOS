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

struct TextFieldButtonStyle: ViewModifier {
  
  @Binding var isDisabled: Bool
  
  func body(content: Content) -> some View {
    content
      .padding()
      .foregroundColor(Color.white)
      .frame(maxWidth: .infinity)
      .frame(height: CGFloat(.heightTF))
      .background(!isDisabled ? Color.accentColor : Color.gray.opacity(0.5))
      .cornerRadius(10)
      .disabled(!isDisabled ? false : true)
      .padding(.top, UIScreen().bounds.height * 0.03)
  }
}

struct CustomButtonStyle: View {
  
  var title: String?
  var titleInProgress: String?
  var color: Color?
  var inProgress: Bool?
  
  var body: some View {
    HStack(spacing: 10) {
      Text("\(inProgress ?? false ? titleInProgress ?? "" : title ?? "")")
        .foregroundColor(inProgress ?? false ? Color.gray : color ?? Color.accentColor)
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
