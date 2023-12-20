//
//  CategoryButtonView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 15/12/23.
//

import SwiftUI

struct CategoryButtonView: View {
    let imageName:String
    let tagValue : Int
    @Binding var categorySelected:CategoryName?
    var body: some View {
        Button(action: {
                   // Action when the button is tapped
                   print("Button tapped")
            switch tagValue{
            case 1:
                categorySelected = .events
            case 2:
                categorySelected = .photos
            case 3:
                categorySelected = .lifeStory
            case 4:
                categorySelected = .attendeance
            case 5:
                categorySelected = .engagement
            case 6:
                categorySelected = .notification
            default:
                categorySelected = .events
            }
            
               }) {
                   Image(imageName) // Replace "yourImageName" with your image asset name
                       .resizable()
                       .frame(width: 90, height: 90) // Adjust the size of the image
                       .aspectRatio(contentMode: .fit)
               }.tag(tagValue)
    }
}

struct CategoryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtonView(imageName:"events", tagValue: 0, categorySelected:.constant(.events))
    }
}
