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
                                        case viewModel.sectionNames[2]:
                                            MemoirView(viewModel: viewModel)
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
                            .padding(.top,10)
                            .padding(.leading,10)
                        Rectangle()
                            .foregroundColor(Color.lightGreySeperator)
                            .frame(height: 0.5)
                    }
                    LazyVStack {
                        ForEach(topThingArray.indices, id: \.self) { index in
                            
                            TextArea(topThingArray[index].placeholder ?? "", text: $viewModel.textValue[index], memoirQuestion: viewModel.tempMemoirquestion, memoirType: .notApplicable, viewModel: viewModel)
                                .padding(.leading,5)
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
                            
//                            TextField(topThingArray[index].placeholder ?? "", text: $viewModel.textValue[index])
//                                .padding()
//                                .onAppear {
//                                    if let stringValue = topThingArray[index].value?.stringValue() {
//                                        viewModel.textValue[index] = stringValue
//                                    } else if let intValue = topThingArray[index].value?.intValue() {
//                                        viewModel.textValue[index] = "\(intValue)"
//                                    }
//                                    else{
//                                        viewModel.textValue[index] = ""
//                                    }
//
//                                }
                            Rectangle()
                                .foregroundColor(Color.lightGreySeperator)
                                .frame(height: 0.5)
                                          
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
                    }.padding()
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
               
                    TextArea(viewModel.musicHintText, text: $musicUpdateVal, memoirQuestion: viewModel.tempMemoirquestion, memoirType: .notApplicable, viewModel: viewModel)
                         .padding(.leading,5)
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
                 
//                    TextField(viewModel.musicHintText , text: $musicUpdateVal)
//                            .padding()
//                            .onAppear {
//                                if let stringValue = viewModel.memoirData?.music_preferences?.stringValue() {
//                                    musicUpdateVal = stringValue
//                                } else if let intValue = viewModel.memoirData?.music_preferences?.intValue(){
//                                    musicUpdateVal = "\(intValue)"
//                                }
//                                else{
//                                    musicUpdateVal = ""
//                                }
//                            }
//
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
                    TextArea(viewModel.additionalInfoHint, text: $additionalInfo, memoirQuestion:viewModel.tempMemoirquestion, memoirType: .notApplicable, viewModel: viewModel)
                         .padding(.leading,5)
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
//                    TextField(viewModel.additionalInfoHint , text: $additionalInfo)
//                            .padding()
//                            .onAppear {
//                                if let stringValue = viewModel.memoirData?.additional_info?.stringValue() {
//                                    additionalInfo = stringValue
//                                } else if let intValue = viewModel.memoirData?.additional_info?.intValue(){
//                                    additionalInfo = "\(intValue)"
//                                }
//                                else{
//                                    additionalInfo = ""
//                                }
//                            }
                    
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
struct MemoirView:View{
    @ObservedObject var viewModel : LifeStoryViewModel

    var body:some View{
        ZStack{
            Color.white.cornerRadius(5.0)
            VStack{
                if let memoirNote = viewModel.memoirData?.memoirs_description{
                    Text(memoirNote)
                        .font(Font.custom("Avenir-Medium", size: 17.0))
                        .foregroundColor(.cellTextColor)
                        .padding(.top,10)
                        .padding(.leading,10)
                    Rectangle()
                        .foregroundColor(Color.lightGreySeperator)
                        .frame(height: 0.5)
                }
                LazyVStack {
                    ForEach(viewModel.textsForMemoirAnswer.indices, id: \.self) { index in
                        VStack{
                            HStack{
                                Text(viewModel.getResidentQuestion(index: index))
                                    .font(Font.custom("Avenir-Medium", size: 17.0))
                                    .foregroundColor(.cellTextColor)
                                    .padding(.top,10)
                                    .padding(.leading,10)
                                Spacer()
                            }
                                 
                            TextArea("Enter the Answer", text: $viewModel.textsForMemoirAnswer[index], memoirQuestion: viewModel.memoirAnswer?[index] ?? viewModel.tempMemoirquestion, memoirType: .memoirAnswer, viewModel: viewModel)
                                .padding(.leading,5)
                                .onAppear {
                                    if let stringValue = viewModel.memoirAnswer?[index].answer?.stringValue() {
                                        viewModel.textsForMemoirAnswer[index] = stringValue
                                    } else if let intValue = viewModel.memoirAnswer?[index].answer?.intValue(){
                                        viewModel.textsForMemoirAnswer[index] = "\(intValue)"
                                    }
                                    else{
                                        viewModel.textsForMemoirAnswer[index] = ""
                                    }
                                }
                            Rectangle()
                                .foregroundColor(Color.lightGreySeperator)
                                .frame(height: 0.5)
                        }
                    }
                }
                
                LazyVStack {
                    ForEach(viewModel.textsForResidentQuestion.indices, id: \.self) { index in
                        VStack{
                            TextArea("Enter the Question", text: $viewModel.textsForResidentQuestion[index],memoirQuestion: viewModel.residentQueston?[index] ?? viewModel.tempMemoirquestion, memoirType: .residentQuestion, viewModel: viewModel)
                                .padding(.leading,5)
                                .onAppear {
                                    if let stringValue = viewModel.residentQueston?[index].question?.stringValue() {
                                        viewModel.textsForResidentQuestion[index] = stringValue
                                    } else if let intValue = viewModel.residentQueston?[index].question?.intValue(){
                                        viewModel.textsForResidentQuestion[index] = "\(intValue)"
                                    }
                                    else{
                                        viewModel.textsForResidentQuestion[index] = ""
                                    }
                                }
                                 
                            TextArea("Enter the Answer", text: $viewModel.textsForResidentAnswer[index],memoirQuestion: viewModel.residentQueston?[index] ?? viewModel.tempMemoirquestion, memoirType: .residentAnswer, viewModel: viewModel)
                                .padding(.leading,5)
                                .onAppear {
                                    if let stringValue = viewModel.residentQueston?[index].answer?.stringValue() {
                                        viewModel.textsForResidentAnswer[index] = stringValue
                                    } else if let intValue = viewModel.residentQueston?[index].answer?.intValue(){
                                        viewModel.textsForResidentAnswer[index] = "\(intValue)"
                                    }
                                    else{
                                        viewModel.textsForResidentAnswer[index] = ""
                                    }
                                }
                            Rectangle()
                                .foregroundColor(Color.lightGreySeperator)
                                .frame(height: 0.5)
                        }
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
struct TextArea: View {
    @ObservedObject var viewModel: LifeStoryViewModel
    @Binding var text: String
    let placeholder: String
    @State private var isButtonVisible = false
    let memoirQuestion: MemoirQuestions
    let memoirType:MemoirType?
    init(_ placeholder: String, text: Binding<String>,memoirQuestion: MemoirQuestions,memoirType:MemoirType,viewModel:LifeStoryViewModel) {
        self.placeholder = placeholder
        self._text = text
        self.memoirQuestion = memoirQuestion
        self.memoirType = memoirType
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack{
                TextEditor(text: $text) // <= Here
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading,0)
                    .onTapGesture {
                        isButtonVisible = true
                    }
                if isButtonVisible && memoirQuestion.id != -1 {
                                Button{
                                    // Perform action when the button is tapped
                                    print("Button tapped")
                                    isButtonVisible = false
                                    if memoirType == .memoirAnswer{
                                        viewModel.saveMemoirData(key: "answer", value: $text.wrappedValue, key2: "memoir_question_id", value2: memoirQuestion.id ?? 0, id: 0)
                                    }
                                    if memoirType == .residentAnswer{
                                        var question = ""
                                        switch memoirQuestion.question{
                                        case .int(let intValue):
                                            question  = "\(intValue)"
                                        case .string(let stringValue):
                                            question  = stringValue
                                        case .none:
                                            question = ""
                                        }
                                        viewModel.saveMemoirData(key: "answer", value: $text.wrappedValue, key2: "question", value2: question, id: memoirQuestion.id ?? 0)
                                    }
                                    if memoirType == .residentQuestion{
                                        var answer = ""
                                        switch memoirQuestion.answer{
                                        case .int(let intValue):
                                            answer  = "\(intValue)"
                                        case .string(let stringValue):
                                            answer  = stringValue
                                        case .none:
                                            answer = ""
                                        }
                                        viewModel.saveMemoirData(key: "answer", value: answer, key2: "question", value2:$text.wrappedValue , id: memoirQuestion.id ?? 0)
                                    }
                                    // You can modify state variables or perform other actions here
                                }label: {
                                        Image("ic_checked")
                                        
                                }
                                .padding()
                            }
               
            }
              
            
            if (text.isEmpty ){
                HStack{
                    Text(placeholder)
                        .foregroundColor(Color(.placeholderText))
                        .padding(.leading, 0)
                    Spacer()
                }
            }
           
        }
        
        .font(.body)
    }
}


extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
