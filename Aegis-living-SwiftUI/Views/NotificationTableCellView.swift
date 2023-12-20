//
//  NotificationTableCellView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 20/12/23.
//

import SwiftUI

struct NotificationTableCellView: View {
    let timeString :String
    let notificationTitle : String
    var body: some View {
        ZStack(){
            VStack {
                VStack(alignment:.leading,spacing:2){
                    Text(notificationTitle)
                        .font(Font.custom("Avenir Roman", size: 17.0))
                        .foregroundColor(.cellTextColor)
                    
                    Text(timeString)
                        .font(Font.custom("Avenir Roman", size: 12.0))
                        .foregroundColor(Color.secondary)
                        .frame(height: 21)
                        
                }
                Spacer().frame(height: 2).background(Color.backGroundColor)
            }
        }
    }
}

struct NotificationTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTableCellView(timeString: "01:34PM Jan30 ,2023", notificationTitle: "Text Notification")
    }
}
