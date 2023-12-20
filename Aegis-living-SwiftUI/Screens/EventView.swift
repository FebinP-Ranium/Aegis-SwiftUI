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
                   
                    TitleView(viewModel: viewModel)
                   
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
            )
                
                 CustomNavigationBar()
                   
                })
        }
        .onAppear{
            viewModel.getTodaysDate()
            viewModel.updateDateByAdding(value: 0)
        }
        
        .navigationBarBackButtonHidden(true)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
struct TitleView:View{
    @ObservedObject var viewModel: EventViewModel

    var body: some View {
        HStack{
            Text("Today's Event")
                .font(Font.custom("Avenir Heavy", size: 26.0))
                .foregroundColor(.textPrimaryColor)
            Spacer()
            WebImageView(url: URL(string:viewModel.userManager.image))
                .frame(width: 80, height: 80)
                .cornerRadius(45)
            
        }.padding()
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

