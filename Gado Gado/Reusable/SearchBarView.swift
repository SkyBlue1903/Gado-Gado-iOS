//
//  SearchBarView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 29/10/23.
//

import SwiftUI

struct SearchBarView: View {
  
  @Binding var searchText: String
  @State private var showCancelButton: Bool = false
  var onCommit: () ->Void = {print("onCommit")}
  
  var body: some View {
    HStack {
      HStack {
        Image(systemName: "magnifyingglass")
        
        // Search text field
        ZStack (alignment: .leading) {
          if searchText.isEmpty { // Separate text for placeholder to give it the proper color
            Text("Search for games or articles")
          }
          TextField("", text: $searchText, onEditingChanged: { isEditing in
            self.showCancelButton = true
          }, onCommit: onCommit).foregroundColor(.primary)
        }
        // Clear button
        Button(action: {
          self.searchText = ""
        }) {
          Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
        }
      }
      .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
      .foregroundColor(.secondary) // For magnifying glass and placeholder test
      .background(Color(.tertiarySystemFill))
      .cornerRadius(10.0)
      
      if showCancelButton  {
        // Cancel button
        Button("Cancel") {
          UIApplication.shared.endEditing(true) // this must be placed before the other commands here
          self.searchText = ""
          self.showCancelButton = false
        }
      }
    }
    .padding(.horizontal)
//    .navigationBarHidden(showCancelButton)
  }
}

#Preview {
  SearchBarView(searchText: .constant("Hello"))
}
