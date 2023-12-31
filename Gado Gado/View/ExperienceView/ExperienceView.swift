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

@MainActor
final class ExperienceViewModel: ObservableObject {
  @Published var userExperiences: [Game] = []
  
  func refresh() async throws {
    self.userExperiences = try await GameManager.instance.userExperiences()
  }
}

struct ExperienceView: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var editBottomSheet: BottomSheetPosition = .hidden
  @State private var addBottomSheet: BottomSheetPosition = .hidden
  //  @State private var navTitle: String = ""
  @State private var isSignedIn: Bool = true
  @State private var allExperiences: [Game] = []
  @State private var editExperience = Game(id: "", title: "", urlSite: "", image: "", imageFilename: "", date: Date(), genres: [], platforms: [], developer: "", desc: "", engines: [])
  @StateObject private var viewModel = ExperienceViewModel()
  
  var body: some View {
    if editBottomSheet == .hidden {
      Task {
        do {
          try await viewModel.refresh()
        }
      }
    }
    return AnyView (
//      NavigationView {
        GeometryReader { geometry in
          ZStack(alignment: .bottomTrailing) {
            if isSignedIn {
              if viewModel.userExperiences.isEmpty {
                ZStack {
                  Text("Create your first experience by tapping \"+\" icon on upper right corner")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .frame(maxWidth: getRect().width)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
              } else {
                ScrollView(.vertical) {
                  ForEach(viewModel.userExperiences, id: \.self) { each in
                    ExperienceCardView(data: each)
                      .frame(height: getRect().height * 0.15)
                      .onTapGesture {
                        editBottomSheet = .relativeTop(0.6)
                        editExperience = each
                      }
                      .padding(.vertical, 6)
                  }
                  .padding([.horizontal, .bottom])
                }
              }
            } else {
              Text("Please Sign In / Sign Up to enjoy full experience")
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            }
            
            VStack {
              Spacer()
              Button(action: {
                // Action to be performed when the button is tapped
                addBottomSheet = .relativeTop(0.6)
                print("Button tapped!")
              }) {
                Image(systemName: "plus")
                  .font(.title3)
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.accentColor)
                  .cornerRadius(30)
                  .padding([.bottom, .trailing])
              }
              .zIndex(1) // Place the button above the list
            }
          }
        }
//        .navigationTitle("Experience")
//        .toolbar {
//          ToolbarItem(placement: .primaryAction) {
//            Button {
//              addBottomSheet = .relativeTop(0.6)
//            } label: {
//              Image(systemName: "plus")
//            }
//          }
//        }
        .disabled(!isSignedIn)
        .onAppear {
          Task {
            do {
              try await viewModel.refresh()
              //              fetchUser()
            }
          }
        }
        .bottomSheet(bottomSheetPosition: self.$addBottomSheet, switchablePositions: [.relativeTop(0.3), .relativeTop(0.6), .relativeTop(0.85)], title: "Add Experience") {
          AddExperienceView(bottomSheetPosition: $addBottomSheet)
        }
        .enableTapToDismiss(true)
        .showCloseButton(true)
        .showDragIndicator(true)
        .enableBackgroundBlur(true)
        .enableSwipeToDismiss(true)
        
        .bottomSheet(bottomSheetPosition: self.$editBottomSheet, switchablePositions: [.relativeTop(0.3), .relativeTop(0.6), .relativeTop(0.85)], title: "Edit Experience") {
          EditExperienceView(bottomSheetPosition: $editBottomSheet, data: self.editExperience)
        }
        .enableTapToDismiss(true)
        .showCloseButton(true)
        .showDragIndicator(true)
        .enableBackgroundBlur(true)
        .enableSwipeToDismiss(true)
//      }
    )
  }
  
  private func fetchUser() {
    let auth = try? AuthManager.instance.getAuthUser()
    self.isSignedIn = auth == nil
  }
}

struct ExperienceView_Previews: PreviewProvider {
  static var previews: some View {
    ExperienceView()
  }
}
