//
//  RemoteImage.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 11/01/24.
//

import Foundation
import SwiftUI

final class ImageLoder:ObservableObject{
    @Published var image:Image? = nil
    
    func load(fromurlstring urlString:String){
        NetworkManager.shared.downloadImage(fromURLStrings: urlString){
            uiImage in
            guard let uiImage = uiImage else{ return}
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}


struct RemoteImage:View{
    var image:Image?
    
    var body:some View{
        
        image?.resizable() ?? Image("food-placeholder").resizable()
    }
}
