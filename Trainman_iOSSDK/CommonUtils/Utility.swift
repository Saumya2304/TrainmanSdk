//
//  Utility.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import UIKit

class Utility: NSObject {
    
    static func JSONStringify(object: Any?,
                              prettyPrinted: Bool = false) -> String? {
        guard let object = object else {
            return nil
        }
        if JSONSerialization.isValidJSONObject(object),
           let jsonData = Utility.JSONSerializedData(object: object,
                                                     prettyPrinted: prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    static func JSONSerializedData(object: Any?,
                                   prettyPrinted: Bool = false) -> Data? {
        guard let object = object else {
            return nil
        }
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object,
                                                      options: options)
            return jsonData
        } catch {
            Logger.logData(error.localizedDescription)
            return nil
        }
    }
    
    static func queryParamString(dict: Dictionary<String, Any>?) -> String? {
        guard let dict = dict else {
            return nil
        }
        
        var resultedString = ""
        let keys  = dict.keys
        
        guard keys.count > 0 else {
            return resultedString
        }
        keys.enumerated().forEach { (index, key) in
            resultedString.append(key)
            resultedString.append("=")
            resultedString.append(String(describing: dict[key] ?? ""))
            
            if index != (keys.count - 1) {
                resultedString.append("&")
            }
        }
        return resultedString
    }
    
    static func authHeaders() -> [String: String] {
      
        return [:]
    }
    
    static func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}
