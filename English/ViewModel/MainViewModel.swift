//
//  MainViewModel.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation
class MainViewModel {
    var isLoadingData: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var complete: ((ErrorObject?) -> Void)? = { errorObject in}
    var completeDel: ((ErrorObject?) -> Void)? = { errorObject in}
    func uploadVideo(fileUrl: String) {
        if isLoadingData.value ?? true {
            return
        }
        uploadVideo(fileUrl: fileUrl)
    }
    
    
    func uploadVideo(name:String,user_id:String,camera_id:String,video_id:String, fileURL: URL, completion: @escaping (Error?) -> Void) {
        let uploadURL = URL(string: "\(NetworkConstants.shared.serverAddress)insertVideo/\(name)/\(user_id)/\(video_id)/\(camera_id)")! // Replace with your Flask server endpoint
        //let uploadURL = URL(string: "http://192.168.1.221:5555/insertVideo/\(name)/\(user_id)/\(video_id)/\(camera_id)")! // Replace with your Flask server endpoint
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let videoData = try? Data(contentsOf: fileURL)
        
        var body = Data()
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
        if let videoData = videoData {
            body.append(videoData)
        }
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            // Handle the server response if needed
            
            completion(nil) // Completion without error means successful upload
        }
        
        task.resume()
    }
}
