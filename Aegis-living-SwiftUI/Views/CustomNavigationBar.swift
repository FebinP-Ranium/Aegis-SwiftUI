//
//  CustomNavigationBar.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 11/01/24.
//

import SwiftUI

struct CustomNavigationBar: View {

    var body: some View {
           
                HStack {
                    Image("aegis-family-link-logo") // Replace with your image system name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width-100, height: 80)
                    Spacer()

                    
                }.padding()
            
        }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar()
    }
}
