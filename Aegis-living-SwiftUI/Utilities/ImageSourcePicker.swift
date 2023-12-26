//
//  ImagPicker.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 26/12/23.
//

import Foundation
import UIKit
enum ImageSourcePicker{
    enum source: String{
        case library,camera
    }
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
    }
}
