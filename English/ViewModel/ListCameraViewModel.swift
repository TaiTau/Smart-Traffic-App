//
//  ListCameraViewModel.swift
//  Traffic-Light App
//
//  Created by TaiTau on 04/01/2024.
//

import Foundation
class ListCameraViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    //var listCamera: Observable<[CameraModel]> = Observable([])
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    var listCamera:[CameraModelAPI] = []
    func getListCam() {
        if isLoadingData.value ?? true {
            return
        }
        
        APICaller.getListCamera() { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let data):
                self?.isSuccess.value = true
                self?.listCamera.removeAll()
                let userResponse: ListCameraResponse = data
                // Access user information
                 let user = userResponse.cameras
                    for item in user{
                        self?.listCamera.append( contentsOf: item)
                    }
                            
                print("self?.listCamera",self?.listCamera,result)
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(nil) 
                    print(" complete")// Perform UI-related updates here
                }
                print(" DispatchQueue")
            case .failure(let err):
                //self?.isSuccess.value = false
                print("ko co dataa")
                DispatchQueue.main.async { [weak self] in
                    self?.complete?(err)// Perform UI-related updates here
                }
            }
        }
    }
}
