//
//  UpdateEmailView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 02/09/23.
//

import SwiftUI

@MainActor
final class UpdateEmailViewModel: ObservableObject {
  
  @Published var newEmail: String = ""
  @Published var currentEmail: String = ""
  @Published var currentPassword: String = ""
  @Published var localizedError: String = ""
  
  func update(email: String) async throws {
    try AuthManager.instance.logoutUser()
    
    try await AuthManager.instance.signInUser(email: currentEmail, password: currentPassword)
    
    try await AuthManager.instance.updateEmail(email: self.newEmail)
  }
}

struct UpdateEmailView: View {
  
  @Binding var showSignInView: Bool
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @State private var isUpdating: Bool = false
  @StateObject private var viewModel = UpdateEmailViewModel()
  @State private var alertState: Bool = false
  
  var body: some View {
    let emailTF = Binding<String>(get: {
      viewModel.newEmail
    }, set: {
      viewModel.newEmail = $0.lowercased()
    })
    return NavigationView {
      ZStack {
        colorScheme == .light ? Color(hex: "F2F2F7").ignoresSafeArea() : Color.black.ignoresSafeArea()
        VStack(spacing: 5) {
          Text("Current Password")
            .frame(maxWidth: .infinity, alignment: .leading)
          SecureField("Current Password", text: $viewModel.currentPassword)
            .modifier(TextFieldStyle())
          Text("New Email Address")
            .frame(maxWidth: .infinity, alignment: .leading)
          TextField("New Email Address", text: emailTF, onCommit: {
            isUpdating = true
            Task {
              do {
                try await viewModel.update(email: viewModel.newEmail)
                alertState.toggle()
              } catch {
                viewModel.localizedError = error.localizedDescription
                viewModel.currentPassword = ""
              }
              isUpdating = false
            }
          })
          .keyboardType(.emailAddress)
          .modifier(TextFieldStyle())
          Text("\(viewModel.localizedError.isEmpty ? "" : viewModel.localizedError)")
            .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .bold))
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(!isUpdating && viewModel.newEmail.isEmpty ? 1 : 0)
          Button {
            isUpdating = true
            Task {
              do {
                try await viewModel.update(email: viewModel.newEmail)
                alertState.toggle()
              } catch {
                viewModel.localizedError = error.localizedDescription
                viewModel.currentPassword = ""
              }
              isUpdating = false
            }
          } label: {
            if !isUpdating {
              Text("Update email")
                .modifier(TextFieldButtonStyle(isDisabled: $isUpdating))
            } else if isUpdating {
              ProgressView()
                .modifier(TextFieldButtonStyle(isDisabled: $isUpdating))
            }
          }
          .padding(.top, getRect().height * 0.03)
          .disabled(isUpdating ? true : false)
          Spacer()
        }
        .padding(.horizontal)
        .alert(isPresented: $alertState) {
          Alert(
            title: Text("Success"), // Empty title
            message: Text("Your email has been updated to \(viewModel.newEmail). Please sign in again."),
            dismissButton: .default(Text("OK"), action: {
              presentation.wrappedValue.dismiss()
              showSignInView = true
            })
          )
        }
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button {
              presentation.wrappedValue.dismiss()
            } label: {
              Text("Cancel")
            }
          }
        }
        .navigationTitle("Update Email")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
          Task {
            do {
              viewModel.currentEmail = try AuthManager.instance.getAuthUser().email ?? ""
            }
          }
        }
      }
    }
  }
}

struct UpdateEmailView_Previews: PreviewProvider {
    static var previews: some View {
      UpdateEmailView(showSignInView: .constant(false))
    }
}
