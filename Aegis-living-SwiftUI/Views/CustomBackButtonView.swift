//
//  CustomBackButtonView.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import SwiftUI

struct CustomBackButtonView: View {
    var body: some View {
        Image(systemName: "chevron.backward")
            .foregroundColor(.blue)
            .frame(width: 20,height: 20)
    }
}

struct CustomBackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButtonView()
    }
}
