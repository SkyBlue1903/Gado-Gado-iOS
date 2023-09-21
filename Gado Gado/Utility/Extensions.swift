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
      self = Color(hex: "7DCE13") /// Mint green
//      self = Color(hex: "4F3728") /// Color brown
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
  
  /// This function changes our View to UIView, then calls another function
  /// to convert the newly-made UIView to a UIImage.
  public func asUIImage() -> UIImage {
    let controller = UIHostingController(rootView: self)
    
    /// Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
    controller.view.backgroundColor = .clear
    
    controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
    UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
    
    let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
    controller.view.bounds = CGRect(origin: .zero, size: size)
    controller.view.sizeToFit()
    
    /// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
    let image = controller.view.asUIImage()
    controller.view.removeFromSuperview()
    return image
  }
  
  func onReturn(perform action: @escaping () -> Void) -> some View {
    return self.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
      action()
    }
  }
  
  func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
    overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
  }
}

extension CGFloat {
  init(_ size: SizePalette) {
    switch size {
    case .heightTF:
      self = 45
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

extension UIView {
  /// This is the function to convert UIView to UIImage
  public func asUIImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
  func toImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
    self.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}

extension Array where Element == String {
  func arrayToString() -> String {
    // Filter out empty strings from the array
    let nonEmptyStrings = self.filter { !$0.isEmpty }
    
    switch nonEmptyStrings.count {
    case 0:
      return ""
    case 1:
      return nonEmptyStrings.first ?? ""
    case 2:
      return "\(nonEmptyStrings[0]) and \(nonEmptyStrings[1])"
    default:
      var result = ""
      for (index, item) in nonEmptyStrings.dropLast().enumerated() {
        result += "\(item), "
        if index == nonEmptyStrings.count - 2 {
          result += "and "
        }
      }
      result += nonEmptyStrings.last ?? ""
      return result
    }
  }
  
  func withSeparator(_ separator: String) -> String {
    return self.map {
      String(describing: $0) }.joined(separator: ",\(separator) ")
  }
}

class ExtensionManager {
  
  static let instance = ExtensionManager()
  private init() { }
  
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
  
  
  func randomArray<T>(_ array: [T], count: Int) -> [T] {
    var shuffledArray = array
    shuffledArray.shuffle()
    
    return Array(shuffledArray.prefix(count))
  }
  
  func getHomeBarHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
      if let bottomPadding = window?.safeAreaInsets.bottom {
        return bottomPadding
      }
    }
    return 0.0
  }
}

struct EdgeBorder: Shape {
  var width: CGFloat
  var edges: [Edge]
  
  func path(in rect: CGRect) -> Path {
    edges.map { edge -> Path in
      switch edge {
      case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
      case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
      case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
      case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
      }
    }.reduce(into: Path()) { $0.addPath($1) }
  }
}
