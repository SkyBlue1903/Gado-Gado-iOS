//
//  GenreView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 06/09/23.
//

import SwiftUI
import Focuser

struct GenreView: View {
  
  @Binding var genres: [String]
  @State private var addGenre: String = ""
  @State var fieldFocus: [Bool] = [false]
  
  var body: some View {
    List {
      Section (footer: Text("Press \"return\" key to add")){
        TextField("Type here to add genre...", text: $addGenre) {
          if addGenre.count > 0 {
            DispatchQueue.main.async {
              genres.append(addGenre)
              self.addGenre = ""
            }
          }
        }
        .autocapitalization(.words)
        .autocorrectionDisabled()
      }
      if !genres.isEmpty {
        Section(header: HStack {
          Text("Game's genre")
          Spacer()
          Button {
            genres.removeAll()
          } label: {
            Text("Clear all")
              .font(.system(size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .regular))
          }

        }) {
          ForEach(genres, id: \.self) { item in
            Text(item)
            
          }
          .onDelete(perform: delete)
        }
      }
    }
    .toolbar {
      if genres.count >= 1 {
        EditButton()
      }
    }
    .navigationTitle("Genre")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func delete(at offsets: IndexSet) {
    genres.remove(atOffsets: offsets)
  }
  
  func add(_ item: String) {
    
  }
}

struct GenreView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      GenreView(genres: .constant([]))
    }
  }
}
