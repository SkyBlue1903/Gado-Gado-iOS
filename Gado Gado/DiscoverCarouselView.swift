//
//  DiscoverCarouselView.swift
//  Gado Gado
//
//  Created by Erlangga Anugrah Arifin on 17/08/23.
//

import SwiftUI

struct DiscoverCarouselView: View {
  
  @State private var index: Int = 1
  @State private var showDetail: Bool = false
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      TabView(selection: $index) {
        ForEach(1...3, id: \.self) { each in
          //          NavigationLink(destination: EmptyView()) {
          ZStack {
            Rectangle()
              .fill(.blue)
            Text("Page: \(each)")
              .foregroundColor(.white)
            NavigationLink(destination: Text("Inside Page: \(index)"), isActive: $showDetail) {
            }
            .hidden()
          }
          .onTapGesture {
            print("IAM PRESSED AT:", index)
            showDetail.toggle()
          }
        }
      }
      .tabViewStyle(.page)
    }
  }
}


struct DiscoverCarousel2View: View {
  
  @State var offset: CGFloat = 0
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 15) {
        GeometryReader { proxy -> AnyView in
          
          let minY = proxy.frame(in: .global).minY
          DispatchQueue.main.async {
            self.offset = minY
            print("OFFSET:", self.offset)
          }
          
          return AnyView (
            ZStack {
              Image("sample-header")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: getRect().width, height: minY > 0 ? getRect().height * 0.4 + minY : getRect().height * 0.4, alignment: .center)
            }
              .frame(height: minY > 0 ? getRect().height * 0.4 + minY : nil)
              .offset(y: minY > 0 ? -minY : 0)
          )
          
        }
        //        .frame(height: UIScreen().bounds.height * 0.4)
        //        .frame(height: 100)
      }
      
    }
    .ignoresSafeArea(.all, edges: .top)
  }
}

struct BackgroundView: View {
  
  @State var offset: CGFloat = 0
  
  var body: some View{
    ZStack{
      GeometryReader{ proxy -> AnyView in
        
        let minY = proxy.frame(in: .global).minY
        
        DispatchQueue.main.async {
          self.offset = minY
          print("OFFSET:", self.offset)
        }
        
        return AnyView (
          ZStack {
            Image("sample-header")
              .resizable()
              .scaledToFill()
              .frame(width: getRect().width, height:  minY > 0 ? UIScreen().bounds.height * 0.4 + minY : nil, alignment: .center)
              .clipped()
              .cornerRadius(0)
          }
            .padding(.top, -10)
            .offset(y: minY > 0 ? -minY : 0)
        )
      }
    }
  }
}

struct DiscoverCarouselView_Previews: PreviewProvider {
  static var previews: some View {
    //        DiscoverCarouselView()
    //        .frame(height: UIScreen.main.bounds.height * 0.4)
    NavigationView {
      DiscoverCarouselView()
    }
  }
}
