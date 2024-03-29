//
//  AegisError.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
enum AGError:Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case apiError(String)
}
