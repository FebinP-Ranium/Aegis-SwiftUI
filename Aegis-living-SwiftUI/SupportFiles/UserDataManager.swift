//
//  UserDataManager.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 14/12/23.
//

import Foundation
import SwiftUI
class UserDataManager{
    @AppStorage(Constants.COMMUNITYNAME) var communityName: String = ""
    @AppStorage(Constants.COMMUNITYID) var communityId: Int = 0
    @AppStorage(Constants.RESIDENTID) var residentId: Int = 0
    @AppStorage(Constants.ROOM) var room: Int = 0
    @AppStorage(Constants.FIRSTNAME) var firstName: String = ""
    @AppStorage(Constants.LASTNAME) var lastName: String = ""
    @AppStorage(Constants.IMAGE) var image: String = ""
    @AppStorage(Constants.ISUSERLOGGEDIN) var isUserLoggedIn: Bool = false
    @AppStorage(Constants.AUTHTOKEN) var token: String = ""
    @AppStorage(Constants.SHOWATTENDANCE) var showAttendance: Int = 0
    @AppStorage(Constants.HASPARTNER) var hasPartner: Bool = false

    static let shared = UserDataManager()
    
    
    func saveUserData(_ loginData: LoginModel) {
           if let mainResident = loginData.data.resident.first {
               communityName = mainResident.community?.name ?? ""
               communityId = mainResident.community?.id ?? 0
               residentId = mainResident.id ?? 0
               room = mainResident.room ?? 0
               firstName = mainResident.first_name ?? ""
               lastName = mainResident.last_name ?? ""
               image = mainResident.profile_photo ?? ""
               isUserLoggedIn = true
               token = loginData.data.token
               showAttendance = mainResident.show_attendance ?? 0
           }
           
           if let partner = loginData.data.resident.dropFirst().first {
               communityName = partner.community?.name ?? ""
               communityId = partner.community?.id ?? 0
               residentId = partner.id ?? 0
               room = partner.room ?? 0
               firstName = partner.first_name ?? ""
               lastName = partner.last_name ?? ""
               image = partner.profile_photo ?? ""
               showAttendance = partner.show_attendance ?? 0
               hasPartner = true
               
           } else {
               hasPartner = false
           }
       }
}
