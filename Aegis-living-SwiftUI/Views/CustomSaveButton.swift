//
//  CustomSaveButton.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 28/12/23.
//

import SwiftUI

struct CustomSaveButton: View {
    var body: some View {
        Text("Save")
            .font(Font.custom("Avenir-Medium", size: 17.0))
            .foregroundColor(.white)
            .frame(width:UIScreen.main.bounds.size.width-50,height: 40)
            .background(Color.brandPrimaryColor)
            .cornerRadius(5.0)
    }
}

struct CustomSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomSaveButton()
    }
}
