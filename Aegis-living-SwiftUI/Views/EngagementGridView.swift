//
//  EngagementGridView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import SwiftUI

struct EngagementGridView: View {
    let title:String
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.headerBackGroundColor)
            .frame(height: 80)
            .overlay(Text(title)
                     .foregroundColor(.white)
                     .font(.system(size: 18.0,weight: .semibold))
                   )
    }
}

struct EngagementGridView_Previews: PreviewProvider {
    static var previews: some View {
        EngagementGridView(title: "item")
    }
}
