//
//  NotificationView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 20/12/23.
//

import SwiftUI
import SwiftUIRefresh

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = NotificationViewModel()

    var body: some View {
        NavigationView{
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                VStack{
                    CustomTitleView(title: "Notification")
                    NotificationListView(viewModel: viewModel)
                }
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
        }.onAppear{
            viewModel.getNotification()
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
struct NotificationListView:View{
    @ObservedObject var viewModel: NotificationViewModel

    var body: some View {
        if(viewModel.notificatioList.count == 0 && !viewModel.isLoading){
            Text("No items to display")
                           .font(Font.custom("TrebuchetMS", size: 15))
                           .foregroundColor(.black)
                           .multilineTextAlignment(.center)
                           .padding()
        }
        else{
            List {
                ForEach(0..<viewModel.notificatioList.count, id: \.self) { index in
                    if let notificationMsg = viewModel.notificatioList[index].message,let date = viewModel.notificatioList[index].created_at{
                        let dateStr = viewModel.UTCToLocal(UTCDateString: date)
                        NotificationTableCellView(timeString: dateStr, notificationTitle: notificationMsg).frame(height: 40)
                    }
                    
                }.onDelete(perform: deleteNotification)
            } .pullToRefresh(isShowing: $viewModel.isRefreshing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewModel.isRefreshing = false
                    self.viewModel.getNotification()
                }
            }
            .padding()
                .listStyle(PlainListStyle())
        }
        
    }
    func deleteNotification(at offsets: IndexSet) {
        for index in offsets {
            if let id = viewModel.notificatioList[index].id{
                viewModel.deleteNotification(notificationId: id)
            }

        }
    }
    
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
