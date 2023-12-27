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
    @StateObject var viewModel = PhotosViewModel()
    @State  var selectedTabIndex = 0
    @Binding var reloadView: Bool

    var selectedPhotoArray = [ResidentImage]()
    var appImageSelected = false
    var body: some View {
        NavigationView{
            ZStack{
                Color.black.ignoresSafeArea()
               
                VStack{
                    Spacer()

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
                            let totalTabs = selectedPhotoArray.count // Number of tabs
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
                            let totalTabs = selectedPhotoArray.count // Number of tabs
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
                            viewModel.showActionSheet = true
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
                    if appImageSelected{
                        Button(action:{
                            if selectedPhotoArray[selectedTabIndex].allow_delete == 0{
                                viewModel.showAlertForNoDelete()
                            }
                            else{
                                viewModel.showAlertForDelete()
                            }
                            
                        }, label:{
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .frame(width: 20,height: 20)
                        }
                               
                        )
                    }
                })
        }
        .actionSheet(isPresented: $viewModel.showActionSheet) {
                ActionSheet(
                    title: Text("Choose an action"),
                    buttons: [
                        .default(Text("Set As profile pic")) {
                            viewModel.setProfilePic(imageDetail: selectedPhotoArray[selectedTabIndex])
                        },
                        .default(Text("Download")) {
                            if let imageUrl = selectedPhotoArray[selectedTabIndex].thumb{
                                viewModel.downloadAndSaveImage(imageLink: imageUrl )
                            }
                        },
                        .cancel() // Add a cancel button
                    ]
                )
            }
        .onChange(of: viewModel.isDeleted) { _ in
                
            if viewModel.isDeleted{
                reloadView = true
                presentationMode.wrappedValue.dismiss()
            }
         
        }
        .alert(item: $viewModel.alertItem) { alertItem in

            switch alertItem.secondaryButton {
                  case .some(let secondaryButton):
                      // Present an alert with two buttons
                      return Alert(
                          title: alertItem.title,
                          message: alertItem.message,
                          primaryButton: .destructive(alertItem.primaryButton){
                              if viewModel.alertType == .confirmdelete{
                                  viewModel.deleteImage(imageDetail: selectedPhotoArray[selectedTabIndex])
                              }
                          },
                          secondaryButton: .default(secondaryButton){
                             
                          }
                      )
                  case .none:
                      // Present an alert with only the primary button
                      return Alert(
                          title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.primaryButton){
                              if viewModel.alertType == .invalidData || viewModel.alertType == .invalidResponse{
                                  
                              }
                          }
                      )
                  }
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

