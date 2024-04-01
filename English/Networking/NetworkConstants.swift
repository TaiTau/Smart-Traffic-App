//
//  NetworkConstants.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import Foundation
class NetworkConstants {
    
    public static var shared: NetworkConstants = NetworkConstants()
    
    public var apiKey: String {
        get {
            //https://www.themoviedb.org/
            //Put your own API key here
            return ""
        }
    }
    
    public var serverAddress: String {
        get {
            return "http://127.0.0.1:5555/" // ip tro
           // return "http://192.168.114.194:5555/"
            //return "http://192.168.1.221:5555/"
           // return "http://192.168.0.102:5555/"
            //return "http://192.168.0.100:5555/" // ip nha
        }
    }
    
    public var imageServerAddress: String {
        get {
            return "https://image.tmdb.org/t/p/w500/"
        }
    }
}
