//
//  MainViewModel.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import Foundation
class LoginViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    func login(phone: String,password: String) {
        if isLoadingData.value ?? true {
            return
        }
        
        APICaller.callLogin(phone: phone, password: password) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let data):
                self?.isSuccess.value = true
                
               // let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                let userResponse: UserResponse = data
                // Access user information
                if let user = userResponse.user.first {
                    Utility.registerKey("NAME", withValue: user.NAME)
                    Utility.registerKey("ADDRESS", withValue: user.ADDRESS)
                    Utility.registerKey("EMAIL", withValue: user.EMAIL)
                    Utility.registerKey("PASSWORD", withValue: user.PASSWORD)
                    Utility.registerKey("PHONE", withValue: user.PHONE)
                    Utility.registerKey("URL_AVATAR", withValue: String(user.URL_AVATAR!))
                    Utility.registerKey("USER_ID", withValue: String(user.USER_ID))
                    print("User ID: \(user.ADDRESS)")
                    print("Name: \(user.NAME)")
                    print("Email: \(user.EMAIL)")
                }
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
