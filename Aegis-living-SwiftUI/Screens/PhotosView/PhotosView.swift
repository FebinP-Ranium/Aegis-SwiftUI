//
//  PhotosView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import SwiftUI

struct PhotosView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = PhotosViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ] // Define the number of columns and their behavior
    init() {
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    var body: some View {
        NavigationView{
            TabView {
               
                      // Tab 1
                ZStack{
                    Color.backGroundColor.ignoresSafeArea()
                    VStack{
                        CustomTitleView(title: "Photos")
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(0..<viewModel.webPhotoArray.count, id: \.self)  { index in // Change the range according to your data
                                    
                                   
                                    if let imageUrl = viewModel.webPhotoArray[index].thumb{
                                        
                                        
                                        NavigationLink(destination: PhotoShowView(selectedTabIndex: index,reloadView: $viewModel.reloadView, selectedPhotoArray:viewModel.webPhotoArray)) {
                                            PhotoGridView(imageUrl:imageUrl, showDeleteImage: false)
                                                
                                        }
                                      
                                            
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.0, anchor: .center)
                            .foregroundColor(Color.brandPrimaryColor)
                    }
                }.tabItem {
                              Text("Web Gallery")
                                   .font(Font.custom("Avenir Heavy", size: 20.0))
                          }
                      
                ZStack{
                    Color.backGroundColor.ignoresSafeArea()
                    VStack{
                        CustomTitleView(title: "Photos")
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(0..<viewModel.appPhotoArray.count, id: \.self)  { index in // Change the range according to your data
                                    if let imageUrl = viewModel.appPhotoArray[index].thumb{
                                        NavigationLink(destination: PhotoShowView(selectedTabIndex: index, reloadView: $viewModel.reloadView, selectedPhotoArray:viewModel.appPhotoArray,appImageSelected:true)) {
                                            PhotoGridView(imageUrl:imageUrl, showDeleteImage: true)
                                                
                                        }
                                           
                                    }
                                }
                            }
                            .padding()

                        }
                        HStack {
                            Spacer() // Pushes the button to the left

                            Button(action: {
                                viewModel.showActionSheet = true
                            }, label: {

                                Text("Upload").font(.system(size: 12)).foregroundColor(Color.white)

                            }).frame(width: 60, height: 60) // Set the frame size
                                .background(Color.blue) // Set background color
                                .clipShape(Circle())
                                .padding()
                               

                        }.frame(height: 100)
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.0, anchor: .center)
                            .foregroundColor(Color.brandPrimaryColor)
                    }
                    
                }
                .tabItem {
                              Text("App Gallery")
                                  .font(Font.custom("Avenir Heavy", size: 20.0))
                          }
                
                
                      
                      // Add more tabs as needed
                  }
            .sheet(isPresented: $viewModel.showPicker) {
                ImagePicker(sourceType: viewModel.source == .library ? .photoLibrary : .camera, selectedImage: $viewModel.image, mediaType: $viewModel.mediaType)
                    .ignoresSafeArea()
            }
            .actionSheet(isPresented: $viewModel.showActionSheet) {
                    ActionSheet(
                        title: Text("Choose an action"),
                        buttons: [
                            .default(Text("Take photo")) {
                                // Handle action for Option 1
                                viewModel.source = .camera
                                viewModel.showPhotoPicker()
                            },
                            .default(Text("Photo Gallery")) {
                                // Handle action for Option 2
                                viewModel.source = .library
                                viewModel.showPhotoPicker()
                            },
                            .cancel() // Add a cancel button
                        ]
                    )
                }
                .accentColor(Color.textPrimaryColor)
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{
                    
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label:{
                        CustomBackButtonView()
                    }
                    ).frame(width:50,height: 50)
                    
                    CustomNavigationBar()
                    
                })
            

        }
        .onChange(of: viewModel.image) { _ in
                   // Call your API when the selectedImage changes (i.e., when the image picker is dismissed)
                   if viewModel.image != nil {
                       // Call your API here using the selected image data
                       // For example:
                       // YourAPIManager.uploadImage(selectedImage!)
                       viewModel.saveImage()
                   }
               }
        .onChange(of: viewModel.reloadView) { _ in
            if viewModel.reloadView == true{
                viewModel.reloadView = false
                viewModel.getResidentImageGallery()
                viewModel.isDeleted = false
            }
               }
        .onAppear{
          
            viewModel.getResidentImageGallery()
           
           
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            switch alertItem.secondaryButton {
                  case .some(let secondaryButton):
                      // Present an alert with two buttons
                      return Alert(
                          title: alertItem.title,
                          message: alertItem.message,
                          primaryButton: .default(alertItem.primaryButton),
                          secondaryButton: .destructive(secondaryButton)
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

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}


