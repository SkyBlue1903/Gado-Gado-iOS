//
//  EditProfileView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 07/09/23.
//

import SwiftUI

@MainActor
final class EditProfileViewModel: ObservableObject {
  
  @Published var localizedError: String = ""
  @Published var about: String = ""
  @Published var address: String = ""
  @Published var age: String = ""
  @Published var fullname: String = ""
  @Published var username: String = ""
  @Published var selectedGender: String = ""
  
  func edit() async throws {
    try await AuthManager.instance.editProfile(username: self.username, fullname: self.fullname, about: self.about, address: self.address, age: self.age, gender: self.selectedGender)
  }
}

struct EditProfileView: View {
  
  @StateObject private var viewModel = EditProfileViewModel()
  @State private var usernameCheck: Bool = false
  @State private var isSaving: Bool = false
  @State private var alertState: Bool = false
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme
  var user: FSUser?
  let gender = ["Male", "Female", ""]
  
  var body: some View {
    NavigationView {
      ZStack {
        colorScheme == .light ? Color(hex: "F2F2F7").ignoresSafeArea() : Color.black.ignoresSafeArea()
        ScrollView(.vertical) {
          VStack(spacing: 5) {
            Group {
              Text("Username")
                .frame(maxWidth: .infinity, alignment: .leading)
              HStack {
                TextField("Username", text: $viewModel.username)
                  .autocapitalization(.none)
                  .onChange(of: viewModel.username) { newValue in
                    
                  }
                Spacer()
                //              ProgressView()
                Image(systemName: "checkmark")
                  .foregroundColor(Color.green)
              }
              .modifier(TextFieldStyle())
              Text("Fullname")
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField("Fullname", text: $viewModel.fullname)
                .disableAutocorrection(true)
                .autocapitalization(.words)
                .modifier(TextFieldStyle())
              Text("About")
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField("About", text: $viewModel.about)
                .modifier(TextFieldStyle())
            }
            Group {
              Text("Address")
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField("Adress", text: $viewModel.address)
                .autocapitalization(.words)
                .modifier(TextFieldStyle())
              Text("Age")
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField("Age", text: $viewModel.age)
                .keyboardType(.numberPad)
                .modifier(TextFieldStyle())
              HStack {
                Text("Gender")
                Spacer()
                Picker(selection: $viewModel.selectedGender, label: Text("Gender")) {
                  ForEach(gender.sorted(), id: \.self) { each in
                    Text(each == "" ? "Rather not to say" : each)
                  }
                }
                .offset(x: 12)
              }
              .modifier(TextFieldStyle())
              .padding(.top, 25)
            }
          }
          .padding([.horizontal, .top])
        }
      }
      .alert(isPresented: $alertState) {
        Alert(
          title: Text("Error"), // Empty title
          message: Text("\(viewModel.localizedError)"),
          dismissButton: .default(Text("OK"))
        )
      }
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            isSaving = true
            Task {
              do {
                try await viewModel.edit()
                presentation.wrappedValue.dismiss()
              } catch {
                alertState.toggle()
                isSaving = false
                viewModel.localizedError = error.localizedDescription
              }
            }
          } label: {
            if !isSaving {
              Text("Save")
            } else {
              ProgressView()
            }
          }
          .disabled(formCheck() || isSaving)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button {
            presentation.wrappedValue.dismiss()
          } label: {
            Text("Cancel")
          }
          .disabled(isSaving ? true : false)
        }
      }
      .navigationTitle("Edit Profile")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        viewModel.username = user?.username ?? ""
        viewModel.fullname = user?.fullname ?? ""
        viewModel.about = user?.about ?? ""
        viewModel.address = user?.address ?? ""
        viewModel.age = user?.age ?? ""
        viewModel.selectedGender = user?.gender ?? ""
      }
    }
  }
  
  func formCheck() -> Bool {
    let username = viewModel.username == user?.username ?? ""
    let fullname = viewModel.fullname == user?.fullname ?? ""
    let about = viewModel.about == user?.about ?? ""
    let address = viewModel.address == user?.address ?? ""
    let age = viewModel.age == user?.age ?? ""
    let gender = viewModel.selectedGender == user?.gender ?? ""
    return (username && fullname && about && address && age && gender)
  }
}

struct EditProfileView_Previews: PreviewProvider {
  static var previews: some View {
    EditProfileView()
  }
}
