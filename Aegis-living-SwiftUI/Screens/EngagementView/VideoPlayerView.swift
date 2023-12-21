//
//  VideoPlayerView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import SwiftUI
import WebKit

struct VideoPlayerView: View {
    let videoURLString : String
    @Environment(\.presentationMode) var presentationMode

       var body: some View {
           NavigationView{
               ZStack{
                   Color.black.ignoresSafeArea()
                   WebView(urlString: videoURLString)
                       .edgesIgnoringSafeArea(.all)
               }
               .navigationBarTitle(Text(""), displayMode: .inline)
                   .navigationBarItems(leading: HStack{
                       
                       Button(action:{
                       presentationMode.wrappedValue.dismiss()
                       
                   }, label:{
                       CustomBackButtonView()
                   }
                   )
                       
                        CustomNavigationBar()
                          
                       })
           } .navigationBarBackButtonHidden(true)
       }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(videoURLString: "https://www.ted.com/talks/charlie_todd_the_shared_experience_of_absurdity")
    }
}


struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
