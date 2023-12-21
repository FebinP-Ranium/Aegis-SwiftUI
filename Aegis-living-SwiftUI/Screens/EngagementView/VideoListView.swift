//
//  VideoListView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import SwiftUI

struct VideoListView: View {
    @Environment(\.presentationMode) var presentationMode

    let title:String
    let videoArray : [VideoData]
    var body: some View {
        NavigationView{
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                VStack{
                    CustomTitleView(title: title)
                    List {
                        ForEach(0..<videoArray.count, id: \.self) { index in
                            
                               
                            if let videoLink = videoArray[index].embed{
                                NavigationLink(destination:VideoPlayerView(videoURLString: videoLink)) {
                                    VideoListTablecell(imageUrl: videoArray[index].thumbnail ?? "", videoTitle: videoArray[index].title ?? "")
                                        .frame(height: 100)
                                        .listRowInsets(EdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2))
                                }
                            }
                                
                           
                        }
                    }.padding()
                     .listStyle(PlainListStyle())
                }
            }.navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{
                    
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label:{
                        CustomBackButtonView()
                    }
                    )
                    CustomNavigationBar()
                    
                    
                })
        }.navigationBarBackButtonHidden(true)
    }
}

