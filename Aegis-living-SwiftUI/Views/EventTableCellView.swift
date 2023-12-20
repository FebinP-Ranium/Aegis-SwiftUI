//
//  EventTableCellView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import SwiftUI

struct EventTableCellView: View {
    let timeString :String
    let eventString : String
    var body: some View {
        ZStack(){
            VStack {
                HStack(){
                    Text(timeString)
                        .font(Font.custom("Avenir Roman", size: 15.0))
                        .foregroundColor(.cellTextColor)
                        .frame(width: 84,height: 40)
                        .background(Color.labelBgColor_1)
                    Text(eventString)
                        .font(Font.custom("Avenir Roman", size: 17.0))
                        .foregroundColor(.cellTextColor)
                        .padding()
                    Spacer()
                        
                }
                Spacer().frame(height: 2).background(Color.backGroundColor)
            }
        }
    }
}

struct EventTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        EventTableCellView(timeString: "Time", eventString: "Event Name")
    }
}
