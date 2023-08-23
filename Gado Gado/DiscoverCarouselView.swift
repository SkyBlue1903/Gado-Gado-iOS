//
//  DiscoverCarouselView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 17/08/23.
//

import SwiftUI
import VisualEffectView

struct DiscoverCarouselView: View {
  
  @State private var index: Int = 1
  @State private var showDetail: Bool = false
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      TabView(selection: $index) {
        ForEach(1...3, id: \.self) { each in
          ZStack {
            Rectangle()
              .fill(.blue)
            Text("Page: \(each)")
              .foregroundColor(.white)
            NavigationLink(destination: GameDetailView(), isActive: $showDetail) {
            }
            .hidden()
          }
          .onTapGesture {
            print("IAM PRESSED AT:", index)
            showDetail.toggle()
          }
        }
      }
      .tabViewStyle(.page)
    }
  }
}

struct DiscoverCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DiscoverCarouselView()
    }
  }
}
