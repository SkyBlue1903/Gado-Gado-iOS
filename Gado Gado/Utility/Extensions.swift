//
//  Extensions.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    
    Scanner(string: hex).scanHexInt64(&int)
    
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
  
  init(_ colorPalette: ColorPalette) {
    switch colorPalette {
    case .darkDefaultBg:
      self = Color(hex: "202020")
    case .primaryApp:
      self = Color(hex: "7DCE13")
    case .secondaryApp:
      self = Color(hex: "00000") // MARK: Brown color needs to fix soon
    }
  }
}

extension View {
  func getRect() -> CGRect {
    return UIScreen.main.bounds
  }
  
  func isHidden(_ isHidden: Bool) -> some View {
    modifier(HiddenModifier(isHidden: isHidden))
  }
}

extension CGFloat {
  init(_ size: SizePalette) {
    switch size {
    case .heightTF:
      self = 48
    }
  }
  
  init(_ opacity: OpacityPalette) {
    switch opacity {
    case .fieldOpacity:
      self = 0.15
    case .disabledOpacity:
      self = 0.5
    }
  }
}

