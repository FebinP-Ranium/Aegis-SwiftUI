//
//  NotificationModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 20/12/23.
//

import Foundation
struct NotificationListModel: Codable {
    let data: [Notification]?
    let response: String?
}

struct Notification: Codable {
    let message: String?
    let name: String?
    let id: Int?
    let created_at: String?
}
