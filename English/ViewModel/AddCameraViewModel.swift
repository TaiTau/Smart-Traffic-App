//
//  AddCameraViewModel.swift
//  Smart Traffic
//
//  Created by TaiTau on 06/01/2024.
//

import Foundation
class AddCameraViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    func addCamera(name: String, address: String, lat: Double, lng: Double, note: String) {
        if isLoadingData.value ?? true {
            return
        }
        let userID = Utility.getKeyValue(identifier: "USER_ID")!
        let creator = Utility.getKeyValue(identifier: "NAME")!
        APICaller.addCamera(userId: Int(userID) ?? 0, name: name, address: address, creator: creator, lat: lat, lng: lng, note: note) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let data):
                self?.isSuccess.value = true
                
               // let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                let userResponse: BaseResponse = data
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
    
    func updateCamera(name: String, address: String, lat: Double, lng: Double, note: String) {
        if isLoadingData.value ?? true {
            return
        }
        let userID = Utility.getKeyValue(identifier: "USER_ID")!
        let creator = Utility.getKeyValue(identifier: "NAME")!
        APICaller.updateCamera(userId: Int(userID) ?? 0, name: name, address: address, creator: creator, lat: lat, lng: lng, note: note) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let data):
                self?.isSuccess.value = true
                
               // let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                let userResponse: BaseResponse = data
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
}
