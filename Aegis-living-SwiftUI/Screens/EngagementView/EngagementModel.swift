//
//  EngagementModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import Foundation
struct EngagementListModel: Codable {
    let data: [String: [VideoData]]?
    let types: [String]?
}

struct VideoData: Codable {
    let embed: String?
    let duration: String?
    let link: String?
    let description: String?
    let createdAt: String?
    let id: Int?
    let thumbnail: String?
    let title: String?
    let updatedAt: String?
    let admin_app: Int?
    let select_video: Int?
    let resource_type: String?
    let type: String?
}
