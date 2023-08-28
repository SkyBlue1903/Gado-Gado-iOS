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
//  @Published var gender: String = "Male"
  
  func signUp() async throws {
    let auth = try await AuthManager.instance.createUser(email: self.email.lowercased(), password: self.password, fullname: self.fullname, username: self.username.lowercased())
  }
}

struct SignUpView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @StateObject private var viewModel = SignUpViewModel()
  @Binding var showSignInView: Bool
  
  @State private var isSigningUp: Bool = false
  @State private var goToSignInView: Bool = false
  let genderChoice = ["Male", "Female", "Rather not to say"]
  
  var body: some View {
    Form {
      TextField("Username", text: $viewModel.username)
      TextField("Fullname", text: $viewModel.fullname)
      TextField("Email", text: $viewModel.email)
//      Picker("Gender", selection: $viewModel.gender) {
//        ForEach(genderChoice, id: \.self) { gender in
//          Text("\(gender)")
//        }
//      }
      SecureField("Password", text: $viewModel.password)
      
      Section {
        Button {
          print("IAM PRESSED")
          isSigningUp = true
          Task {
            do {
              try await viewModel.signUp()
                showSignInView = false
              isSigningUp = false
            } catch {
              print("error sign up:", error.localizedDescription)
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
        //        .buttonStyle(.plain)
        .listRowBackground(!isSigningUp ? Color.accentColor : Color.gray.opacity(0.5))
      }
      
//      Section {
      Button(action: {
        goToSignInView.toggle()
      }, label: {
        Text("Already have an account? Sign In")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .center)
        NavigationLink("", destination: EmptyView(), isActive: $goToSignInView)
          .hidden()
      })
//      }
//      .padding(.top, -getRect().height * 0.03)
      .listRowBackground(Color.clear)
    }
    .navigationTitle("Sign Up")
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView() {
      SignUpView(showSignInView: .constant(false))
    }
  }
}
