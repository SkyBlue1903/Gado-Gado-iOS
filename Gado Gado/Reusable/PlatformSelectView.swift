//
//  MultipleSelectionList.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 05/09/23.
//

import SwiftUI

struct PlatformSelectView: View {
  @State private var items: [String] = ["iOS", "iPadOS", "macOS", "Android", "Windows", "Linux", "HTML 5", "Xbox Series X", "Xbox Series S", "Xbox One", "Xbox 360", "PlayStation 5", "PlayStation 4", "PlayStation 3", "Nintendo Switch", "Nintendo Wii U", "Nintendo Wii", "Arcade Game"]
  @Binding var selections: [String]
  
  var body: some View {
    List {
      ForEach(self.items, id: \.self) { item in
        MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
          if self.selections.contains(item) {
            self.selections.removeAll(where: { $0 == item })
          }
          else {
            self.selections.append(item)
          }
        }
      }
    }
    .navigationTitle("Platform")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          self.selections.removeAll()
        } label: {
          Text("Clear all")
        }
        .disabled(self.selections.isEmpty ? true : false)
      }
    }
  }
}

struct MultipleSelectionRow: View {
  
  @Environment(\.colorScheme) var colorScheme
  var title: String
  var isSelected: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      HStack {
        Text(title == "HTML 5" ? "HTML 5/Browser/Embed Browser Game" : self.title)
          .foregroundColor(colorScheme == .light ? Color.black : Color.white)
        if self.isSelected {
          Spacer()
          Image(systemName: "checkmark")
        }
      }
    }
  }
}

struct PlatformSelectView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PlatformSelectView(selections: .constant(["iOS", "macOS"]))
    }
  }
}
