//
//  ContentView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 13/12/23.
//

import SwiftUI

struct LoginView: View {
   
    @StateObject var viewModel = LoginViewModel()
    let userManager = UserDataManager.shared
    var body: some View {
        if(viewModel.isShowResidentView || userManager.isUserLoggedIn){
            ResidentView()
        }
        else{ NavigationView{
            ZStack {
                Color.backGroundColor.ignoresSafeArea()
                VStack(spacing: 22) {
                    Image("aegis-family-link-logo")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 32,height: 53)
                    TextField("Username", text: $viewModel.userName)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    Button{
                        viewModel.loginUser()
                    }label: {
                        Text("Login")
                            .font(.system(size: 15.0))
                            .foregroundColor(.white)
                            .frame(width: 90,height: 30)
                            .background(Color.brandPrimaryColor)
                    }
                }.padding()
                    .offset(y:-100)
                if(viewModel.isLoading){
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.0,anchor:.center)
                        .foregroundColor(Color.brandPrimaryColor)
                }
                
            }
            
        }.alert(item:$viewModel.alertItem){
            alertItem in
            Alert(
                   title: alertItem.title,
                   message: alertItem.message,
                   dismissButton: .default(alertItem.dismissButtonText, action: {
                       viewModel.handleDismiss() // Trigger your function here
                   })
               )
           
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}