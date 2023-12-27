//
//  EngangementView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import SwiftUI

struct EngangementView: View {
    @Environment(\.presentationMode) var presentationMode
     @StateObject var viewModel = EngagementViewModel()
  
        
    var body: some View {
        
        NavigationView {
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                
                VStack {
                    CustomTitleView(title: "Engagement")
                    EngagementGrid(viewModel: viewModel)
                   
                }
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.0, anchor: .center)
                        .foregroundColor(Color.brandPrimaryColor)
                }
            }.navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{
                    
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    
                }, label:{
                    CustomBackButtonView()
                }
                ).frame(width:50,height: 50)
                     CustomNavigationBar()
                
                })
        }.onAppear {
            viewModel.getVideoList()
        }
        .alert(item: $viewModel.alertItem) { alertItem in

            switch alertItem.secondaryButton {
                  case .some(let secondaryButton):
                      // Present an alert with two buttons
                      return Alert(
                          title: alertItem.title,
                          message: alertItem.message,
                          primaryButton: .default(alertItem.primaryButton),
                          secondaryButton: .destructive(alertItem.secondaryButton ?? Text("Delete"))
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
struct EngagementGrid: View {
    @ObservedObject var viewModel: EngagementViewModel
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ] // Define the number of columns and their behavior
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,alignment: .leading, spacing: 25) {
                ForEach(0..<viewModel.videoType.count, id: \.self)  { index in // Change the range according to your data
                    let title = viewModel.videoType[index]
                    if let videoData = viewModel.videoList[title]{
                        NavigationLink(destination: VideoListView(title:title,videoArray: videoData)) {
                            EngagementGridView(title: title)
                        }
                    }
       
                }
                   }
                   .padding()
            
        }
    }
}


struct EngangementView_Previews: PreviewProvider {
    static var previews: some View {
        EngangementView()
    }
}
