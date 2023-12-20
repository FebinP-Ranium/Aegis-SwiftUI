//
//  EventModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 19/12/23.
//

import Foundation
struct EventListModel: Codable {
    let advert: String
    let data: [EventDataItem]
}

struct EventDataItem: Codable,Identifiable{
    let endtime: String
    let master: Bool
    let end: String
    let user_id: Int?
    let title: String
    let exclude_all_following: String? // Update the type accordingly
    let community_id: Int
    let event_name: String
    let calendar: String? // Update the type accordingly
    let dow: String?
    let event_time: String
    let activity: Activity
    let wellness_pillar: String? // Update the type accordingly
    let activity_id: Int
    let id: Int
    let start: String
    let recurrence_end_date: String? // Update the type accordingly
    let startFrom: String
    let repeat_on: String? // Update the type accordingly
    let skip_weeks: Int
    let endOn: String
    let repeat_event: String
}

struct Activity: Codable {
    let environmental_dimensions: Int
    let intellectual_dimensions: Int
    let social_dimensions: Int
    let created_at: String
    let notes: String? // Update the type accordingly
    let activity_community_id: Int
    let professional_dimensions: Int
    let id: Int
    let physical_dimensions: Int
    let updated_at: String
    let deleted_at: String?
    let emotional_dimensions: Int
    let status: Int
    let name: String
    let spiritual_dimensions: Int
}
