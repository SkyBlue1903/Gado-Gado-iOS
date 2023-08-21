//
//  ContentView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import VisualEffectView

struct TodayView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var statusBarHeight: CGFloat = 0
  @State private var currentDate: String = ""

  
  var body: some View {
    GeometryReader { geometry in
//      Rectangle()
      VisualEffect(colorTint: colorScheme == .dark ? .black : .white, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
        .frame(height: statusBarHeight)
        .offset(y: min(-statusBarHeight, 0))
        .zIndex(1)
//        .foregroundColor(colorScheme == .dark ? .black : .white)
//      NavigationView {
        ScrollView(.vertical) {
          VStack(alignment: .leading, spacing: 5) {
            Text(currentDate.uppercased())
              .font(.footnote)
              .foregroundColor(.gray)
              .fontWeight(.medium)
            Text("Today")
              .font(.system(size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .padding(.bottom, -1)
          .padding(.top, 20)
          
          ForEach(1..<10, id: \.self) { each in
            NavigationLink(destination: EmptyView()) {
              VStack(alignment: .leading, spacing: 16.0) {
                Image("sample-header")
                  .resizable()
                  .clipped()
                VStack(alignment: .leading) {
                  Text("Cities Skylines")
                    .font(.headline)
                  HStack(spacing: 4.0) {
                    Text("4 months ago")
                  }
                  .foregroundColor(.gray)
                  .padding(.bottom, 16)
                } 
                .padding(.horizontal)
              }
              .frame(height: geometry.size.height * 0.4)
              .background(colorScheme == .dark ? Color(.darkDefaultBg) : Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .shadow(radius: 20)
              .frame(maxWidth: .infinity)
            }
          }
          .padding(.horizontal)
          .padding(.bottom)
        }
        .onAppear {
          statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
          
          let currentDate = Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEEE"
          let day = dateFormatter.string(from: currentDate)
          dateFormatter.dateFormat = "dd"
          let date = dateFormatter.string(from: currentDate)
          dateFormatter.dateFormat = "MMMM"
          let month = dateFormatter.string(from: currentDate)
          self.currentDate = "\(day), \(date) \(month)"
        }
//      }
    }
  }
}

struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TodayView()
    }
  }
}
