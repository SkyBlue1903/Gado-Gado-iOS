//
//  PlatformIconView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 26/08/23.
//

import SwiftUI

struct PlatformIconView: View {
  
  var platforms: [String]?
  
  var body: some View {
    HStack(spacing: 10) {
      ForEach(platforms ?? [""], id: \.self) { each in
        let platform = each.lowercased()
        switch platform {
        case "android":
          Image("android-logo").resizable().frame(width:  18, height: 12)
        case "ios", "ipados", "macOS", "watchOS", "visionOS", "tvOS":
          
          HStack(alignment: .center, spacing: 2) {
            Image(systemName: "apple.logo")
              .font(.system(size: 12))
            Text("\(applePlatformCheck(platform))OS")
              .offset(y: 1)
          }
          .frame(height: 12)
        case "windows":
          Image("windows-logo").resizable().frame(width: 12, height: 12)
        case "html 5", "html5":
          Image("html5-logo").resizable().frame(width: 12, height:  12)
        case "playstation", "ps4", "ps5":
          Image(systemName: "playstation.logo")
        case "xbox", "xbox x", "xbox s", "xbox series x", "xbox series s", "xbox 360", "xbox one", "xbox 360":
          Image(systemName: "xbox.logo")
        case "nintendo", "nintendo switch", "switch":
          Image("").resizable().frame(width:  12, height: 12)
        case "linux":
          Image("linux-logo").resizable().frame(width: 12, height: 12)
        default:
          Text("\(each)".capitalized).frame(height: 12)
        }
      }
    }
  }
  
  func applePlatformCheck(_ platform: String) -> String {
    var pChar = platform.replacingOccurrences(of: "p", with: "P")
    let osName = String(pChar.dropLast(2))  // Mengubah dari removeLast menjadi dropLast
    return osName
  }
}

struct PlatformIconView_Previews: PreviewProvider {
  static var previews: some View {
    PlatformIconView()
  }
}
