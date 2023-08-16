//
//  ContentView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI

struct TodayView: View {
  
  @State private var statusBarHeight: CGFloat = 0
  @State private var currentDate: String = ""
  
  var body: some View {
    GeometryReader { geometry in
      Rectangle()
        .frame(height: statusBarHeight) // Set the header height
        .offset(y: min(-statusBarHeight, 0))
        .zIndex(1) // Place the header on top
        .foregroundColor(.white)
      NavigationView {
        ScrollView(.vertical) {
          VStack(alignment: .leading, spacing: 0) {
            Text(currentDate.uppercased())
              .font(.footnote)
              .foregroundColor(.gray)
              .fontWeight(.medium)
            Text("Today")
              .font(.largeTitle)
              .fontWeight(.bold)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .padding(.bottom, -1)
          .padding(.top, 10)
          
          ForEach(1..<10, id: \.self) { each in
            VStack(alignment: .leading, spacing: 16.0) {
              Image("sample-header")
                .resizable()
              VStack(alignment: .leading) {
                Text("Cities Skyline")
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
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
            .frame(maxWidth: .infinity)
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
      }
    }
  }
}

struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    TodayView()
  }
}
