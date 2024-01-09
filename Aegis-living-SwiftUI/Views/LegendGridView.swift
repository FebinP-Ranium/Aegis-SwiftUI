//
//  LegendGridView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 09/01/24.
//

import SwiftUI

struct LegendGridView: View {
    let color:UIColor
    let title:String
    var body: some View {
        let swiftUIColor = Color(color)

        HStack{
            Rectangle()
                .frame(width: 10, height: 10) // Set the width and height of the rectangle
                .foregroundColor(swiftUIColor)
            Text(title)
                .font(.system(size: 10.0))
                .foregroundColor(.black)
        }
    }
}

struct LegendGridView_Previews: PreviewProvider {
    static var previews: some View {
        LegendGridView(color: UIColor(displayP3Red: 0/255, green: 102/255, blue: 161/255, alpha: 1), title: "Text")
    }
}
