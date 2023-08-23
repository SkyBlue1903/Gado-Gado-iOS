import SwiftUI
import VisualEffectView

struct ContentView: View {
  var body: some View {
    ZStack {
      Image("sample-header")
      VisualEffect(colorTint: .white, colorTintAlpha: 0.5, blurRadius: 18, scale: 1)
        .frame(height: 500)
      Image("sample-header")
        .resizable()
        .frame(height: 100)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
