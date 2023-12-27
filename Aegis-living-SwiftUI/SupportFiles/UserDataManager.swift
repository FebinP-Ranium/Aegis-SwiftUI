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
    
    @AppStorage(Constants.P_COMMUNITYNAME) var p_communityName: String = ""
    @AppStorage(Constants.P_COMMUNITYID) var p_communityId: Int = 0
    @AppStorage(Constants.P_RESIDENTID) var p_residentId: Int = 0
    @AppStorage(Constants.P_ROOM) var p_room: Int = 0
    @AppStorage(Constants.P_FIRSTNAME) var p_firstName: String = ""
    @AppStorage(Constants.P_LASTNAME) var p_lastName: String = ""
    @AppStorage(Constants.P_IMAGE) var p_image: String = ""
    @AppStorage(Constants.P_SHOWATTENDANCE) var p_showAttendance: Int = 0

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
               p_communityName = partner.community?.name ?? ""
               p_communityId = partner.community?.id ?? 0
               p_residentId = partner.id ?? 0
               p_room = partner.room ?? 0
               p_firstName = partner.first_name ?? ""
               p_lastName = partner.last_name ?? ""
               p_image = partner.profile_photo ?? ""
               p_showAttendance = partner.show_attendance ?? 0
               hasPartner = true
               
           } else {
               hasPartner = false
           }
       }
    
    func saveResidentData(_ residentModel: ResidentData) {
            if let residentsData = residentModel.resident, let mainResident = residentsData.first {
                communityName = mainResident.community?.name ?? ""
                communityId = mainResident.community?.id ?? 0
                residentId = mainResident.id ?? 0
                room = mainResident.room ?? 0
                firstName = mainResident.first_name ?? ""
                lastName = mainResident.last_name ?? ""
                image = mainResident.profile_photo ?? ""
                isUserLoggedIn = true
                showAttendance = mainResident.show_attendance ?? 0

                if residentsData.count > 1 {
                    if let partner = residentsData.dropFirst().first {
                        p_communityName = partner.community?.name ?? ""
                        p_communityId = partner.community?.id ?? 0
                        p_residentId = partner.id ?? 0
                        p_room = partner.room ?? 0
                        p_firstName = partner.first_name ?? ""
                        p_lastName = partner.last_name ?? ""
                        p_image = partner.profile_photo ?? ""
                        p_showAttendance = partner.show_attendance ?? 0
                        hasPartner = true
                    }
                } else {
                    hasPartner = false
                }
            }
        }
    
    var partnerFullName: String {
            let fullName = "\(p_firstName) \(p_lastName)"
            return fullName.capitalizingFirstLetter()
        }
    
    var residentFullName: String {
            let fullName = "\(firstName) \(lastName)"
            return fullName.capitalizingFirstLetter()
        }
    
    func userLogout(){
        communityName = ""
        communityId = 0
        residentId = 0
        room = 0
        firstName = ""
        lastName = ""
        image = ""
        isUserLoggedIn = false
        token = ""
        showAttendance = 0
        hasPartner = false
        p_communityName = ""
        p_communityId = 0
        p_residentId = 0
        p_room = 0
        p_firstName = ""
        p_lastName = ""
        p_image = ""
        p_showAttendance = 0
    }
  
    func setProfilePic(imageLink:String){
        image = imageLink

    }

}
