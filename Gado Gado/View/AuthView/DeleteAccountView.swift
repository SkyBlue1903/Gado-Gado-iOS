//
//  DeleteAccountView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 03/09/23.
//

import SwiftUI

@MainActor
final class DeleteAccountViewModel: ObservableObject {
  
  @Published var currentEmail: String = ""
  @Published var currentPassword: String = ""
  @Published var localizedError: String = ""
  @Published var userId: String = ""
  
  func delete() async throws {
    Task {
      do {
        try AuthManager.instance.logoutUser()
        
        try await  AuthManager.instance.signInUser(email: self.currentEmail, password: self.currentPassword)
        
        try await AuthManager.instance.deleteUser(userId: userId)
      }
    }
  }
}

struct DeleteAccountView: View {
  
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @Binding var showSignInView: Bool
  @StateObject private var viewModel = DeleteAccountViewModel()
  @State private var isDeleting: Bool = false
  @State private var alertState: Bool = false
  
  var body: some View {
    NavigationView {
      ZStack {
        colorScheme == .light ? Color(hex: "F2F2F7").ignoresSafeArea() : Color.black.ignoresSafeArea()
        VStack(spacing: 5) {
          let _ = print("Current email:", viewModel.currentEmail)
          Text("Current Password")
            .frame(maxWidth: .infinity, alignment: .leading)
          SecureField("Current Password", text: $viewModel.currentPassword)
            .modifier(TextFieldStyle())
          Text("\(viewModel.localizedError.isEmpty ? "" : viewModel.localizedError)")
            .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .bold))
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity, alignment: .leading)
          //              .opacity(!isDeleting && viewModel.newEmail.isEmpty ? 1 : 0)
          Button {
            isDeleting = true
            alertState.toggle()
          } label: {
            if !isDeleting {
              Text("Delete account")
                .modifier(TextFieldButtonStyle(isDisabled: $isDeleting))
            } else if isDeleting {
              ProgressView()
                .modifier(TextFieldButtonStyle(isDisabled: $isDeleting))
            }
          }
          .padding(.top, getRect().height * 0.03)
          .disabled(isDeleting ? true : false)
          Spacer()
        }
        .padding(.horizontal)
        .actionSheet(isPresented: $alertState) {
          ActionSheet(
            title: Text("Are you sure want to delete account? This action cannot be undone."),
            buttons: [
              .destructive(Text("Confirm")) {
                Task {
                  do {
                    try await viewModel.delete()
                    showSignInView = true
                  } catch {
                    viewModel.localizedError = error.localizedDescription
                    viewModel.currentPassword = ""
                  }
                }
                isDeleting = false
              },
              
                .cancel(Text("Cancel")) {
                  
                },
            ]
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
        .navigationTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color(.primaryApp))
        .onAppear {
          Task {
            do {
              viewModel.currentEmail = try AuthManager.instance.getAuthUser().email ?? ""
              viewModel.userId = try AuthManager.instance.getAuthUser().uid
            }
          }
        }
      }
    }
  }
}

struct DeleteAccountView_Previews: PreviewProvider {
  static var previews: some View {
    DeleteAccountView(showSignInView: .constant(false))
  }
}
