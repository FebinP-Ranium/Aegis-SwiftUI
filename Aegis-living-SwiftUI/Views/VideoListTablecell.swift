//
//  VideoListTablecell.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoListTablecell: View {
    let imageUrl:String
    let videoTitle:String
    var body: some View {
        ZStack{
            Color.white
            HStack{
                ZStack{
                    WebImage(url: URL(string: imageUrl))
                        .resizable()
                        .placeholder(Image(systemName: "arrowtriangle.forward.circle"))
                        .indicator(.activity)
                        .frame(width: 120, height: 99)
                    Image(systemName: "arrowtriangle.forward.circle")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundColor(.white)
                   
                }
                Text(videoTitle)
                    .font(.system(size: 15.0,weight: .semibold))
                    .foregroundColor(Color.cellTextColor)
                Spacer()
            }
        }
    }
}

struct VideoListTablecell_Previews: PreviewProvider {
    static var previews: some View {
        VideoListTablecell(imageUrl: "test", videoTitle: "Text")
    }
}
