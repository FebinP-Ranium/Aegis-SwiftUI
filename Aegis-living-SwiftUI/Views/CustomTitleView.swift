//
//  SwiftUIView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 20/12/23.
//

import SwiftUI

struct CustomTitleView: View {
    let userManager = UserDataManager()
    var title:String
    var body: some View {
        HStack{
            Text(title)
                .font(Font.custom("Avenir Heavy", size: 26.0))
                .foregroundColor(.textPrimaryColor)
            Spacer()
            WebImageView(url: URL(string:userManager.image))
                .frame(width: 80, height: 80)
                .cornerRadius(45)
            
        }.padding()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTitleView(title: "Title")
    }
}
