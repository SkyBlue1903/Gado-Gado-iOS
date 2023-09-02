//
//  ForgetPasswordView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 29/08/23.
//

import SwiftUI

@MainActor
final class ForgetPasswordViewModel: ObservableObject {
  
  @Published var email: String = ""
  @Published var errorText: String = ""
  
  func reset(email: String) async throws {
    try await AuthManager.instance.resetPassword(email: self.email)
  }
}

struct ForgetPasswordView: View {
  
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  @State private var isResetting: Bool = false
  @StateObject private var viewModel = ForgetPasswordViewModel()
  @State private var alertState: Bool = false
  
  var body: some View {
    let emailTF = Binding<String>(get: {
      viewModel.email
    }, set: {
      viewModel.email = $0.lowercased()
    })
    return NavigationView {
      ZStack {
        colorScheme == .light ? Color(hex: "F2F2F7").ignoresSafeArea() : Color.black.ignoresSafeArea()
        VStack(spacing: 5) {
          Text("Email")
            .frame(maxWidth: .infinity, alignment: .leading)
          TextField("Email", text: emailTF, onCommit: {
            isResetting = true
            Task {
              do {
                try await viewModel.reset(email: viewModel.email)
                alertState.toggle()
              } catch {
                viewModel.errorText = error.localizedDescription
                viewModel.email = ""
              }
              isResetting = false
            }
          })
          .keyboardType(.emailAddress)
          .modifier(TextFieldStyle())
          Text("We'll sent you email for password reset")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption2)
          Text("\(viewModel.errorText.isEmpty ? "" : viewModel.errorText)")
            .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .bold))
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(!isResetting && viewModel.email.isEmpty ? 1 : 0)
          Button {
            isResetting = true
//            print("pressed")
            Task {
              do {
                try await viewModel.reset(email: viewModel.email)
                alertState.toggle()
              } catch {
                viewModel.errorText = error.localizedDescription
                viewModel.email = ""
              }
              isResetting = false
            }
          } label: {
            if !isResetting {
              Text("Reset password")
            } else if isResetting {
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
            message: Text("Check your mail inbox/spam and follow the instruction to reset password."),
            dismissButton: .default(Text("OK"), action: {
              presentation.wrappedValue.dismiss()
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
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Color(.primaryApp))
      }
    }
  }
}

struct ForgetPasswordView_Previews: PreviewProvider {
  static var previews: some View {
    ForgetPasswordView()
  }
}
