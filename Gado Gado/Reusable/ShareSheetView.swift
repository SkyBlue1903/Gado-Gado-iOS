//
//  ShareSheetView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 27/08/23.
//

import SwiftUI

struct TextShareSheetView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIActivityViewController
  let activityItems: [Any]
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
  }
}
