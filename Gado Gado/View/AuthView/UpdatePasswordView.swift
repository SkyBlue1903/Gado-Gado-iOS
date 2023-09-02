//
//  UpdattePasswordView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 01/09/23.
//

import SwiftUI

@MainActor
final class UpdatePasswordViewModel: ObservableObject {
  
  @Published var localizedError: String = ""
  @Published var email: String = ""
  @Published var currentPassword: String = ""
  @Published var newPassword: String = ""
  @Published var confirmPassword: String = ""
  
  func updatePassword() async throws {
    try await AuthManager.instance.logoutUser()
    
    
    try await AuthManager.instance.signInUser(email: self.email, password: self.currentPassword)
    
    try await AuthManager.instance.updatePassword(password: self.confirmPassword)
  }
}

struct UpdatePasswordView: View {
  
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @Binding var showSignInView: Bool
  @StateObject private var viewModel = UpdatePasswordViewModel()
  @State private var isResetting: Bool = false
  @State private var alertState: Bool = false
  
  var body: some View {
    return NavigationView {
      ZStack {
        colorScheme == .light ? Color(hex: "F2F2F7").ignoresSafeArea() : Color.black.ignoresSafeArea()
        VStack(spacing: 5) {
          Text("Current Password")
            .frame(maxWidth: .infinity, alignment: .leading)
          SecureField("Current Password", text: $viewModel.currentPassword)
          .modifier(TextFieldStyle())
          Text("New Password")
            .frame(maxWidth: .infinity, alignment: .leading)
          SecureField("New Password", text: $viewModel.newPassword)
            .modifier(TextFieldStyle())
          Text("Confirm Password")
            .frame(maxWidth: .infinity, alignment: .leading)
          SecureField("Confirm Password", text: $viewModel.confirmPassword)
            .modifier(TextFieldStyle())
          Text("\(viewModel.localizedError.isEmpty ? "-" : viewModel.localizedError)")
            .opacity(viewModel.localizedError.isEmpty ? 0 : 1)
            .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .bold))
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity, alignment: .leading)
          Button {
            isResetting = true
            print("Pressed")
            Task {
              do {
                try await viewModel.updatePassword()
                alertState.toggle()
              } catch {
                viewModel.localizedError = error.localizedDescription
                viewModel.currentPassword = ""
              }
              isResetting = false
            }
          } label: {
            if !isResetting {
              Text("Update password")
            } else if isResetting /*&& !viewModel.email.isEmpty*/ {
              ProgressView()
            }
          }
          .modifier(TextFieldButtonStyle(isDisabled: $isResetting))
          .padding(.top, getRect().height * 0.03)
          .disabled(isResetting ? true : false)
          Spacer()
        }
        .padding(.horizontal)
        .alert(isPresented: $alertState) {
          Alert(
            title: Text("Success"), // Empty title
            message: Text("Password changed successfully, please sign in back again."),
            dismissButton: .default(Text("OK"), action: {
              DispatchQueue.main.async {
                presentation.wrappedValue.dismiss()
                showSignInView = true
              }
            })
          )
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              presentation.wrappedValue.dismiss()
            } label: {
              Text("Cancel")
            }
          }
        }
        .navigationTitle("Update Password")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color(.primaryApp))
        .onAppear {
          Task {
            let auth = try await AuthManager.instance.getAuthUser()
            viewModel.email = auth.email ?? ""
          }
        }
      }
    }
  }
}

struct UpdatePasswordView_Previews: PreviewProvider {
  static var previews: some View {
    UpdatePasswordView(showSignInView: .constant(false))
  }
}
