//
//  CategoryButtonView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 15/12/23.
//

import SwiftUI

struct CategoryButtonView: View {
    let imageName:String

    var body: some View {
        Button(action: {
                   // Action when the button is tapped
                   print("Button tapped")
               }) {
                   Image(imageName) // Replace "yourImageName" with your image asset name
                       .resizable()
                       .frame(width: 90, height: 90) // Adjust the size of the image
                       .aspectRatio(contentMode: .fit)
               }
    }
}

struct CategoryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtonView(imageName:"events")
    }
}
