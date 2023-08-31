//
//  SignInView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 28/08/23.
//

import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
  
  @Published var email: String = ""
  @Published var password: String = ""
  
  func signIn() async throws {
    try await AuthManager.instance.signInUser(email: email, password: password)
  }
}

struct SignInView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Binding var showSignInView: Bool
  @StateObject private var viewModel = SignInViewModel()
  @State private var isSigningIn: Bool = false
  @State private var forgotPasswordSheet: Bool = false
  
    var body: some View {
      VStack {
        ZStack(alignment: .center) {
          Image("bg_login")
            .resizable()
            .scaledToFill()
            .frame(height: getRect().height * 0.2)
          Image("ic_logo")
            .resizable()
            .scaledToFit()
            .frame(width: getRect().width * 0.25)
        }
        VStack(alignment: .trailing, spacing: 5) {
          Text("Welcome Back")
            .font(.system(size: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold))
          Text("Login with developer account")
            .font(.subheadline)
        }
        .padding(.top, getRect().height * 0.1)
        VStack(alignment: .trailing, spacing: 10) {
          TextField("Email", text: $viewModel.email)
            .modifier(TextFieldStyle())
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
          SecureField("Password", text: $viewModel.password, onCommit: {
            isSigningIn = true
            Task {
              do {
                try await viewModel.signIn()
                showSignInView = false
                isSigningIn = false
              } catch {
                isSigningIn = false
              }
            }
          })
            .modifier(TextFieldStyle())
          Button {
            forgotPasswordSheet.toggle()
          } label: {
            Text("Forgot password?")
          }
          .sheet(isPresented: $forgotPasswordSheet) {
            ForgetPasswordView()
          }

        }
        .padding(.horizontal)
        VStack(spacing: 10) {
          Button {
            isSigningIn = true
            Task {
              do {
                try await viewModel.signIn()
                showSignInView = false
                isSigningIn = false
              } catch {
                isSigningIn = false
              }
            }
          } label: {
            if !isSigningIn {
              Text("Login")
            } else {
              ProgressView()
            }
          }
          .modifier(TextFieldButtonStyle(isDisabled: $isSigningIn))

          NavigationLink(destination: SignUpView(showSignInView: $showSignInView)) {
            Text("Sign Up")
//              .foregroundColor(colorScheme == .light ? Color.accentColor : Color.white)
              .frame(maxWidth: .infinity)
              .frame(height: CGFloat(.heightTF))
              .foregroundColor(Color.accentColor)
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(Color.accentColor, lineWidth: 2)
              )
          }
        }
        .padding([.horizontal, .vertical])
        Spacer()
          
      }
      .ignoresSafeArea()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        SignInView(showSignInView: .constant(false))
      }
    }
}

