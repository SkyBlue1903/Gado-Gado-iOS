//
//  SignUpView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 27/08/23.
//

import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
  
  @Published var username: String = ""
  @Published var fullname: String = ""
  @Published var email: String = ""
  @Published var password: String = ""
  
  func signUp() async throws {
    let auth = try await AuthManager.instance.createUser(email: self.email, password: self.password, fullname: self.fullname, username: self.username)
  }
}

struct SignUpView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @StateObject private var viewModel = SignUpViewModel()
  @Binding var showSignInView: Bool
  @State private var isSigningUp: Bool = false
  @State private var goToSignInView: Bool = false
  
  var body: some View {
    Form {
      TextField("Username", text: $viewModel.username)
        .autocapitalization(.none)
        .autocorrectionDisabled()
      TextField("Fullname", text: $viewModel.fullname)
        .autocapitalization(.words)
        .autocorrectionDisabled()
      TextField("Email", text: $viewModel.email)
        .autocapitalization(.none)
        .autocorrectionDisabled()
      SecureField("Password", text: $viewModel.password)
      Section {
        Button {
          isSigningUp = true
          Task {
            do {
              try await viewModel.signUp()
              showSignInView = false
              isSigningUp = false
            } catch {
              isSigningUp = false
            }
          }
        } label: {
          if !isSigningUp {
            Text(!isSigningUp ? "Sign Up" : "")
              .font(.headline)
              .frame(maxWidth: .infinity)
              .foregroundColor(.white)
              .cornerRadius(10)
          } else {
            ProgressView()
              .font(.headline)
              .frame(maxWidth: .infinity)
              .foregroundColor(.white)
              .cornerRadius(10)
          }
        }
        .disabled(!isSigningUp ? false : true)
        .tag(1)
        .listRowBackground(!isSigningUp ? Color.accentColor : Color.gray.opacity(0.5))
      }
    }
    .navigationTitle("Sign Up")
    .navigationBarTitleDisplayMode(.large)
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView() {
      SignUpView(showSignInView: .constant(false))
    }
  }
}
