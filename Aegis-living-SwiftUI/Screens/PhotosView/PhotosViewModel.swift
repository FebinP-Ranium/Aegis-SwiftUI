//
//  PhotosViewModel.swift
//  Aegis-living-SwiftUI
//
//  Created by Febin Puthalath on 21/12/23.
//

import Foundation
import UIKit
final class PhotosViewModel:ObservableObject{
    let userManager = UserDataManager()
    @Published var isLoading = false
    @Published var alertItem:AlertItem?
    @Published  var appPhotoArray = [ResidentImage]()
    @Published  var webPhotoArray = [ResidentImage]()
    @Published  var selectedPhotoArray = [ResidentImage]()
    @Published var image:UIImage?
    @Published var showPicker = false
    @Published var source:ImageSourcePicker.source = .library
    @Published var showActionSheet = false
    @Published var mediaType:String?
    @Published var isImageUploading = false
    @Published var isDeleted = false
    @Published var alertType:AlertType?
    @Published var reloadView = false

    func getResidentImageGallery(){
        self.isLoading = true
        NetworkManager.shared.makePostRequest( Constants.GALLERY, parameters: ["id": userManager.residentId], modelType: PhotoListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let photoListModel):
                if let data = photoListModel?.data{
                    if let appImage = data.app{
                        self.appPhotoArray = appImage
                    }
                    if let webImage = data.web{
                        self.webPhotoArray = webImage
                    }
                }
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    self.alertType = .invalidURL
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                    self.alertType = .unableToComplete
                }
            }
            

        }
    }
    func saveImage(){
      
        if let image = image{
            self.isImageUploading = true
            let imageData = image.jpegData(compressionQuality: 1.0)
            
            NetworkManager.shared.imageUpload(Constants.UPLOAD, parameters: ["token": userManager.token , "residentId": userManager.residentId, "communityId": userManager.communityId], imageData: imageData!, imageName:  "image.jpg", mediaType: mediaType ?? "",isHeader: true){ result in
                
                self.isImageUploading = false

                switch result{
                case .success(let successStr):
                    if let data = successStr{
                        if data == "Success"{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                // Replace this block with the method you want to call
                                                // For example, updating a state variable
                                self.getResidentImageGallery()
                                
                                            }
                            self.alertItem = AlertContext.imageSuccessFullAlert
                        }
                    }
                    
                case .failure(let error):
                    switch error{
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                        self.alertType = .invalidData
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                        self.alertType = .invalidURL
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidData
                        self.alertType = .invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                        self.alertType = .unableToComplete
                    }
                }
            }
            
        }
    }
    
    
    func deleteImage(imageDetail:ResidentImage){
        print(imageDetail)
        self.isLoading = true
        var residentFileId = 0
        if imageDetail.resident_file_id != nil {
            if imageDetail.resident_file_id  == 0
            {
                residentFileId = imageDetail.id ?? 0
            }
            else{
                residentFileId = imageDetail.resident_file_id ?? 0
            }
        }
        
        NetworkManager.shared.makeDeleteRequest( Constants.DELETEPHOTO, parameters: ["resident_id": userManager.residentId,"resident_files":residentFileId,"community_files":imageDetail.community_file_id ?? 0], modelType: PhotoListModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let photoListModel):
                self.isDeleted = true
                if let data = photoListModel?.data{
                    if let appImage = data.app{
                        self.appPhotoArray = appImage
                    }
                    if let webImage = data.web{
                        self.webPhotoArray = webImage
                    }
                }
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    self.alertType = .invalidURL
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                    self.alertType = .unableToComplete
                }
            }
            

        }
    }
    func setProfilePic(imageDetail:ResidentImage){
        print(imageDetail)
        self.isLoading = true
        var residentFileId = 0
        if imageDetail.resident_file_id != nil {
            if imageDetail.resident_file_id  == 0
            {
                residentFileId = imageDetail.id ?? 0
            }
            else{
                residentFileId = imageDetail.resident_file_id ?? 0
            }
        }
        
        NetworkManager.shared.makePostRequest( Constants.UPLOADPROFILEPIC, parameters: ["resident_id": userManager.residentId,"resident_file_id":residentFileId,"community_file_id":imageDetail.community_file_id ?? 0], modelType: ProfilePicModel.self, isHeader: true){    result in
            
            self.isLoading = false
            
            
            switch result{
            case .success(let profilePicData):
                if let data = profilePicData?.data{
                    self.alertItem = AlertContext.setprofilePicAlert
                    self.alertType = .setProfilePic
                    self.userManager.setProfilePic(imageLink: data)
                }
               
            case .failure(let error):
                switch error{
                case .invalidData:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    self.alertType = .invalidURL
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    self.alertType = .invalidData
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                    self.alertType = .unableToComplete
                }
            }
            

        }
    }
    
    func showAlertForDelete(){
        self.alertItem = AlertContext.deleteConfirmationAlert
        self.alertType = .confirmdelete
    }
    func showAlertForNoDelete(){
        self.alertItem = AlertContext.noDeleteAlert
        self.alertType = .noDelete
    }
    
    func showPhotoPicker() {
        if source == .camera {
            if !ImageSourcePicker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
   
    func downloadAndSaveImage(imageLink:String) {
              guard let url = URL(string: imageLink) else {
                  return
              }

              URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data, let uiImage = UIImage(data: data) {
                      // Save image to photo library
                      UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)

                  }
              }.resume()
          }
    
}
