//
//  Logger.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//
import Foundation

class Logger {
    static let emptyRequestData = "Empty request data."
    static let noData = "No Data."
    static let noErrorData = "No Error data."
    
    private static func logData(_ data: String) {
        //TODO: Use conditional directives to not print data in console for particular scheme
        print(data)
    }
    
    static func logRequest(_ data: String?) {
        Logger.logData("\n Logger: Reuest \n \(data ?? Logger.emptyRequestData)")
    }
    
    static func logResponse(_ data: Any?, url: String) {
        if let dataDict = data as? NSDictionary,
           let jsonString = Utility.JSONStringify(object: dataDict, prettyPrinted: true) {
            Logger.logData("\n Logger: URL: \(url)\n Response: \n \(jsonString)\n")
        } else {
            Logger.logData("\n Logger: URL: \(url)\n Response: \(String(describing: data ?? Logger.noData))\n")
        }
    }
    
    static func logError(_ data: String?, url: String) {
        self.logData("\n Logger: URL: \(url)\n Error: \(String(describing: data ?? Logger.noErrorData))\n")
    }
    
    static func logData(_ data: String?) {
        self.logData("\n Logger: Data in \(data ?? Logger.noData)\n")
    }
}
