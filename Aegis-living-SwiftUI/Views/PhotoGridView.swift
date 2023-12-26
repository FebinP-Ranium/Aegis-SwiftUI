//
//  PhotoGridView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoGridView: View {
    let imageUrl:String
    let showDeleteImage : Bool
    var body: some View {
        ZStack{
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .placeholder(Image("user"))
                .indicator(.activity)
                .frame(width:calculateTheFrame(),height: calculateTheFrame())
            if showDeleteImage{
                Image(systemName: "trash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10,height: 10)
                    .foregroundColor(.blue)
                    .padding(EdgeInsets(top: calculateTheFrame()-15, leading: calculateTheFrame()-15, bottom: 0, trailing: 0))
            }
        }
    }
    
    func calculateTheFrame()->CGFloat{
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let itemsPerRow: CGFloat = 3
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return widthPerItem
        
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView(imageUrl: "https://seanallen-course-backend.herokuapp.com/images/appetizers/buffalo-chicken-bites.jpg", showDeleteImage: true)
    }
}
