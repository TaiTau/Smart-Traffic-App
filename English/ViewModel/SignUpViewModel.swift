//
//  SignUpViewModel.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation
import UIKit
class SignUpViewModel {
    
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    func signUp(phone: String,password: String,email:String,name:String, address:String) {
        if isLoadingData.value ?? true {
            return
        }
        
        APICaller.signUp(phone: phone, password: password,email:email,name:name, address:address) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success:
                self?.isSuccess.value = true
                
               // let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            //    let userResponse: BaseResponse = data
                // Access user information
                
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(nil) // Perform UI-related updates here
                }
            case .failure(let err):
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(err)// Perform UI-related updates here
                }
            }
        }
    }
    
    func updateUser(phone: String,email:String,name:String, address:String) {
        if isLoadingData.value ?? true {
            return
        }
        let user_id = Utility.getKeyValue(identifier: "USER_ID")!
        APICaller.updateUser(id:user_id, phone: phone,email:email,name:name, address:address) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success:
                self?.isSuccess.value = true
                
               // let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            //    let userResponse: BaseResponse = data
                // Access user information
                
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(nil) // Perform UI-related updates here
                }
            case .failure(let err):
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(err)// Perform UI-related updates here
                }
            }
        }
    }
    
    
    func updateProfileToServer(image: UIImage,rawImage:UIImage, name: String, phone: String, email: String,address:String) {
      
        
        let urlString = "\(NetworkConstants.shared.serverAddress)updateUser"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        if(image != rawImage){
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Could not get JPEG representation of image")
                return
            }
            // Add image data to the request body  person.circle
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        let user_id = Utility.getKeyValue(identifier: "USER_ID")!
        appendMultipartFormData(&body, boundary: boundary, key: "id", value: user_id)
        appendMultipartFormData(&body, boundary: boundary, key: "name", value: name)
        appendMultipartFormData(&body, boundary: boundary, key: "phone", value: phone)
        appendMultipartFormData(&body, boundary: boundary, key: "email", value: email)
        appendMultipartFormData(&body, boundary: boundary, key: "address", value: address)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle server response here
            if let error = error {
                print("Error: \(error)")
                return
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(nil) // Perform UI-related updates here
                }
            }
            // Process response
        }
        task.resume()
    }
    
    func appendMultipartFormData(_ body: inout Data, boundary: String, key: String, value: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    func uploadProfileToServer(image: UIImage, name: String, phone: String, email: String,password:String,address:String) {
      
        
        let urlString = "\(NetworkConstants.shared.serverAddress)signup"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        if(image != UIImage(systemName: "person.circle")){
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Could not get JPEG representation of image")
                return
            }
            // Add image data to the request body  person.circle
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        appendMultipartFormData(&body, boundary: boundary, key: "name", value: name)
        appendMultipartFormData(&body, boundary: boundary, key: "phone", value: phone)
        appendMultipartFormData(&body, boundary: boundary, key: "email", value: email)
        appendMultipartFormData(&body, boundary: boundary, key: "password", value: password)
        appendMultipartFormData(&body, boundary: boundary, key: "address", value: address)

        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle server response here
            if let error = error {
                print("Error: \(error)")
                return
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(nil) // Perform UI-related updates here
                }
            }
            // Process response
        }
        task.resume()
    }


}
