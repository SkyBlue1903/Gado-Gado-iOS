////
////  AsyncImageProfile.swift
////  Gado Gado
////
////  Created by Erlangga Anugrah Arifin on 12/09/23.
////
//
//import SwiftUI
//import Foundation
//import Combine
//
//class ImageLoader: ObservableObject {
//  @Published var image: UIImage?
//  private let url: URL
//  private var cancellable: AnyCancellable?
//  
//  init(url: URL) {
//    self.url = url
//  }
//  
//  deinit {
//    cancel()
//  }
//  
//  func load() {
//    cancellable = URLSession.shared.dataTaskPublisher(for: url)
//      .map { UIImage(data: $0.data) }
//      .replaceError(with: nil)
//      .receive(on: DispatchQueue.main)
//      .sink { [weak self] in self?.image = $0 }
//  }
//  
//  func cancel() {
//    cancellable?.cancel()
//  }
//}
//
//struct AsyncImageProfile<Placeholder: View>: View {
//  @StateObject private var loader: ImageLoader
//  private let placeholder: Placeholder
//  
//  init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
//    self.placeholder = placeholder()
//    _loader = StateObject(wrappedValue: ImageLoader(url: url))
//  }
//  
//  var body: some View {
//    content
//      .onAppear(perform: loader.load)
//  }
//  
//  private var content: some View {
//    placeholder
//  }
//}
