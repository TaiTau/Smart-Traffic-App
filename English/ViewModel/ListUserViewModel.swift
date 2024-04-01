//
//  ListUserViewModel.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation
class ListUserViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    var listCamera:[UserModel] = []
    func getListUser() {
        if isLoadingData.value ?? true {
            return
        }
        print("alo")
        
        APICaller.getListUser() { [weak self] result in
            self?.isLoadingData.value = false
            print("rể", result)
            
            switch result {
            case .success(let data):
                self?.isSuccess.value = true
                let userResponse: ListUserResponse = data
//                // Access user information
                 let user = userResponse.users
                    for item in user{
                        self?.listCamera.append( contentsOf: item)
                    }
                            
                print("self?.user",self?.listCamera,result)
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
