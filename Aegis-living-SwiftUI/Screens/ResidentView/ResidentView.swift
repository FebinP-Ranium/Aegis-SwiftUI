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

    var body: some View {
        if !viewModel.isLoggedIn{

            LoginView()
        }
        else{
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
                        
                        Spacer()
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.0, anchor: .center)
                            .foregroundColor(Color.brandPrimaryColor)
                    }
                    
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading: HStack{CustomNavigationBar(isShowBackButton: false, isShowLogoutButon: true)
                    Button{
                        
                        viewModel.callForLogout()
                        
                    }label: {
                        Text("Logout")
                    }
                })
            }
            .onAppear{
                print(viewModel.userManager.isUserLoggedIn)
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.dismissButtonText)
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
                CategoryButtonView(imageName: "events")
                CategoryButtonView(imageName: "photos")
                CategoryButtonView(imageName: "life-story")
            }

            HStack {
                if viewModel.userManager.showAttendance == 1 {
                    CategoryButtonView(imageName: "attendance")
                }
                CategoryButtonView(imageName: "enge-bold")
                CategoryButtonView(imageName: "notification")
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
