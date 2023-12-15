//
//  ResidentModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 15/12/23.
//

import Foundation
struct ResidentModel: Codable {
    let data: ResidentData
}

struct ResidentData: Codable {
    let resident: [MyResident]?
}

struct MyResident: Codable {
    let master_list: String?
    let preferences: String?
    let nick_name: String?
    let show_attendance: Int?
    let updated_at: String?
    let room: Int?
    let profile_photo: String?
    let images: String?
    let family_app_installed: Int?
    let opt_in: String?
    let partner_id: Int?
    let interests: String?
    let id: Int?
    let move_in_date: String?
    let first_name: String?
    let notification_start: String?
    let birth_date: String?
    let community_id: Int?
    let family_profile: String?
    let wellness_notes: String?
    let favorite: Int?
    let created_at: String?
    let mail_sent: String?
    let overview: String?
    let last_name: String?
    let family_login_name: String?
    let care_level: String?
    let therapy_notes: String?
    let status: Int?
    let profile_sent: String?
    let deleted_at: String?
    let spouse: String?
    let family_login_password: String?
    let gender: String?
    let community: ResidentCommunity?
    let receivers_email: String?
}

struct ResidentCommunity: Codable {
    let id: Int?
    let name: String?
}
