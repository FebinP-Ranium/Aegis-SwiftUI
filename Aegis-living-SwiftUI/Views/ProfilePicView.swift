//
//  ProfilePicView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 11/01/24.
//

import SwiftUI

struct ProfilePicView: View {
    let userManager = UserDataManager.shared
    var imageWidth = 0.0
    @StateObject var imageLoader = ImageLoder()
    var body: some View {
        HStack{
            Spacer()
            RemoteImage(image: imageLoader.image).onAppear{
                imageLoader.load(fromurlstring: userManager.image)
            }.frame(width: imageWidth,height: imageWidth)
                .cornerRadius(imageWidth/2)
                .padding()
                .opacity(0.5)
            
        }
    }
}

