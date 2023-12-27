//
//  ResidentView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResidentView: View {
    @StateObject var viewModel = ResidentViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {

            NavigationView {
                ZStack {
                    Color.backGroundColor
                        .ignoresSafeArea()
                    
                    VStack {
                        if viewModel.userManager.hasPartner {
                            PartnerView(viewModel: viewModel)
                        }
                        
                        UserView(viewModel: viewModel)
                        
                        CategoryButtonsView(viewModel: viewModel)
                       
                        NavigationLink(
                            destination: viewModel.getViewForCategory(),
                            isActive: Binding<Bool>(
                                get: { viewModel.categoryName != nil }, // Check if categoryName has a value
                                set: { _ in } // Empty set, as we don't need to modify the isActive binding directly
                            ),
                            label: {
                                EmptyView()
                            }
                        )

                       
                        Spacer()
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.0, anchor: .center)
                            .foregroundColor(Color.brandPrimaryColor)
                    }
                    
                }
                .onAppear{
                    viewModel.categoryName = nil
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{CustomNavigationBar()
                    Button{
                        
                        viewModel.callForLogout()
                        presentationMode.wrappedValue.dismiss()
                        
                    }label: {
                        Text("Logout")
                    }
                })
            }
            .navigationBarBackButtonHidden(true)
            .onAppear{
                print(viewModel.userManager.isUserLoggedIn)
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
  
    }
    
   
}

struct PartnerView: View {
    @ObservedObject var viewModel: ResidentViewModel

    var body: some View {
        HStack {
            Spacer()

            VStack {
                WebImageView(url:URL(string: viewModel.userManager.p_image))
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .opacity(0.4)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        print("Tapped")
                        viewModel.switchUser(id: viewModel.userManager.p_residentId)
                    }

                Text(viewModel.userManager.partnerFullName)
                    .font(.system(size: 14.0, weight: .semibold))
                    .foregroundColor(.textPrimaryColor)
                    .padding(.trailing, 10)
            }
        }
    }
}

struct UserView: View {
    @ObservedObject var viewModel: ResidentViewModel

    var body: some View {
        WebImageView(url: URL(string:viewModel.userManager.image))
            .frame(width: 130, height: 130)
            .cornerRadius(65)

        Text(viewModel.userManager.residentFullName)
            .font(Font.custom("Avenir Roman", size: 26.0))
            .fontWeight(.semibold)
            .foregroundColor(.textPrimaryColor)

        Text(viewModel.userManager.communityName.capitalizingFirstLetter())
            .font(Font.custom("Avenir Roman", size: 17.0))
            .foregroundColor(.textPrimaryColor)

        Text("Apt #\(viewModel.userManager.room)".capitalizingFirstLetter())
            .font(Font.custom("Avenir Roman", size: 17.0))
            .foregroundColor(.textPrimaryColor)
    }
}

struct CategoryButtonsView: View {
    @ObservedObject var viewModel: ResidentViewModel

    var body: some View {
        VStack {
            HStack {
                CategoryButtonView(imageName: "events", tagValue: 1, categorySelected: $viewModel.categoryName)
                CategoryButtonView(imageName: "photos",tagValue: 2,categorySelected: $viewModel.categoryName)
                CategoryButtonView(imageName: "life-story",tagValue: 3,categorySelected: $viewModel.categoryName)
            }

            HStack {
                if viewModel.userManager.showAttendance == 1 {
                    CategoryButtonView(imageName: "attendance",tagValue: 4,categorySelected: $viewModel.categoryName)
                }
                CategoryButtonView(imageName: "enge-bold",tagValue: 5,categorySelected: $viewModel.categoryName)
                CategoryButtonView(imageName: "notification",tagValue: 6,categorySelected: $viewModel.categoryName)
            }
        }
    }
}

struct WebImageView: View {
    let url: URL?
    
    var body: some View {
        WebImage(url: url)
            .resizable()
            .placeholder(Image("Author__Placeholder"))
            .indicator(.activity)
    }
}

struct ResidentView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentView()
    }
}
