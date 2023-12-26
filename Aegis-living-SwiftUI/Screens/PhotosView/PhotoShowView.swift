//
//  PhotoShowView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct PhotoShowView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PhotosViewModel()
    var selectedPhotoArray = [ResidentImage]()

    @State private var selectedTabIndex = 0
    var body: some View {
        NavigationView{
            ZStack{
                Color.black.ignoresSafeArea()
               
                VStack{
                    Spacer()
                    
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 0) {
//                            ForEach(0..<viewModel.webPhotoArray.count, id: \.self)  { index in
//                                if let imageUrl = viewModel.webPhotoArray[index].thumb{
//
//                                    WebImage(url: URL(string: imageUrl))
//                                        .resizable()
//                                        .placeholder(Image("user"))
//                                        .indicator(.activity)
//                                        .frame(width: UIScreen.main.bounds.size.width,height: 280)
//                                        .padding(.horizontal, 20)
//
//                                }
//                            }
//                        }
//
//                    }
                    TabView(selection: $selectedTabIndex){
                        ForEach(0..<selectedPhotoArray.count, id: \.self)  { index in
                            if let imageUrl = selectedPhotoArray[index].thumb{
                                
                                WebImage(url: URL(string: imageUrl))
                                    .resizable()
                                    .placeholder(Image("user"))
                                    .indicator(.activity)
                                    .frame(width: UIScreen.main.bounds.size.width,height: 280)
                                    .padding(.horizontal, 20)
                                
                            }
                        }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    
                    
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            let totalTabs = viewModel.webPhotoArray.count // Number of tabs
                                       withAnimation {
                                           selectedTabIndex = (selectedTabIndex - 1) % totalTabs
                                       }
                        },
                               label: {
                               Image("left-arrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25,height: 25)
                        }).padding(.leading,10)
                        Spacer(minLength:150)
                        Button(action: {
                            let totalTabs = viewModel.webPhotoArray.count // Number of tabs
                                       withAnimation {
                                           selectedTabIndex = (selectedTabIndex + 1) % totalTabs
                                       }
                        },
                               label: {
                               Image("right-arrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25,height: 25)
                        }).padding(.trailing,10)
                        Spacer(minLength:30)
                        Button(action: {
                           
                        },
                               label: {
                               Image(systemName:"square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25,height: 25)
                        }).padding(.trailing,10)
                    }
                }
                
                
                
            } .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{
                    
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label:{
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 20,height: 20)
                    }
                        
                    )
                    
//                    CustomNavigationBar()
                   
                    
                },trailing: HStack{
                    Button(action:{
                       
                        
                    }, label:{
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .frame(width: 20,height: 20)
                    }
                        
                    )
                })
        } .navigationBarBackButtonHidden(true)
    }
}

struct PhotoShowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoShowView()
    }
}
