//
//  ProfileView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI
import SDWebImageSwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
  
  @Published private(set) var user: FSUser? = nil
  @Published var localizedError: String = ""
  @Published var imageProfile: Image?
  
  func logOut() throws {
    try AuthManager.instance.logoutUser()
  }
  
  func initLoadUser() async {
    do {
      let auth = try await AuthManager.instance.getAuthUser()
      let result = try await AuthManager.instance.getFSUser(user: auth)
      self.user = result
    } catch {
    }
  }
  
  func getUserFullname() -> String {
    return user?.fullname ?? ""
  }
  
  func getUsername() -> String {
    return user?.username ?? ""
  }
  
  func getProfilePicture() -> String {
    return user?.photoUrl ?? ""
  }
  
  func resetPassword() async throws {
    let auth = try AuthManager.instance.getAuthUser()
    guard let email = auth.email else {
      throw URLError(.fileDoesNotExist)
    }
    try await AuthManager.instance.resetPassword(email: email)
  }
  
  func saveImage(item: Image) async throws {
    Task {
      let auth = try AuthManager.instance.getAuthUser()
      let uiImage = item.asUIImage()
      let jpegData = uiImage.jpegData(compressionQuality: 0.1)
      let (path, name) = try await StorageManager.instance.saveImgProf(data: jpegData!, userId: auth.uid)
      try await AuthManager.instance.addProfPic(path: path, filename: name)
    }
  }
  
  func deleteImage() async throws {
    try await AuthManager.instance.deleteProfPic()
  }
}

struct ProfileView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentation
  @StateObject private var viewModel = ProfileViewModel()
  @Binding var showSignInView: Bool
  @State private var selected: Int = 0
  @State private var isResettingPw: Bool = false
  @State private var alertState: Bool = false
  @State private var updatePasswordViewSheet: Bool = false
  @State private var updateEmailViewSheet: Bool = false
  @State private var deleteAccountViewSheet: Bool = false
  @State private var editProfileViewSheet: Bool = false
  @State private var userFullname: String = ""
  @State private var username: String = ""
  @State var profilePic: String = ""
  @State private var uploadOptSheet: Bool = false
  @State private var showingImagePicker: Bool = false
  @State private var chosenImage: UIImage?
  @State private var isUploading: Bool = false
  
  var body: some View {
    //    ScrollView(.vertical) {
    VStack(alignment: .leading) {
      ZStack {
        Rectangle()
          .fill(Color(hex: "4E3728"))
          .frame(height: getRect().height * 0.3)
        Button {
          print("Header PPicker")
        } label: {
          Image(systemName: "camera.fill")
            .foregroundColor(Color.black)
            .font(.headline)
            .background(
              Circle()
                .fill(Color(hex: "#dcdce1"))
                .frame(width: getRect().width * 0.075, height: getRect().height * 0.075)
            )
            .frame(maxWidth: .infinity, maxHeight: getRect().height * 0.3, alignment: .bottomTrailing)
            .offset(x: -16, y: -16)
        }
        .hidden()
      }
      ZStack {
        ZStack {
          Circle()
            .fill(colorScheme == .light ? Color(hex: "#F2F2F7") : Color.black)
            .frame(width: getRect().height * 0.16, height: getRect().height * 0.16)
          ZStack {
            WebImage(url: URL(string: profilePic))
              .resizable()
              .placeholder(Image("sample-profile"))
              .frame(width: getRect().height * 0.15, height: getRect().height * 0.15)
              .opacity(isUploading ?  0.2 : 1)
            ProgressView()
              .opacity(isUploading ?  1 : 0)
          }
          .mask(
            Circle()
          )
        }
        .padding(.leading)
        Button {
          uploadOptSheet.toggle()
        } label: {
          Image(systemName: "camera.fill")
            .foregroundColor(Color.black)
            .font(.headline)
            .background(
              Circle()
                .fill(Color(hex: "#dcdce1"))
                .frame(width: getRect().width * 0.075, height: getRect().height * 0.075)
            )
            .frame(width: getRect().height * 0.17, height: getRect().height * 0.12, alignment: .bottomTrailing)
        }
        .actionSheet(isPresented: $uploadOptSheet) {
          let browse = ActionSheet.Button.default(Text("Browse Photo...")) { showingImagePicker.toggle() }
          let delete = ActionSheet.Button.destructive(Text("Delete Photo")) {
            Task {
              do {
                try await viewModel.deleteImage()
                chosenImage = nil
                self.profilePic = ""
              }
            }
          }
          let cancel = ActionSheet.Button.cancel(Text("Cancel")) {  }
          var buttons: [ActionSheet.Button] = [browse, cancel, delete]
          if profilePic.isEmpty {
            buttons.removeLast()
          }
          return ActionSheet(title: Text("Edit Profile Photo"), buttons: buttons)
        }
        .sheet(isPresented: $showingImagePicker) {
          ImagePicker(image: $chosenImage)
        }
        .onChange(of: chosenImage) { _ in
          self.isUploading = true
          if profilePic.isEmpty {
            Task {
              try await viewModel.deleteImage()
              chosenImage = nil
              self.profilePic = ""
            }
          }
          Task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              Task {
                try await loadImage()
              }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              Task {
                try await loadData()
                self.isUploading = false
              }
            }
          }
        }
      }
      .offset(y: -getRect().height * 0.12)
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 0) {
          Text("\(userFullname.isEmpty ? "Loading..." : userFullname)")
            .foregroundColor(userFullname.isEmpty ? Color.gray.opacity(0.3) : colorScheme == .light ? Color.black : Color.white)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
          Text("\(username.isEmpty ? "Unknown" : "@" + username)")
            .opacity(username.isEmpty ? 0 : 1)
            .foregroundColor(Color.gray)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular))
        }
        .offset(y: -15)
        Text("Account Settings".uppercased())
          .offset(y: 5)
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
          .padding(.leading, 16)
        VStack(alignment: .trailing, spacing: 0) {
          Button {
            editProfileViewSheet.toggle()
          } label: {
            CustomButtonStyle(title: "Update profile info")
          }
          .sheet(isPresented: $editProfileViewSheet, onDismiss: {
            Task {
              do {
                try await loadData()
              }
            }
          }) {
            EditProfileView(user: viewModel.user)
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            isResettingPw = true
            viewModel.localizedError = ""
            Task {
              do {
                try await viewModel.resetPassword()
                alertState.toggle()
                isResettingPw = false
              } catch {
                viewModel.localizedError = error.localizedDescription
                alertState.toggle()
                isResettingPw = false
              }
            }
          } label: {
            CustomButtonStyle(title: "Reset password", titleInProgress: "Resetting password...", inProgress: isResettingPw)
          }
          .disabled(isResettingPw ? true : false)
          .alert(isPresented: $alertState) {
            Alert(
              title: Text("\(viewModel.localizedError.isEmpty ? "Success" : "Error")"), // Empty title
              message: Text("\(viewModel.localizedError.isEmpty ? "Check your mail inbox/spam and follow the instruction to reset password." : viewModel.localizedError)"),
              dismissButton: .default(Text("OK"), action: {
                presentation.wrappedValue.dismiss()
              }))
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            updatePasswordViewSheet.toggle()
          } label: {
            CustomButtonStyle(title: "Update password")
          }
          .sheet(isPresented: $updatePasswordViewSheet) {
            UpdatePasswordView(showSignInView: $showSignInView)
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            updateEmailViewSheet.toggle()
          } label: {
            CustomButtonStyle(title: "Update email")
          }
          .sheet(isPresented: $updateEmailViewSheet) {
            UpdateEmailView(showSignInView: $showSignInView)
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            deleteAccountViewSheet.toggle()
          } label: {
            CustomButtonStyle(title: "Delete account", color: Color.red, isDisabled: viewModel.user == nil ? true: false)
          }
          .sheet(isPresented: $deleteAccountViewSheet) {
            DeleteAccountView(showSignInView: $showSignInView)
          }
        }
        .disabled(viewModel.user == nil ? true : false)
        .frame(maxWidth: .infinity)
        .background(colorScheme == .light ? Color.white : Color(hex: "1C1C1E"))
        .cornerRadius(10)
        Button {
          Task {
            do {
              try viewModel.logOut()
              showSignInView = true
            }
          }
        } label: {
          CustomButtonStyle(title: "Log out")
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .light ? Color.white : Color(hex: "1C1C1E"))
        .cornerRadius(10)
        .padding(.top, getRect().height * 0.03)
      }
      .offset(y: -getRect().height * 0.1)
      .padding(.horizontal, 16)
    }
    .frame(minHeight: getRect().height * 0.7)
    .background(colorScheme == .light ? Color(hex: "#F2F2F7") : Color.black)
    .onAppear {
      Task {
        do {
          try await loadData()
        }
      }
    }
  }
  
  func loadData() async throws {
    try? await viewModel.initLoadUser()
    self.userFullname = viewModel.getUserFullname()
    self.username = viewModel.getUsername()
    self.profilePic = viewModel.getProfilePicture()
  }
  
  func loadImage() async throws {
    guard let inputImage = chosenImage else { return }
    viewModel.imageProfile = Image(uiImage: inputImage)
    
    Task {
      do {
        try await viewModel.saveImage(item: viewModel.imageProfile!)
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(showSignInView: .constant(false))
  }
}

