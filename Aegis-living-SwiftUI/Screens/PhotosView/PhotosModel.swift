//
//  PhotosModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import Foundation
struct PhotoListModel: Codable {
    let data: ResidentImages?
}

struct ResidentImages: Codable {
    let web: [ResidentImage]?
    let app: [ResidentImage]?
}

struct ResidentImage: Codable {
    let resident_id: Int?
    let allow_delete: Int?
    let show_in_app: Int?
    let id: Int?
    let orignalname: String?
    let file_type: String?
    let resident_file_id: Int?
    let filename: String?
    let family_upload: Int?
    let thumb: String?
    let rotation: Int?
    let community_file_id: Int?
}
