//
//  ContentView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import VisualEffectView
import SDWebImageSwiftUI

struct TodayView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var statusBarHeight: CGFloat = 0
  @State private var currentDate: String = ""
  
  @State private var allGames = [Game]()
  
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
          VStack(alignment: .leading, spacing: 0) {
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
          
          ForEach(allGames, id: \.self) { each in
            NavigationLink(destination: GameDetailView(currentGame: each)) {
              VStack(alignment: .leading, spacing: 16.0) {
                WebImage(url: URL(string: "\(each.image ?? "")"))
                  .placeholder {
                    // Placeholder Image View
                    Image("sample-header") // Replace with the name of your placeholder image asset
                      .resizable()
                  }
                  .resizable()
                  .clipped()
                VStack(alignment: .leading) {
                  Text("\(each.title ?? "")")
                    .font(.headline)
                  HStack(spacing: 4.0) {
                    Text(relativeTime(from: each.date ?? Date()))
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
          
//          Task {
//            let games = try await GameManager.sharedInstance.getGamesCollection()
//            DispatchQueue.main.async {
//              allGames = games
//            }
//          }
        }
//      }
    }
  }
  
  func relativeTime(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
    
    if let year = components.year, year > 0 {
      return "\(year) year\(year > 1 ? "s" : "") ago"
    } else if let month = components.month, month > 0 {
      return "\(month) month\(month > 1 ? "s" : "") ago"
    } else if let day = components.day, day > 0 {
      return "\(day) day\(day > 1 ? "s" : "") ago"
    } else if let hour = components.hour, hour > 0 {
      return "\(hour) hour\(hour > 1 ? "s" : "") ago"
    } else if let minute = components.minute, minute > 0 {
      return "\(minute) minute\(minute > 1 ? "s" : "") ago"
    } else {
      return "Just now"
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
