//
//  AttendenceView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 02/01/24.
//

import SwiftUI
struct AttendenceView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = AttendenceViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backGroundColor.ignoresSafeArea()
                ScrollView{
                    VStack {
                        CustomTitleView(title: "Attendance")
                        
                        HStack {
                            Toggle(isOn: $viewModel.isWeek, label: {Text("\(viewModel.timePeriod) view".capitalizingFirstLetter())})
                                .padding()
                                .onChange(of: viewModel.isWeek) { newValue in
                                    // Call your function here
                                    viewModel.timePeriod = newValue ? "week" : "month"
                                    viewModel.getAttendenceList(date: "")
                                }
                        }
                        AttendanceHeaderView(viewModel: viewModel)
                        
                        
                      // BarStackedView(viewModel: viewModel)
                      
                        if let eventDatas = viewModel.eventDatas{
                            ZStack {
                                        Color.white.ignoresSafeArea()
                                        
                                        VStack {
                                            PieChartUIView(dataPoints: viewModel.pieChartLabel, values: viewModel.pieChartValues)
                                                .frame(height: 300) // Adjust the height as needed
                                            
                                            LegendView().padding()
                                            
                                            StackedBarChart(viewModel: viewModel)
                                                .frame(height: 300) // Adjust the height as needed
                                        }
                                        
                            }.padding()
                            
                            LazyVStack {
                                
                                ForEach(eventDatas.indices, id: \.self) { index in
                                    
                                    let date = viewModel.formatDate(eventDatas[index].event_date ?? "")
                                    EventTableCellView(timeString: date ?? "", eventString: eventDatas[index].event_name ?? "")
                                        .frame(height: 40)
                                        .listRowInsets(EdgeInsets(top: 1, leading: 2, bottom: 0, trailing: 2))
                                        .background(Color.white)
                                    
                                }
                            }.padding()
                               
                            
                        }
                        else if (!viewModel.isLoading){
                            ZStack {
                                Color.white.ignoresSafeArea()
                                VStack{
                                    Text("No data available")
                                        .font(Font.custom("Avenir-Medium", size: 15.0))
                                        .foregroundColor(.black)
                                        .frame(height: 300)
                                       
                                    Text("No chart data available")
                                        .font(Font.custom("Avenir-Medium", size: 15.0))
                                        .foregroundColor(.black)
                                        .frame(height: 300)
                                }.padding()
                                    
                            }.padding()
                            
                            Text("Events not found for this date")
                                .font(Font.custom("Avenir-Medium", size: 15.0))
                                .foregroundColor(.black)
                               
                        }
                        Spacer()
                    }
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
        .onAppear {
            viewModel.getAttendenceList(date: "")
        }
    }
}
struct AttendanceHeaderView:View{
    @ObservedObject var viewModel: AttendenceViewModel

    var body: some View {
        ZStack(){
            Color.headerBackGroundColor
            HStack(){
                Button(action: {
                    viewModel.getAttendenceList(date: viewModel.prevDate ?? "")
                },
                       label: {
                       Text("Prev")
                        .font(Font.custom("Avenir-Medium", size: 16.0))
                        .foregroundColor(.white)
                }).padding(.leading,10)
                Spacer()
                Text(viewModel.dateValue ?? "")
                    .font(Font.custom("Avenir Heavy", size: 18.0))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    viewModel.getAttendenceList(date: viewModel.nextDate ?? "")
                },
                       label: {
                    Text("Next")
                     .font(Font.custom("Avenir-Medium", size: 16.0))
                     .foregroundColor(.white)
                }).padding(.trailing,10)
            }
        }.frame(width: UIScreen.main.bounds.size.width-30,height: 49)
            .cornerRadius(10, corners: [.topLeft,.topRight])
    }
}
struct LegendView: View {
    var chartColors: [UIColor] = [ UIColor(displayP3Red: 0/255, green: 102/255, blue: 161/255, alpha: 1),UIColor(displayP3Red: 134/255, green: 196/255, blue: 73/255, alpha: 1), UIColor(displayP3Red: 89/255, green: 89/255, blue: 91/255, alpha: 1),UIColor(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1),UIColor(displayP3Red: 255/255, green: 163/255, blue: 45/255, alpha: 1),UIColor(displayP3Red: 253/255, green: 253/255, blue: 2/255, alpha: 1)]

    let legendTitle = ["PASSIVE","ACTIVE","SLEEPING","DECLINED TO PARTICIPATE","INTERMITTENT","UNAVAILABLE"]
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ] // Define the number of columns and their behavior
    var body: some View {
        HStack{
            Text("Engagement Level")
                .multilineTextAlignment(.leading)
                .font(.system(size: 17.0))
                .foregroundColor(.black)
            Spacer()
        }
        
            LazyVGrid(columns: columns,alignment: .leading, spacing: 10) {
                ForEach(0..<legendTitle.count, id: \.self)  { index in // Change the range according to your data
                   
                    LegendGridView(color: chartColors[index], title: legendTitle[index])
                }
          
            }
            
        
    }
}
struct AttendenceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendenceView()
    }
}

