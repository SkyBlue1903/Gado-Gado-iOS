//
//  AddExperienceView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 18/09/23.
//

import SwiftUI
import BottomSheet

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
      let jpegData = uiImage.jpegData(compressionQuality:1)
      let (path, name) = try await StorageManager.instance.saveImgProf(data: jpegData!)
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
            .autocapitalization(.none)
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
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                addingExperience.toggle()
                bottomSheetPosition = .hidden
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
        .disabled(addingExperience || formCheck())
        .padding(.top, getRect().height * 0.03)
      }
      .padding([.horizontal, .bottom])
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
    
    Rectangle()
      .border(width: 0.5, edges: [.top], color: colorScheme == .light ? Color(hex: "BDBDBD") : Color(hex: "202020"))
      .foregroundColor(colorScheme == .light ? Color(hex: "F5F5F5") : Color(hex: "292929"))
      .frame(width: getRect().width, height: 50 + ExtensionManager.instance.getHomeBarHeight())
  }
  
  func loadImage() {
    guard let inputImage = chosenImage else { return }
    viewModel.image = Image(uiImage: inputImage)
  }
  
  func formCheck() -> Bool {
    let title = viewModel.gameTitle == ""
    let dev = viewModel.gameDeveloper == ""
    let desc = viewModel.gameDescription == ""
    let url = viewModel.gameUrl == ""
    let plats = viewModel.platforms == []
    let genres = viewModel.genres == []
    let img = viewModel.image == nil
    return (title || dev || desc || url || plats || genres || img)
  }
}
