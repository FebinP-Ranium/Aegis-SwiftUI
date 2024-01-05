//
//  ProfileView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 05/01/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ProfileViewModel()

    let userManager = UserDataManager()

    var body: some View {
        NavigationView{
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                VStack(alignment: .leading){
                    CustomTitleView(title: "Profile")
                    Text("Profile Details")
                        .font(Font.custom("Avenir Heavy", size: 22.0))
                        .foregroundColor(Color.brandPrimaryColor)
                    HStack{
                        Text("Resident Name :")
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                        Text(userManager.residentFullName)
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                    }
                    HStack{
                        Text("Community Name :")
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                        Text(userManager.communityName)
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                    }
                    HStack{
                        Text("Community Id :")
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                        Text("\(userManager.communityId)")
                            .font(Font.custom("Avenir-Roman", size: 17.0))
                            .foregroundColor(Color.textPrimaryColor)
                    
                    }
                    
                    if viewModel.showPswdChangeView{
                        TextField("Current Password", text: $viewModel.oldPaswword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style
                                        .font(Font.custom("Avenir-Medium", size: 15.0))
                                        .autocapitalization(.none) // Control capitalization behavior if needed
                                        .disableAutocorrection(true) // Disable autocorrection
                        TextField("New Password", text: $viewModel.newPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style
                                        .font(Font.custom("Avenir-Medium", size: 15.0))
                                        .autocapitalization(.none) // Control capitalization behavior if needed
                                        .disableAutocorrection(true) // Disable autocorrection
                        TextField("Confirm Password", text: $viewModel.confirmPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style
                                        .font(Font.custom("Avenir-Medium", size: 15.0))
                                        .autocapitalization(.none) // Control capitalization behavior if needed
                                        .disableAutocorrection(true) // Disable autocorrection
                        
                        Button {
                            // Your action here
                            viewModel.checkPasswordMatch()
                        } label: {
                            Text("Submit")
                                .font(Font.custom("Avenir-Roman", size: 15.0))
                                .foregroundColor(Color.white)
                                .frame(width: 250,height: 40)
                                .background(Color.brandPrimaryColor)
                                .multilineTextAlignment(.center)
                                .cornerRadius(10)
                        }.frame(maxWidth: .infinity)
                        
                        
                    }
                    else{
                        Button {
                            // Your action here
                            viewModel.showPswdChangeView = true
                        } label: {
                            Text("Change Password")
                                .font(Font.custom("Avenir-Roman", size: 15.0))
                                .foregroundColor(Color.blue)
                                .multilineTextAlignment(.center) // Align text to the center
                        }
                        .frame(maxWidth: .infinity) // Expand the button to full width
                        .padding()
                    }
                    
                    Spacer()
                }.padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.0, anchor: .center)
                        .foregroundColor(Color.brandPrimaryColor)
                }
                
            } .navigationBarTitle(Text(""), displayMode: .inline)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
