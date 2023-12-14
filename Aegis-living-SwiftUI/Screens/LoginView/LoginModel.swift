//
//  LoginModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
struct LoginModel: Codable {
    let data: DataObject
}

struct DataObject: Codable {
    let token: String
    let role_id: Int
    let resident: [Resident]
    let community: [Community]
}

struct Resident: Codable {
    let room: Int?
    let family_profile: String?
    let id: Int?
    let community: Community?
    let notification_start: String?
    let preferences: String?
    let gender: String?
    let care_level: String?
    let spouse: String?
    let family_app_installed: Int?
    let last_name: String?
    let move_in_date: String?
    let first_name: String?
    let community_id: Int?
    let partner_id: Int?
    let images: String?
    let show_attendance: Int?
    let profile_photo: String?
    let birth_date: String?
}

struct Community: Codable {
    let name: String?
    let id: Int?
}
