//
//  ExperienceView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import BottomSheet
import PhotosUI
import UIKit

struct ExperienceView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var bottomSheetPosition: BottomSheetPosition = .hidden
  @State private var navTitle: String = ""
  
  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        ScrollView(.vertical) {
          ForEach(1..<10, id: \.self) { each in
            NavigationLink(destination: GameDetailView()) {
              HStack(spacing: 16.0) {
                Image("sample-header")
                  .resizable()
                  .scaledToFill()
                  .frame(width: 125)
                  .clipped()
                VStack() {
                  Group {
                    Text("Cities Skylines")
                      .font(.headline)
                      .lineLimit(2)
                      .multilineTextAlignment(.leading)
                    Text("Game description")
                      .font(.callout)
                      .foregroundColor(.gray)
                      .lineLimit(2)
                      .multilineTextAlignment(.leading)
                  }
                  .frame(maxWidth: .infinity, alignment: .leading)
                  Spacer()
                  Text("Edited 4 month ago")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical)
                Spacer()
                //                .padding(.horizontal)
              }
              .frame(height: geometry.size.height * 0.2)
              .frame(maxWidth: .infinity)
              .background(colorScheme == .dark ? Color(hex: "202020") : Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .shadow(radius: 5)
            }
            .padding(.vertical, 6)
          }
          .padding([.horizontal, .bottom])
        }
        
      }
      //        .opacity(bottomSheetPosition == .hidden ? 1 : 0)
      .navigationTitle("Experience")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          //            Image(systemName: "plus")
          Button {
            // ACTION OPEN SHEET
            bottomSheetPosition = .relativeTop(0.6)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      
      .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [.relativeTop(0.3), .relativeTop(0.6), .relativeTop(0.85)], title: "Add Experience") {
        ///** CONTENT HERE
        AddExperienceView()
      }
      .enableTapToDismiss(true)
      .showCloseButton(true)
      .showDragIndicator(true)
      .enableBackgroundBlur(true)
      .enableSwipeToDismiss(true)
      
    }
    
  }
  
  
}

struct ExperienceView_Previews: PreviewProvider {
  static var previews: some View {
    //      NavigationView {
    ExperienceView()
    //      }
  }
}

extension UIView {
  func toImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
    self.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}

@MainActor
final class AddExperienceViewModel: ObservableObject {
  func saveImage(item: Image) {
    Task {
      // Konversi Image menjadi UIImage
      guard let uiImage = UIImage(systemName: "icloud.and.arrow.up.fill") else {
        // Handle error jika tidak dapat mengonversi Image ke UIImage
        print("Gagal mengonversi Image ke UIImage")
        return
      }
      
      // Menyimpan UIImage ke galeri
      PHPhotoLibrary.shared().performChanges {
        let request = PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
//        request.placeholderForCreatedAsset?.isHidden = false
      } completionHandler: { success, error in
        if success {
          print("Gambar berhasil disimpan ke galeri.")
        } else if let error = error {
          print("Error saat menyimpan gambar: \(error.localizedDescription)")
        }
      }
    }
  }
}

struct AddExperienceView: View {
  
  @State private var currentDateAndTime: String = ""
  @State private var gameTitle: String = ""
  @State private var gameDeveloper: String = ""
  @State private var gameDescription: String = ""
  @State private var gameUrl: String = ""
  @State private var showingImagePicker: Bool = false
  @State private var chosenImage: UIImage?
  @State private var image: Image?
  @State private var hideRemoveButton: Bool = true
  @State private var addingExperience: Bool = false
  @StateObject private var viewModel = AddExperienceViewModel()
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: 10) {
        Text("Game Thumbnail".uppercased())
          .font(.caption)
          .foregroundColor(Color.gray)
        ZStack {
          VStack(spacing: 10) {
            Image(systemName: "icloud.and.arrow.up.fill")
              .font(.largeTitle)
            Text("Pick a photo from gallery")
          }
          .isHidden(!hideRemoveButton)
          image?
            .resizable()
            .scaledToFit()
        }
        .foregroundColor(Color.gray)
        .frame(maxWidth: .infinity)
        .frame(height: getRect().height * 0.2)
        .background(Color.gray.opacity(CGFloat(.fieldOpacity)))
        .cornerRadius(10)
        .onTapGesture {
          showingImagePicker.toggle()
        }
        HStack(spacing: 15) {
          Button {
            showingImagePicker.toggle()
          } label: {
            Text("Choose Image...")
          }
          Button {
            image = nil
            hideRemoveButton = true
          } label: {
            Image(systemName: "trash")
              .foregroundColor(Color.red)
          }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .isHidden(hideRemoveButton)
        Text("Game Detail".uppercased())
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
        TextField("Game title", text: $gameTitle)
          .modifier(TextFieldStyle())
        TextField("Developer", text: $gameDeveloper)
          .modifier(TextFieldStyle())
        TextField("Description", text: $gameDescription)
          .modifier(TextFieldStyle())
        TextField("Homepage/URL", text: $gameUrl)
          .modifier(TextFieldStyle())
        Text("Created at: \(currentDateAndTime)")
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
          .frame(maxWidth: .infinity, alignment: .leading)
        Button {
          addingExperience.toggle()
          viewModel.saveImage(item: image ?? Image(""))
        } label: {
          if !addingExperience {
            Text("Add experience")
              .modifier(TextFieldButtonStyle(isDisabled: $addingExperience))
          } else {
            ProgressView()
              .modifier(TextFieldButtonStyle(isDisabled: $addingExperience))
          }
        }
        .disabled(addingExperience ? true : false)
        .padding(.top, getRect().height * 0.03)
      }
      .padding(.horizontal)
      .padding(.bottom, getRect().height * 0.2)
      .onChange(of: chosenImage) { _ in
        loadImage()
        if chosenImage != nil {
          hideRemoveButton = false
        }
      }
      .sheet(isPresented: $showingImagePicker) {
        ImagePicker(image: $chosenImage)
      }
      .onAppear {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let date = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "HH"
        let hour = dateFormatter.string(from: currentDate)
        dateFormatter.dateFormat = "mm"
        let mins = dateFormatter.string(from: currentDate)
        self.currentDateAndTime = "\(date) \(month) \(year) @ \(hour):\(mins)"
      }
    }
  }
  
  func loadImage() {
    guard let inputImage = chosenImage else { return }
    image = Image(uiImage: inputImage)
  }
}
