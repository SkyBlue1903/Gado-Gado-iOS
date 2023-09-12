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
  @State private var bottomSheetPosition: BottomSheetPosition = .absoluteTop(500)
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
        ToolbarItem(placement: .primaryAction) {
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
        AddExperienceView(bottomSheetPosition: $bottomSheetPosition)
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
    ExperienceView()
  }
}

@MainActor
final class AddExperienceViewModel: ObservableObject {
  
  @Published var gameTitle: String = ""
  @Published var gameDeveloper: String = ""
  @Published var gameDescription: String = ""
  @Published var gameUrl: String = ""
  @Published var platforms: [String] = []
  @Published var genres: [String] = []
  @Published var image: Image?
  
  func saveWithImage(item: Image) async throws {
    Task {
      let uiImage = item.asUIImage()
      //      let pngData = uiImage.pngData()
      let jpegData = uiImage.jpegData(compressionQuality: 0.1)
      let (path, name) = try await StorageManager.instance.saveImage(data: jpegData!)
      try await GameManager.instance.addExperience(title: self.gameTitle, dev: self.gameDeveloper, desc: self.gameDescription, urlPage: self.gameUrl, platforms: self.platforms, genres: self.genres, imgName: name, imgUrl: path)
    }
  }
  
  func saveData() async throws {
    if image != nil {
      try await saveWithImage(item: self.image!)
    } else {
      try await GameManager.instance.addExperience(title: self.gameTitle, dev: self.gameDeveloper, desc: self.gameDescription, urlPage: self.gameUrl, platforms: self.platforms, genres: self.genres)
    }
  }
  
}

struct AddExperienceView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var currentDateAndTime: String = ""
  @State private var showingImagePicker: Bool = false
  @State private var chosenImage: UIImage?
  @State private var hideRemoveButton: Bool = true
  @State private var addingExperience: Bool = false
  @StateObject private var viewModel = AddExperienceViewModel()
  @Binding var bottomSheetPosition: BottomSheetPosition
  
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
          viewModel.image?
            .resizable()
            .scaledToFit()
        }
        .foregroundColor(Color.gray)
        .frame(maxWidth: .infinity)
        .frame(height: getRect().height * 0.2)
        .background(colorScheme == .light ? Color.white : Color(hex: "1C1C1E"))
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
            viewModel.image = nil
            hideRemoveButton = true
          } label: {
            Image(systemName: "trash")
              .foregroundColor(Color.red)
          }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .isHidden(hideRemoveButton)
        Group {
          Text("Game Detail".uppercased())
            .font(.caption)
            .foregroundColor(Color(hex: "727272"))
          TextField("Game title", text: $viewModel.gameTitle)
            .modifier(TextFieldStyle())
          TextField("Developer", text: $viewModel.gameDeveloper)
            .modifier(TextFieldStyle())
          TextField("Description", text: $viewModel.gameDescription)
            .modifier(TextFieldStyle())
          TextField("Homepage/URL", text: $viewModel.gameUrl)
            .modifier(TextFieldStyle())
          NavigationLink(destination: PlatformSelectView(selections: $viewModel.platforms)) {
            HStack {
              Text("Platform")
              Spacer()
              Text("\(viewModel.platforms.arrayToString())")
                .frame(width: getRect().width * 0.6, alignment: .trailing)
              Image(systemName: "chevron.right")
            }
            .frame(maxWidth: .infinity)
            .modifier(TextFieldStyle())
            //            .frame(maxWidth: getRect().width)
          }
          .buttonStyle(.plain)
          NavigationLink(destination: GenreView(genres: $viewModel.genres), label: {
            HStack {
              Text("Genre")
              Spacer()
              Text("\(viewModel.genres.arrayToString())")
                .frame(width: getRect().width * 0.6, alignment: .trailing)
              Image(systemName: "chevron.right")
            }
            .frame(maxWidth: .infinity)
            .modifier(TextFieldStyle())
          })
          .buttonStyle(.plain)
        }
        Text("Created at: \(currentDateAndTime)")
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
          .frame(maxWidth: .infinity, alignment: .leading)
        Button {
          addingExperience.toggle()
          Task {
            do {
              try await viewModel.saveData()
              bottomSheetPosition = .hidden
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                addingExperience.toggle()
              }
            } catch {
              print("error adding:", error.localizedDescription)
              addingExperience.toggle()
            }
          }
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
    viewModel.image = Image(uiImage: inputImage)
  }
}
