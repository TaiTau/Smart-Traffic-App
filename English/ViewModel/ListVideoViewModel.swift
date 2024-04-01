//
//  QuizViewModel.swift
//  English
//
//  Created by TaiTau on 09/04/2023.
//

import Foundation
import UIKit
class ListVideoViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    //var listCamera: Observable<[CameraModel]> = Observable([])
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    var completeDel: ((ErrorObject?) -> Void)? = { errorObject in}
    var listCamera:[VideoModel] = []
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
    
    func delVideo(id:String){
        APICaller.deleteVideo(id: id) { [weak self] result in
            switch result {
            case .success:
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
    
    func getListCam(id:String) {
        if isLoadingData.value ?? true {
            return
        }
        if(id == ""){
            APICaller.getListVdeo() { [weak self] result in
                self?.isLoadingData.value = false
                switch result {
                case .success(let data):
                    self?.isSuccess.value = true
                    self?.listCamera.removeAll()
                    let userResponse: ListVideoResponse = data
                    // Access user information
                    let user = userResponse.videos
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
        }else{
            APICaller.getHistoryVideo(id: id) { [weak self] result in
                self?.isLoadingData.value = false
                switch result {
                case .success(let data):
                    self?.isSuccess.value = true
                    self?.listCamera.removeAll()
                    let userResponse: ListVideoResponse = data
                    // Access user information
                    let user = userResponse.videos
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
}
