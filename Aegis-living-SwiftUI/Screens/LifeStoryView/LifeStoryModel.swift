//
//  LifeStoryModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 28/12/23.
//

import Foundation
struct LiveStoryResponse: Codable {
    let data: MemoirData?
}

struct MemoirData: Codable {
    let music_preferences: CustomValue?
    let memoirs: Memoirs?
    let top_things_note: String?
    let additional_info: CustomValue?
    let memoirs_description: String?
    let directions: String?
    let top_things: [TopThing]?
    let music_description: String?
}

struct Memoirs: Codable {
    let memoirs: [MemoirQuestions]?
    let resident_memoirs: [MemoirQuestions]?
    let memoirs_description: String?
}

struct MemoirQuestions: Codable {
    let id: Int?
    let answer: CustomValue?
    let question: CustomValue?
}

struct ResidentMemoir: Codable {
    let question: CustomValue?
    let id: Int?
    let answer: CustomValue?
}

struct TopThing: Codable {
    let placeholder: String?
    let value: CustomValue?
}
enum CustomValue: Codable {
    case int(Int)
    case string(String)
    
    func stringValue() -> String? {
           switch self {
           case .int(let intValue):
               return "\(intValue)"
           case .string(let stringValue):
               return stringValue
           }
       }

       func intValue() -> Int? {
           switch self {
           case .int(let intValue):
               return intValue
           case .string(let stringValue):
               return Int(stringValue)
           }
       }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(CustomValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded value cannot be converted to Int or String"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}



struct MemoirSaveResponse:Codable {
    let response: String?
    let memoir: MemoirDetailsContainer?
    let data: DataDetails?
   
}
struct MemoirDetailsContainer:Codable {
    let memoirs: [MemoirQuestions]?
    let memoirs_description: String?
    let resident_memoirs: [MemoirQuestions]?
}
struct DataDetails:Codable{
    let answer: CustomValue?
    let memoir_question_id: Int?
    let resident_id: Int?
}

struct CustomMemoirData{
    let question: CustomValue?
    let id: Int?
    let answer: CustomValue?
    let type : String?
}
