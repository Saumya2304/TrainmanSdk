//
//  Constants.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import Foundation


class Constants:NSObject{
    
    static let jsInterfaceTM = "jsInterfaceTM"
    static var staticUrl:[String:String] = [String:String]()
    
    enum Url : String {
        case Production
        case Staging
    }
    
    
    typealias EmptyCompletion = () -> (Void)
}

struct errorMessages {
    static let defaultAPIErrorMessage = "An error occured. try again after some time."
    static let noInternetConnection = "Check your network and try again"
}
