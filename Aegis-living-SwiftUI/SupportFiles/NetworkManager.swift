//
//  NetworkManager.swift
//  Pear
//
//  Created by Febin Puthalath on 08/05/23.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return sharedInstance.isReachable
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    static let baseURL = Constants.USERHOST
    
//    func headers() -> HTTPHeaders {
//        let authToken = UserDefaults.standard.string(forKey: Constants.AUTHTOKEN)
//        //        var headers: HTTPHeaders = [
//        //            "Content-Type": "application/json",
//        //            "Accept": "application/json"
//        //        ]
//        var headers: HTTPHeaders = []
//        if let authToken = authToken {
//            headers["Authorization"] = "pear " + authToken
//        }
//        return headers
//    }
    
    
    func makePostRequest<T: Codable>(_ apiURl:String, parameters:[String:Any], modelType: T.Type,isHeader:Bool, completionHandler: @escaping (Result<T?,AGError>) -> Void) {
        guard Connectivity.isConnectedToInternet else {
            let message = "No Internet.Please try again"
            completionHandler(.failure(.unableToComplete))
            return
        }
        
        let strURL = "\(Constants.USERHOST)\(apiURl)"
        print("URL -\(strURL),parameters - \(parameters)")
        var headers: HTTPHeaders = [:]
        if isHeader, let authToken = UserDefaults.standard.string(forKey: Constants.AUTHTOKEN) {
            headers["Authorization"] = "pear " + authToken
        }
        print(headers)
        
        AF.request(strURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print(JSON(data))
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(modelType, from: data)
                    completionHandler(.success(model))
                    return
                } catch {
                    
                    do{
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(FailModel.self, from: data)
                        completionHandler(.failure(.invalidData))
                        return
                    }
                    catch{
                        completionHandler(.failure(.invalidResponse))
                        return
                    }
                }
            case .failure(let error):
                completionHandler(.failure(.invalidResponse))
                print(error)
                return
            }
        }
    }
    func makeGetRequest<T: Codable>(_ apiURl: String, modelType: T.Type, isHeader: Bool, completionHandler: @escaping (_ result: T?, _ error: String?, _ code: Int?) -> Void) {
        guard Connectivity.isConnectedToInternet else {
            let message = "No Internet.Please try again"
            completionHandler(nil,  message , Constants.INTERNETFAILCODE)
            return
        }
        
        let strURL = "\(Constants.USERHOST)\(apiURl)"
        print("URL -\(strURL)")
        var headers: HTTPHeaders = [:]
        if isHeader, let authToken = UserDefaults.standard.string(forKey: Constants.AUTHTOKEN) {
            headers["Authorization"] = "pear " + authToken
        }
        print(headers)
        
        AF.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print(JSON(data))
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(modelType, from: data)
                    print(JSON(model))
                    completionHandler(model, nil, response.response?.statusCode)
                    return
                } catch {
                    //completionHandler(nil, Constants.SERVERERROR, response.response?.statusCode)
                    do{
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(FailModel.self, from: data)
                        completionHandler(nil, model.error, response.response?.statusCode)
                        return
                    }
                    catch{
                        completionHandler(nil, Constants.SERVERERROR, response.response?.statusCode)
                        return
                    }
                    
                }
            case .failure(let error):
                completionHandler(nil, Constants.SERVERERROR, response.response?.statusCode)
                print(error)
                return
            }
        }
    }
    
    func imageUpload<T: Codable>(_ apiURl:String, parameters:Data, modelType: T.Type,isHeader:Bool, completionHandler: @escaping (_ result: T?, _ error: String?, _ code: Int?) -> Void) {
        
        
        guard Connectivity.isConnectedToInternet else {
            let message = "No Internet.Please try again"
            completionHandler(nil,  message , Constants.INTERNETFAILCODE)
            return
        }
        
          
           var strURL:String = Constants.USERHOST
           if((apiURl as NSString).length > 0)
           {
               strURL = strURL + apiURl
           }
    //       _ = ["Content-Type": "application/x-www-form-urlencoded"]
    //       _ = ["Content-Type": "application/json"]
          print("URL -\(strURL)")
           
            
            let token = String(format: "pear %@", UserDefaults.standard.object(forKey: Constants.AUTHTOKEN) as! String)
                 
            let headers : HTTPHeaders = ["Authorization":token,
                                         "Content-Type": "multipart/form-data"
            ]

              AF.upload(multipartFormData: { MultipartFormData in

               //  let image: Data = imageData

                  // Add the image data to the request
                  MultipartFormData.append(parameters, withName: "image", fileName: "Unknown-2.png", mimeType: "image/jpeg")
                  MultipartFormData.append("profile".data(using: .utf8)!, withName: "name")
                  
                         
              }, to: strURL, method: .post, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print(JSON(data))
                        do {
                            let decoder = JSONDecoder()
                            let model = try decoder.decode(modelType, from: data)
                            completionHandler(model, nil, response.response?.statusCode)
                            return
                        } catch {
                            
                            print(error)
                            do{
                                let decoder = JSONDecoder()
                                let model = try decoder.decode(FailModel.self, from: data)
                                completionHandler(nil, model.error, response.response?.statusCode)
                                return
                            }
                            catch{
                                completionHandler(nil, Constants.SERVERERROR, response.response?.statusCode)
                                return
                            }
                            
                        }
                    case .failure(let error):
                        completionHandler(nil, Constants.SERVERERROR, response.response?.statusCode)
                        print(error)
                        return
                    }
                }
            
        
        
    }
}
