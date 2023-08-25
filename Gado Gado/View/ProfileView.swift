//
//  ProfileView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 16/08/23.
//

import SwiftUI

struct ProfileView: View {
  
  @State private var showSignInView: Bool = true
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        HeaderProfileView()
        VStack(alignment: .leading) {
          Text("Erlangga Anugrah Arifin")
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
            Divider()
              .frame(maxWidth: .infinity)
            Button {
              
            } label: {
              CustomButtonStyle(title: "Update password")
            }
            Divider()
              .frame(maxWidth: .infinity)
            Button {
              
            } label: {
              CustomButtonStyle(title: "Update email")
            }
            Divider()
              .frame(maxWidth: .infinity)
            Button {
              
            } label: {
              CustomButtonStyle(title: "Delete account", color: Color.red)
            }
          }
          .padding(.leading)
          .frame(maxWidth: .infinity)
          .background(colorScheme == .light ? Color.white : Color(hex: "151517"))
          .cornerRadius(10)
          
          Button {
            
          } label: {
            CustomButtonStyle(title: "Log out")
          }
          .padding(.leading)
          .frame(maxWidth: .infinity)
          .background(colorScheme == .light ? Color.white : Color(hex: "151517"))
          .cornerRadius(10)
          .padding(.top, 32)
        }
        .offset(y: -getRect().height * 0.1)
        .padding(.horizontal, 16)
        Spacer()
        
      }
    }
    .background(colorScheme == .light ? Color(hex: "#efeef6") : Color.black)
    .edgesIgnoringSafeArea(.vertical)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
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
