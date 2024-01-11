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
    private let cache = NSCache<NSString,UIImage>()

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
            headers["Authorization"] = "Bearer" + authToken
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
                        if model.error == "invalid_credentials"{
                            completionHandler(.failure(.invalidCredentials))
                        }
                        else{
                            completionHandler(.failure(.invalidData))
                        }
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
            headers["Authorization"] = "Bearer" + authToken
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
    
    func imageUpload(_ apiURl:String, parameters:[String:Any],imageData:Data,imageName:String, mediaType: String,isHeader:Bool, completionHandler:  @escaping (Result<String?,AGError>) -> Void) {


        guard Connectivity.isConnectedToInternet else {
            completionHandler(.failure(.unableToComplete))
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


            let token = String(format: "Bearer %@", UserDefaults.standard.object(forKey: Constants.AUTHTOKEN) as! String)

            let headers : HTTPHeaders = ["Authorization":token,
                                         "Content-Type": "multipart/form-data"
            ]

        AF.upload(multipartFormData: { multipartFormData in
            
            //  let image: Data = imageData
            
            
            multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: mediaType)
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key )
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key )
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
                
                
            }
        }, to: strURL, method: .post, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                            completionHandler(.success("Success"))
                            return
                        
                    case .failure(let error):
                        completionHandler(.failure(.invalidResponse))
                        print(error)
                        return
                    }
                }



    }
    
    func makeDeleteRequest<T: Codable>(_ apiURl:String, parameters:[String:Any], modelType: T.Type,isHeader:Bool, completionHandler: @escaping (Result<T?,AGError>) -> Void) {
        guard Connectivity.isConnectedToInternet else {
            completionHandler(.failure(.unableToComplete))
            return
        }
        
        let strURL = "\(Constants.USERHOST)\(apiURl)"
        print("URL -\(strURL),parameters - \(parameters)")
        var headers: HTTPHeaders = [:]
        if isHeader, let authToken = UserDefaults.standard.string(forKey: Constants.AUTHTOKEN) {
            headers["Authorization"] = "Bearer" + authToken
        }
        print(headers)
        
        AF.request(strURL, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print(JSON(data))
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(modelType, from: data)
                    completionHandler(.success(model))
                    return
                } catch {
                    
                       print(error)
                        completionHandler(.failure(.invalidData))
                        return
                   
                }
            case .failure(let error):
                completionHandler(.failure(.invalidResponse))
                print(error)
                return
            }
        }
    }
   
    func downloadImage(fromURLStrings urlstring:String,completed:@escaping(UIImage?)->Void){
        let cacheKey = NSString(string: urlstring)
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        guard let url = URL(string:urlstring) else{
            completed(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url:url)){
            data,response,error in
            
            guard let data = data,let image = UIImage(data: data) else{
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
        
    }
}
