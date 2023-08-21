import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      //Tab  1 will have a light status bar
      Color.black
        .edgesIgnoringSafeArea(.all)
        .overlay(Text("Light Status Bar").foregroundColor(.white))
        .statusBarStyle(.lightContent) //set status bar style here
        .tabItem { Text("Tab 1") }
      
      //Tab 2 will have a dark status bar
      Color.white
        .edgesIgnoringSafeArea(.all)
        .overlay(Text("Dark Status Bar"))
        .statusBarStyle(.darkContent) //set status bar style here
        .tabItem { Text("Tab 2") }
    }
  }
}


struct Cont_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}

class HostingController<Content: View>: UIHostingController<Content> {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIApplication.statusBarStyle
  }
}

///By wrapping views in a RootView, they will become the app's main / primary view. This will enable setting the statusBarStyle.
struct RootView<Content: View> : View {
  var content: Content
  
  init(@ViewBuilder content: () -> (Content)) {
    self.content = content()
  }
  
  var body:some View {
    EmptyView()
      .onAppear {
        UIApplication.shared.setHostingController(rootView: AnyView(content))
      }
  }
}

extension View {
  ///Sets the status bar style color for this view.
  func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
    UIApplication.statusBarStyleHierarchy.append(style)
    //Once this view appears, set the style to the new style. Once it disappears, set it to the previous style.
    return self.onAppear {
      UIApplication.setStatusBarStyle(style)
    }.onDisappear {
      guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
      let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
      UIApplication.statusBarStyleHierarchy.removeLast()
      UIApplication.setStatusBarStyle(style)
    }
  }
}

extension UIApplication {
  static var hostingController: HostingController<AnyView>? = nil
  
  static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
  static var statusBarStyle: UIStatusBarStyle = .darkContent
  
  ///Sets the App to start at rootView
  func setHostingController(rootView: AnyView) {
    let hostingController = HostingController(rootView: AnyView(rootView))
    windows.first?.rootViewController = hostingController
    UIApplication.hostingController = hostingController
  }
  
  static func setStatusBarStyle(_ style: UIStatusBarStyle) {
    statusBarStyle = style
    hostingController?.setNeedsStatusBarAppearanceUpdate()
  }
}
