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
                    
                case .invalidURL:
                    self.alertItem = AlertContext.invalidURL
                    
                case .invalidResponse:
                    self.alertItem = AlertContext.invalidData
                    
                case .unableToComplete:
                    self.alertItem = AlertContext.unableToComplete
                }
            }
            

        }
    }
    func saveImage(){
      
        if let image = image{
            self.isLoading = true
            let imageData = image.jpegData(compressionQuality: 1.0)
            
            NetworkManager.shared.imageUpload(Constants.UPLOAD, parameters: ["token": userManager.token , "residentId": userManager.residentId, "communityId": userManager.communityId], imageData: imageData!, imageName:  "image.jpg", mediaType: mediaType ?? "",isHeader: true){ result in
                
                self.isLoading = false

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
                        
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidData
                        
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
            
            
            
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
                        
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidData
                        
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
                
                
            }
        }
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
}
