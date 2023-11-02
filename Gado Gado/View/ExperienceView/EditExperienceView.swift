//
//  EditExperienceView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 18/09/23.
//

import SwiftUI
import BottomSheet
import SDWebImageSwiftUI

@MainActor
final class EditExperienceViewModel: ObservableObject {
  
  @Published var gameTitle: String = ""
  @Published var gameDeveloper: String = ""
  @Published var gameDescription: String = ""
  @Published var gameUrl: String = ""
  @Published var platforms: [String] = []
  @Published var genres: [String] = []
  @Published var image: Image?
  @Published var dateModified: Date = Date()
  @Published var gameId: String = ""
  
  func saveWithImage(item: Image) async throws {
    Task {
      let uiImage = item.asUIImage()
      //      let pngData = uiImage.pngData()
      let jpegData = uiImage.jpegData(compressionQuality:1)
      let (path, name) = try await StorageManager.instance.saveImgProf(data: jpegData!)
//      try await GameManager.instance.addExperience(title: self.gameTitle, dev: self.gameDeveloper, desc: self.gameDescription, urlPage: self.gameUrl, platforms: self.platforms, genres: self.genres, imgName: name, imgUrl: path)
      try await GameManager.instance.editExperience(gameId: self.gameId, title: self.gameTitle, dev: self.gameDeveloper, desc: self.gameDescription, urlPage: self.gameUrl, platforms: self.platforms, genres: self.genres, imgName: name, imgUrl: path)
    }
  }
  
  func saveData() async throws {
    if image != nil {
      try await saveWithImage(item: self.image!)
    } else {
      try await GameManager.instance.addExperience(title: self.gameTitle, dev: self.gameDeveloper, desc: self.gameDescription, urlPage: self.gameUrl, platforms: self.platforms, genres: self.genres)
    }
  }
  
  func deleteData(gameId: String, withImage: Bool, imgFilename: String = "") async throws {
    try await GameManager.instance.delExperience(gameId: gameId, withImage: withImage, imgFilename: imgFilename)
  }
  
  func deleteImage(gameId: String, imgFilename: String) async throws {
    try await GameManager.instance.delImgExp(gameId: gameId, imgFilename: imgFilename, delRefOnly: true)
  }
}

struct EditExperienceView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var currentDateAndTime: String = ""
  @State private var showingImagePicker: Bool = false
  @State private var chosenImage: UIImage?
  @State private var hideRemoveButton: Bool = false
  @State private var editingExperience: Bool = false
  @State private var deletingExperience: Bool = false
  @StateObject private var viewModel = EditExperienceViewModel()
  @Binding var bottomSheetPosition: BottomSheetPosition
  
  var data: Game
  
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
          .isHidden(!hideRemoveButton && viewModel.image != nil)
            WebImage(url: URL(string: data.image ?? ""))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipped()
              .opacity(viewModel.image == nil && !hideRemoveButton ? 1 : 0)
            viewModel.image?
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipped()
//          }
          
          let _ = print("VM IMAGE:", viewModel.image)
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
            Text("Change Image...")
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
        .isHidden(hideRemoveButton/*&& data.image?.isEmpty ?? false*/)
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
        Text("Last modified at: \(currentDateAndTime)")
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
          .frame(maxWidth: .infinity, alignment: .leading)
        Button {
          editingExperience.toggle()
          Task {
            do {
              try await viewModel.deleteImage(gameId: data.id, imgFilename: data.imageFilename ?? "")
              try await viewModel.saveData()
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                  editingExperience.toggle()
                                  bottomSheetPosition = .hidden
              }
              // MARK: NEW CODE
//              viewModel.deleteImage(gameId: data.id, imgFilename: data.imageFilename ?? "", success: {
//                viewModel.saveData(success: {
//                  editingExperience.toggle()
//                  bottomSheetPosition = .hidden
//                }, failure: { error in
//                  print("error saving data: \(error.localizedDescription)")
//                })
//              }, failure: { error in
//                print("error deleting: \(error.localizedDescription)")
//              })
              // -- end new code --
            } catch {
              print("error adding:", error.localizedDescription)
              editingExperience.toggle()
            }
          }
          ///  MARK: PLEASE EDIT `HERE!!
        } label: {
          if !editingExperience {
            Text("Save experience")
              .modifier(TextFieldButtonStyle(isDisabled: $editingExperience))
          } else {
            ProgressView()
              .modifier(TextFieldButtonStyle(isDisabled: $editingExperience))
          }
        }
        .disabled(deletingExperience || editingExperience || checkField())
        .padding(.top, getRect().height * 0.03)
        Button {
          deletingExperience = true
          Task {
            do {
              try await viewModel.deleteData(gameId: data.id, withImage: true, imgFilename: data.imageFilename ?? "")
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                editingExperience.toggle()
                bottomSheetPosition = .hidden
                deletingExperience = true
              }
            }
          }
        } label: {
          if deletingExperience {
            ProgressView()
              .frame(maxWidth: .infinity)
              .padding(.horizontal)
          } else {
            Text("Delete experience")
              .foregroundColor(Color.red)
              .frame(maxWidth: .infinity)
              .padding(.horizontal)
          }
        }
        .disabled(deletingExperience || editingExperience)
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
        let currentDate = data.date ?? Date()
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
        
        //        viewModel.image = WebImage(URL(string: data?.image ?? ""))
        viewModel.gameTitle = data.title ?? ""
        viewModel.gameDeveloper = data.developer ?? ""
        viewModel.gameDescription = data.desc ?? ""
        viewModel.gameUrl = data.urlSite ?? ""
        viewModel.platforms = data.platforms ?? []
        viewModel.genres = data.genres ?? []
        viewModel.gameId = data.id
        //        viewModel.dateModified = data.date ?? Date()
      }
    }
    Rectangle()
      .foregroundColor(colorScheme == .light ? Color(hex: "F5F5F5") : Color(hex: "292929"))
      .frame(width: getRect().width, height: 50 + ExtensionManager.instance.getHomeBarHeight())
  }
  
  func loadImage() {
    guard let inputImage = chosenImage else { return }
    viewModel.image = Image(uiImage: inputImage)
  }
  
  func checkField() -> Bool {
    let image = viewModel.image == nil
    let title = viewModel.gameTitle == data.title ?? ""
    let dev = viewModel.gameDeveloper == data.developer ?? ""
    let desc = viewModel.gameDescription == data.desc ?? ""
    let url = viewModel.gameUrl == data.urlSite ?? ""
    let plats = viewModel.platforms == data.platforms ?? []
    let genres = viewModel.genres == data.genres ?? []
    print("""
Current image: \(viewModel.image)
Current bool: \(image)
""")
    return (title && dev && desc && url && plats && genres && image)
    
    //      MARK: CEK BAGIAN SINI!!!!
  }
}

