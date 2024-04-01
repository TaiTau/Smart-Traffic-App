//
//  APICaller.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import Foundation
enum NetworkError: Error {
    case urlError
    case canNotParseData
}

public class APICaller {
    static func callLogin(phone: String,password:String, completionHandler: @escaping (_ result: Result<UserResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress + "login/\(phone)/\(password)"
        print("urlString034",urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: dataResponse!)
                print(userResponse.user) // Access the user array within UserResponse
            } catch {
                print("Error decoding JSON: \(error)")
            }
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(UserResponse.self, from: data) {
                print("resultData",resultData)
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print("failed",err.debugDescription)
            }
        }.resume()
    }
    
    static func signUp(phone: String,password:String,email:String,name:String, address:String,  completionHandler: @escaping (_ result: Result<BaseResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress + "signup/\(name)/\(password)/\(email)/\(address)/\(phone)"
        print("urlString034",urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            do {
                let userResponse = try JSONDecoder().decode(BaseResponse.self, from: dataResponse!)
               // print(userResponse.user) // Access the user array within UserResponse
            } catch {
                print("Error decoding JSON: \(error)")
            }
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                print("resultData",resultData)
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors!))
                }
            } else {
                print("failed",err.debugDescription)
            }
        }.resume()
    }
    
    static func updateUser(id:String, phone: String,email:String,name:String, address:String,  completionHandler: @escaping (_ result: Result<BaseResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress + "updateUser/\(id)/\(name)/\(phone)/\(email)/\(address)"
        print("urlString034",urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            do {
                let userResponse = try JSONDecoder().decode(BaseResponse.self, from: dataResponse!)
               // print(userResponse.user) // Access the user array within UserResponse
            } catch {
                print("Error decoding JSON: \(error)")
            }
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                print("resultData",resultData)
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors!))
                }
            } else {
                print("failed",err.debugDescription)
            }
        }.resume()
    }
    
    static func addCamera(userId: Int,name:String,address:String,creator:String, lat:Double, lng:Double, note:String,  completionHandler: @escaping (_ result: Result<BaseResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress + "insertCamera/\(userId)/\(name)/\(address)/\(creator)/\(lat)/\(lng)/\(note)"
        print("urlString034",urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            do {
                let userResponse = try JSONDecoder().decode(BaseResponse.self, from: dataResponse!)
               // print(userResponse.user) // Access the user array within UserResponse
            } catch {
                print("Error decoding JSON: \(error)")
            }
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                print("resultData",resultData)
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors!))
                }
            } else {
                print("failed",err.debugDescription)
            }
        }.resume()
    }
    
    static func updateCamera(userId: Int,name:String,address:String,creator:String, lat:Double, lng:Double, note:String,  completionHandler: @escaping (_ result: Result<BaseResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress + "updateCamera/\(userId)/\(name)/\(address)/\(creator)/\(lat)/\(lng)/\(note)"
        print("urlString034",urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            do {
                let userResponse = try JSONDecoder().decode(BaseResponse.self, from: dataResponse!)
               // print(userResponse.user) // Access the user array within UserResponse
            } catch {
                print("Error decoding JSON: \(error)")
            }
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                print("resultData",resultData)
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors!))
                }
            } else {
                print("failed",err.debugDescription)
            }
        }.resume()
    }
    
    
    static func getListUser(completionHandler: @escaping (_ result: Result<ListUserResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "users/0" 
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListUserResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print(err.debugDescription)
            }
        }.resume()
    }
    
    static func getListVdeo(completionHandler: @escaping (_ result: Result<ListVideoResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "listVideo/0"
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListVideoResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print(err.debugDescription)
            }
        }.resume()
    }
    
    static func getHistoryVideo(id:String, completionHandler: @escaping (_ result: Result<ListVideoResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "getHistoryVideo/" + id
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListVideoResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print(err.debugDescription)
            }
        }.resume()
    } 
    
    static func getImage(id:String, completionHandler: @escaping (_ result: Result<ListImageResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "getlistImage/" + id
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListImageResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print(err.debugDescription)
            }
        }.resume()
    }
    
    static func deleteVideo(id:String, completionHandler: @escaping (_ result: Result<BaseResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "deleteVideo/" + id
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors!))
                }
            } else {
                print(err.debugDescription)
            }
        }.resume()
    }
    
    static func getListCamera(completionHandler: @escaping (_ result: Result<ListCameraResponse, ErrorObject>) -> Void) {

        let urlString = NetworkConstants.shared.serverAddress +
                "listCamera/" + "0"
                
        guard let url = URL(string: urlString) else {
            return
        }
        print("apicaller",url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
          //  print("erere", err)
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(ListCameraResponse.self, from: data) {
                if(resultData.success == 1){
                    completionHandler(.success(resultData))
                }else{
                    completionHandler(.failure(resultData.errors))
                }
            } else {
                print("ko co gi",err.debugDescription)
            }
        }.resume()
        
    }
    
    
   
   
}
