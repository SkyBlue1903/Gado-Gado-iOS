//
//  RootView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 25/08/23.
//

import SwiftUI

struct RootView: View {
  @State private var showSignInView: Bool = false
  
  var body: some View {
    NavigationView {
      if showSignInView {
        SignUpView(showSignInView: $showSignInView)
          .transition(.move(edge: .bottom))
      } else {
        ProfileView(showSignInView: $showSignInView)
      }
    }
    .onAppear {
      fetchUser()
    }
  }
  
  private func fetchUser() {
    let auth = try? AuthManager.instance.getAuthUser()
    self.showSignInView = auth == nil
  }
}


struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
