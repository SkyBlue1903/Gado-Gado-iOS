//var body: some View {
//  GeometryReader { geometry in
//    VisualEffect(colorTint: colorScheme == .dark ? .black : .white, colorTintAlpha: 0.6, blurRadius: 18, scale: 1)
//      .frame(height: statusBarHeight)
//      .offset(y: min(-statusBarHeight, 0))
//      .zIndex(1)
//    ScrollView(.vertical) {
//      headerParallax
//      VStack(alignment: .leading, spacing: 25) {
//        VStack(alignment: .leading, spacing: 5) {
//          Text("Overview")
//            .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
//          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
//        }
//        VStack(alignment: .leading, spacing: 5) {
//          Text("Information")
//            .font(.system(size: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold))
//          Divider()
//          Group {
//            DisclosureGroup("Developer") {
//              Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
//            }
//            Divider()
//            DisclosureGroup("Genre") {
//              Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
//            }
//            Divider()
//            DisclosureGroup("Engine") {
//              Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
//            }
//            Divider()
//            Button {
//
//            } label: {
//              HStack {
//                Text("Developer Website")
//                  .padding(.vertical, 6)
//                Spacer()
//                Image(systemName: "safari")
//              }
//              .foregroundColor(Color.accentColor)
//            }
//            Divider()
//          }
//          .foregroundColor(Color.black)
//        }
//      }
//      .frame(maxWidth: .infinity, alignment: .leading)
//      .padding(.top, getRect().height * 0.4)
//      .padding(.horizontal, 16)
//      .navigationBarHidden(true)
//      .onAppear {
//        statusBarHeight = UIApplication.shared.windows.first!.safeAreaInsets.top
//      }
//    }
//  }
//}
