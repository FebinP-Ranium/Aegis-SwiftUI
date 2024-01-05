//
//  AttendenceModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 02/01/24.
//

import Foundation
import UIKit
struct AttendenceListModel: Codable {
    let data: DataInfo
}

struct DataInfo: Codable {
    let event_dates: [EventDate]?
    let date_ranges: DateRanges?
    let dimensionsaverage: DimensionsAverage?
    let attendance_status_count: [AttendanceStatusCount]?
}

struct EventDate: Codable {
    let event_date: String?
    let event_name: String?
}

struct DateRanges: Codable {
    let prev: String?
    let next: String?
    let title: String?
    let locked: Bool?
}

struct DimensionsAverage: Codable {
    let professional: Double?
    let physical: Double?
    let spiritual: Double?
    let emotional: Double?
    let intellectual: Double?
    let environmental: Double?
    let social: Double?
}


struct AttendanceStatusCount: Codable {
    let event_date: String?
    let attendances: [Int]?
    let attendance_status: [[StatusValue]]?

    
}


    struct StatusValue: Codable {
        let intValue: Int?
        let stringValue: String?

        init(from decoder: Decoder) throws {
            if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
                self.intValue = intValue
                self.stringValue = nil
            } else if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
                self.stringValue = stringValue
                self.intValue = nil
            } else {
                self.stringValue = nil
                self.intValue = nil
                // Handle error or unexpected data here
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            if let stringValue = stringValue {
                try container.encode(stringValue)
            } else if let intValue = intValue {
                try container.encode(intValue)
            }
        }
    }

struct ChartColors {
    static let blue = UIColor(displayP3Red: 0/255, green: 102/255, blue: 161/255, alpha: 1)
    static let green = UIColor(displayP3Red: 134/255, green: 196/255, blue: 73/255, alpha: 1)
    static let grey = UIColor(displayP3Red: 89/255, green: 89/255, blue: 91/255, alpha: 1)
    static let orange = UIColor(displayP3Red: 255/255, green: 163/255, blue: 45/255, alpha: 1)
    static let darkBlue = UIColor(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    static let unavailable = UIColor(displayP3Red: 253/255, green: 253/255, blue: 2/255, alpha: 1)
}

struct LegendLabels {
    static let passive = "PASSIVE"
    static let active = "ACTIVE"
    static let sleeping = "SLEEPING"
    static let declined = "DECLINED"
    static let intLabel = "INT"
    static let ua = "U/A"
}
struct BarDataEntry:Identifiable{
    let id = UUID()
    var barLabel : [String]
    var barData : [[Double]]
}
