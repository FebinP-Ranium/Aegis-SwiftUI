//
//  EventView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import SwiftUI

struct EventView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = EventViewModel()

    var body: some View {
        NavigationView{
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                VStack {
                   
                    CustomTitleView(title: "Today's Event")
                   
                    HeaderView(viewModel: viewModel)
                    
                    EventListView(viewModel: viewModel)
                    
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
        .onAppear{
            viewModel.getTodaysDate()
            viewModel.updateDateByAdding(value: 0)
        }
        
        .navigationBarBackButtonHidden(true)
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

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}

struct HeaderView:View{
    @ObservedObject var viewModel: EventViewModel

    var body: some View {
        ZStack(){
            Color.headerBackGroundColor
            HStack(){
                Button(action: {
                    viewModel.updateDateByAdding(value: -1)
                },
                       label: {
                       Image("left-arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25)
                }).padding(.leading,10)
                Spacer()
                Text(viewModel.dateString)
                    .font(Font.custom("Avenir Heavy", size: 18.0))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    viewModel.updateDateByAdding(value: 1)
                },
                       label: {
                       Image("right-arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25,height: 25)
                }).padding(.trailing,10)
            }
        }.frame(width: UIScreen.main.bounds.size.width-30,height: 49)
            .cornerRadius(10, corners: [.topLeft,.topRight])
    }
}
struct EventListView:View{
    @ObservedObject var viewModel: EventViewModel

    var body: some View {
        if(viewModel.eventDataList.count == 0 && !viewModel.isLoading){
            Text("No items to display")
                           .font(Font.custom("TrebuchetMS", size: 15))
                           .foregroundColor(.black)
                           .multilineTextAlignment(.center)
                           .padding()
        }
        else{
            
            List {
                ForEach(0..<viewModel.eventDataList.count, id: \.self) { index in
                    
                    let time = viewModel.eventDataList[index].event_time
                    let eventName = viewModel.eventDataList[index].event_name
                    
                    EventTableCellView(timeString: time, eventString: eventName).frame(height: 40)
                        .listRowInsets(EdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2))
                }
            }.padding()
                .listStyle(PlainListStyle())
        }
        
    }
}

