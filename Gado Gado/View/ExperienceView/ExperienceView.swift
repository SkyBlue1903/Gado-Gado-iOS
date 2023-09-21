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
//    print("EXPERIENCES:", self.userExperiences)
  }
}

struct ExperienceView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @State private var editBottomSheet: BottomSheetPosition = .hidden
  @State private var addBottomSheet: BottomSheetPosition = .hidden
  @State private var navTitle: String = ""
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
      NavigationView {
        GeometryReader { geometry in
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
  //              NavigationLink(destination: GameDetailView(currentGame: each)) {
                  ExperienceCardView(data: each)
                    .frame(height: getRect().height * 0.15)
                    .onTapGesture {
                      editBottomSheet = .relativeTop(0.6)
                      editExperience = each
                    }
  //              }
                .padding(.vertical, 6)
              }
              .padding([.horizontal, .bottom])
            }
          }
          
        }
        //        .opacity(bottomSheetPosition == .hidden ? 1 : 0)
  //      .onChange(of: editBottomSheet, perform: { newValue in
  //        print("IAM CHANGED:", newValue)
  //        if newValue == .hidden  {
  //          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
  //            Task {
  //              do {
  //                try await viewModel.refresh()
  //              }
  //            }
  //          }
  //        }
  //      })
        .navigationTitle("Experience")
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            //            Image(systemName: "plus")
            Button {
              // ACTION OPEN SHEET
              addBottomSheet = .relativeTop(0.6)
            } label: {
              Image(systemName: "plus")
            }
          }
        }
        .onAppear {
          Task {
            do {
              try await viewModel.refresh()
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
      }
    )
  }
}

struct ExperienceView_Previews: PreviewProvider {
  static var previews: some View {
    ExperienceView()
  }
}
