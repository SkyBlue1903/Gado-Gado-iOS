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

func getCurrentiOS() -> String {
  return "iOS " + UIDevice.current.systemVersion
}

extension UIDevice {
  
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
      switch identifier {
      case "iPhone8,4":                   return "iPhone SE"
      case "iPhone12,8":                  return "iPhone SE (2nd generation)"
      case "iPhone14,6":                  return "iPhone SE (3rd generation)"
      case "iPod9,1":                     return "iPod touch (7th generation)"
      case "iPhone8,1":                   return "iPhone 6s"
      case "iPhone8,2":                   return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":      return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":      return "iPhone 7 Plus"
      case "iPhone10,1", "iPhone10,4":    return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":    return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":    return "iPhone X"
      case "iPhone11,2":                  return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":    return "iPhone XS Max"
      case "iPhone11,8":                  return "iPhone XR"
      case "iPhone12,1":                  return "iPhone 11"
      case "iPhone12,3":                  return "iPhone 11 Pro"
      case "iPhone12,5":                  return "iPhone 11 Pro Max"
      case "iPhone13,1":                  return "iPhone 12 mini"
      case "iPhone13,2":                  return "iPhone 12"
      case "iPhone13,3":                  return "iPhone 12 Pro"
      case "iPhone13,4":                  return "iPhone 12 Pro Max"
      case "iPhone14,4":                  return "iPhone 13 mini"
      case "iPhone14,5":                  return "iPhone 13"
      case "iPhone14,2":                  return "iPhone 13 Pro"
      case "iPhone14,3":                  return "iPhone 13 Pro Max"
      case "iPhone14,7":                  return "iPhone 14"
      case "iPhone14,8":                  return "iPhone 14 Plus"
      case "iPhone15,2":                  return "iPhone 14 Pro"
      case "iPhone15,3":                  return "iPhone 14 Pro Max"

      case "i386", "x86_64", "arm64":     return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                            return identifier
      }
#endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
  
}
