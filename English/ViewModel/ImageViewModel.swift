//
//  ImageViewModel.swift
//  Smart Traffic
//
//  Created by TaiTau on 19/01/2024.
//

import Foundation
class ImageViewModel {
    var completeDel: ((ErrorObject?) -> Void)? = { errorObject in}
    var listImage:[ImageModel] = []
    func getImage(id:String){
        APICaller.getImage(id: id){ [weak self] result in
            switch result {
            case .success(let data):
                
                let userResponse: ListImageResponse = data
                // Access user information
                let user = userResponse.videos
                for item in user{
                    self?.listImage.append( contentsOf: item)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.completeDel?(nil)
                    print(" complete")// Perform UI-related updates here
                }
                print(" DispatchQueue")
            case .failure(let err):
                //self?.isSuccess.value = false
                print("ko co dataa")
                DispatchQueue.main.async { [weak self] in
                    self?.completeDel?(err)// Perform UI-related updates here
                }
            }
        }
    }
}
