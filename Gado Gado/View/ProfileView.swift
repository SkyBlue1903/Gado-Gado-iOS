//
//  ProfileView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
  
  @Published private(set) var user: FSUser? = nil
  
  func logOut() throws {
    try AuthManager.instance.logoutUser()
  }
  
  func initLoadUser() async {
    do {
      let auth = try await AuthManager.instance.getAuthUser()
      let result = try await AuthManager.instance.getFSUser(user: auth)
      self.user = result
    } catch {
      print("Error loading user data: \(error)")
    }
  }
  
  func getUserFullname() -> String {
    return user?.fullname ?? ""
  }
  
  func getUserEmail() -> String {
    return user?.email ?? ""
  }
}

struct ProfileView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @StateObject private var viewModel = ProfileViewModel()
  @Binding var showSignInView: Bool
  @State private var selected: Int = 0
  var body: some View {
    //    ScrollView(.vertical) {
    VStack(alignment: .leading) {
      HeaderProfileView()
      VStack(alignment: .leading) {
        Text("\(viewModel.getUserFullname())")
          .font(.system(size: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold))
          .offset(y: -15)
        Text("Account Settings".uppercased())
          .offset(y: 5)
          .font(.caption)
          .foregroundColor(Color(hex: "727272"))
          .padding(.leading, 16)
        VStack(alignment: .trailing, spacing: 0) {
          Button {
            
          } label: {
            CustomButtonStyle(title: "Reset password")
            
          }
          .tag(1)
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            
          } label: {
            CustomButtonStyle(title: "Update password")
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            
          } label: {
            CustomButtonStyle(title: "Update email")
          }
          Divider()
            .frame(maxWidth: .infinity)
            .padding(.leading)
          Button {
            
          } label: {
            CustomButtonStyle(title: "Delete account", color: Color.red)
          }
        }
//        .padding(.leading)
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
      Spacer()
    }
//    .frame(minHeight: getRect().height * 0.7)
    //    }
    .background(colorScheme == .light ? Color(hex: "#F2F2F7") : Color.black) /* Form Style background */
//    .edgesIgnoringSafeArea(.all)
    .onAppear {
//      DispatchQueue.main.async {
        Task {
          do {
            try? await viewModel.initLoadUser()
          }
        }
//      }
      
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(showSignInView: .constant(false))
  }
}

struct HeaderProfileView: View {
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    ZStack {
      Image("sample-header")
        .resizable()
      //        .scaledToFill()
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
      
    }
    ZStack {
      ZStack {
        Circle()
          .fill(colorScheme == .light ? Color(hex: "#efeef6") : Color.black)
          .frame(width: getRect().height * 0.16, height: getRect().height * 0.16)
        Image("sample-profile")
          .resizable()
          .frame(width: getRect().height * 0.15, height: getRect().height * 0.15)
          .foregroundColor(.green)
          .mask(
            Circle()
          )
      }
      .padding(.leading)
      
      Button {
        print("PP PPicker")
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
      
    }
    .offset(y: -getRect().height * 0.12)
  }
}
