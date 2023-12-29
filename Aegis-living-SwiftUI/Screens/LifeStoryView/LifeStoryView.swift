//
//  LifeStoryView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 28/12/23.
//

import SwiftUI
import SwiftyJSON
struct LifeStoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = LifeStoryViewModel()
    @State private var textHeight: CGFloat = 0.0
    @State private var expandedSection: String? = nil

    var body: some View {
        NavigationView{
            ZStack{
                Color.backGroundColor.ignoresSafeArea()
                ScrollView {
                    VStack{
                        CustomTitleView(title: "Life Story")
                        if let directions = viewModel.memoirData?.directions{
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: self.textHeight+50)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("Directions:")
                                        .font(Font.custom("Avenir-Heavy", size: 18.0))
                                        .foregroundColor(.headerBackGroundColor)
                                        .padding()
                                    Text(directions)
                                        .font(Font.custom("Avenir-Medium", size: 17.0))
                                        .foregroundColor(.cellTextColor)
                                        .padding()
                                        .background(
                                            GeometryReader { geometry in
                                                Color.clear.onAppear {
                                                    // Get the height of the text
                                                    self.textHeight = geometry.size.height
                                                    print("Text Height: \(self.textHeight)")
                                                }
                                            }
                                        )
                                }
                            }
                            
                            
                            VStack {
                                ForEach(viewModel.sectionNames, id: \.self) { item in
                                    CustomRowView(text: item, isExpanded: item == expandedSection, onTap: {
                                        // Toggle the expanded state
                                        withAnimation {
                                            if expandedSection == item {
                                                expandedSection = nil
                                            } else {
                                                expandedSection = item
                                            }
                                        }
                                    })
                                    
                                    if item == expandedSection {
                                        
                                        switch expandedSection{
                                        case viewModel.sectionNames[0]:
                                            TopThingView(viewModel: viewModel)
                                        case viewModel.sectionNames[1]:
                                            MusicAddView(viewModel: viewModel)
                                        case viewModel.sectionNames[3]:
                                            AdditionalInfo(viewModel: viewModel)
                                        case .none:
                                            Text(expandedSection ?? "")
                                                .foregroundColor(.cellTextColor)
                                        case .some(_):
                                            Text(expandedSection ?? "")
                                                .foregroundColor(.cellTextColor)
                                        }
                                        // Add your expanded content for the selected section
                                    }
                                }
                            }
                            
                            .padding()
                            
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
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                viewModel.getLiveStoryData()
            }
    }
}
struct CustomRowView: View {
    var text: String
    var isExpanded: Bool
    var onTap: () -> Void

    var body: some View {
        ZStack{
            Color.headerBackGroundColor .cornerRadius(5)

            HStack {
                Text(text)
                    .font(Font.custom("Avenir-Heavy", size: 15.0))
                    .foregroundColor(.white)
                    .padding(.leading,10)
                Spacer()
                Image("Chevron-Dn-Wht")
                    .padding(.trailing,5)
            }
           
        }.frame(height: 44)
            .onTapGesture {
                print(text)
                onTap()
                
            }
    }
}

struct TopThingView:View{
    @ObservedObject var viewModel : LifeStoryViewModel
//    @State private var textValue: [String] = ["","","","","","","","","",""]

    var body:some View{
        if let topThingArray = viewModel.topThingData{
            ZStack{
                Color.white.cornerRadius(5.0)
                VStack{
                    if let topThingNote = viewModel.memoirData?.top_things_note{
                        Text(topThingNote)
                            .font(Font.custom("Avenir-Medium", size: 17.0))
                            .foregroundColor(.cellTextColor)
                            .padding(.leading,10)
                    }
                ForEach(topThingArray.indices, id: \.self) { index in

                    TextField(topThingArray[index].placeholder ?? "", text: $viewModel.textValue[index])
                            .padding()
                            .onAppear {
                                if let stringValue = topThingArray[index].value?.stringValue() {
                                    viewModel.textValue[index] = stringValue
                                } else if let intValue = topThingArray[index].value?.intValue() {
                                    viewModel.textValue[index] = "\(intValue)"
                                }
                                else{
                                    viewModel.textValue[index] = ""
                                }
                            }
                    }
                    Button{
                        let paramsJSON = JSON(Array(viewModel.textValue.prefix(10)))
                        print("Value \(paramsJSON)")
                        if let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: []) {
                            viewModel.saveLiveStoryData(type: "top_things", value: paramsString)
                        }
                    }label: {
                       CustomSaveButton()
                    }
                }
            }
        }
       
    }
}
struct MusicAddView:View{
    @ObservedObject var viewModel : LifeStoryViewModel
    @State private var musicUpdateVal : String = ""
    var body:some View{
        if let topThingArray = viewModel.topThingData{
            ZStack{
                Color.white.cornerRadius(5.0)
                VStack{
                    if let musicNote = viewModel.memoirData?.music_description{
                        Text(musicNote)
                            .font(Font.custom("Avenir-Medium", size: 17.0))
                            .foregroundColor(.cellTextColor)
                            .padding(.leading,10)
                    }
               

                    TextField(viewModel.musicHintText , text: $musicUpdateVal)
                            .padding()
                            .onAppear {
                                if let stringValue = viewModel.memoirData?.music_preferences?.stringValue() {
                                    musicUpdateVal = stringValue
                                } else if let intValue = viewModel.memoirData?.music_preferences?.intValue(){
                                    musicUpdateVal = "\(intValue)"
                                }
                                else{
                                    musicUpdateVal = ""
                                }
                            }
                    
                    Button{
                        viewModel.saveLiveStoryData(type: "music_preferences", value: musicUpdateVal)
                    }label: {
                       CustomSaveButton()
                    }
                }
            }
        }
       
    }
}
struct AdditionalInfo:View{
    @ObservedObject var viewModel : LifeStoryViewModel
    @State private var additionalInfo : String = ""
    var body:some View{
        if let topThingArray = viewModel.topThingData{
            ZStack{
                Color.white.cornerRadius(5.0)
                VStack{
                   
                    TextField(viewModel.additionalInfoHint , text: $additionalInfo)
                            .padding()
                            .onAppear {
                                if let stringValue = viewModel.memoirData?.additional_info?.stringValue() {
                                    additionalInfo = stringValue
                                } else if let intValue = viewModel.memoirData?.additional_info?.intValue(){
                                    additionalInfo = "\(intValue)"
                                }
                                else{
                                    additionalInfo = ""
                                }
                            }
                    
                    Button{
                        viewModel.saveLiveStoryData(type: "additional_info", value: additionalInfo)
                    }label: {
                       CustomSaveButton()
                    }
                }
            }
        }
       
    }
}
struct LifeStoryView_Previews: PreviewProvider {
    static var previews: some View {
        LifeStoryView()
    }
}
