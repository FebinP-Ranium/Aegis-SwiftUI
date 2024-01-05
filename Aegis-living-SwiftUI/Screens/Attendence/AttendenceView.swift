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
                                            
                                            StackedBarChart(viewModel: viewModel)
                                                .frame(height: 300) // Adjust the height as needed
                                        }
                                        .padding()
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

struct AttendenceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendenceView()
    }
}

