//
//  webServiceHelper.swift
//  Trainman
//
//  Created by Shubham Arora on 03/11/21.
//  Copyright © 2021 KaranKumar. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {
    
    func getPostRequestPath(with absolutePath: String,
                            queryParamString: String?) -> String {
        var path = absolutePath
        if let queryParamString = queryParamString, !queryParamString.isEmpty {
            path += "?\(queryParamString)"
        }
        return path
    }
    
    func getDataFrom(response: Any?) -> Data? {
        if let dataDict = (response as? [String: Any])?[""] as? [String: Any], //TODO: Add Key
           let data = Utility.JSONSerializedData(object: dataDict) {
            return data
        } else if let dataDict = response as? [String: Any],
                  let data = Utility.JSONSerializedData(object: dataDict) {
            return data
        } else if let dataDict = (response as? [[String: Any]]),
                  let data = Utility.JSONSerializedData(object: dataDict) {
            return data
        }
        else {
            return nil
        }
    }
    
    //TODO: Code Improvements
    func errorMessage(_ response: Any?) -> String {
        if let error = (response as? [String: Any])?[APIConstantKeys.errorList] as? String {
            return error
        } else if let error = (response as? [String: Any])?[APIConstantKeys.error] as? String {
            return error
        } else if let message = (response as? [String: Any])?[APIConstantKeys.detail] as? String {
            return message
        } else if let errorMessage = (response as? [String: Any])?[APIConstantKeys.errorMessage] as? String {
            return errorMessage
        } else if let errorList = (response as? [String: Any])?[APIConstantKeys.errorList] as? [String] {
            return errorList.joined(separator: ",")
        }
        return errorMessages.defaultAPIErrorMessage
    }
    
    //TODO: Code Improvements
    func isSuccessfulResponse(_ response: Any?) -> Bool {
        if ((response as? [String: Any])?[APIConstantKeys.errorMessage] as? String) != nil {
            return false
        } else if ((response as? [String: Any])?[APIConstantKeys.errorList] as? [String]) != nil {
            return false
        } else if ((response as? [String: Any])?[APIConstantKeys.error] as? String) != nil  && ((response as? [String: Any])?[APIConstantKeys.error] as? String) != "" {
            return false
        } 
        return true
    }
}
