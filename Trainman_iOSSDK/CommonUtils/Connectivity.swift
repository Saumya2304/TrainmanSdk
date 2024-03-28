//
//  Connectivity.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//


import Foundation
import SystemConfiguration

enum ReachabilityStatus {
    case unknown
    case notReachable
    case reachableViaWWan
    case reachableViaWifi
}

class Connectivity {
    
    class var isConnectedToInternet: Bool {
        let status = Connectivity().currentReachabilityStatus
        switch status {
        case .reachableViaWWan, .reachableViaWifi:
            return true
        default:
            return false
        }
    }
    
    private var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouterReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouterReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            return .notReachable
        } else if flags.contains(.isWWAN) == true {
            return .reachableViaWWan
        } else if flags.contains(.connectionRequired) == false {
            return .reachableViaWifi
        } else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic)) == true && flags.contains(.interventionRequired) == false {
            return .reachableViaWifi
        } else {
            return .notReachable
        }
    }
}
