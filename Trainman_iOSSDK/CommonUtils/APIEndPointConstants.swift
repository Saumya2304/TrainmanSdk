//
//  APIEndPointConstants.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import Foundation
public enum  APP_TYPE{
   case PRODUCTION, STAGING ,Dev
}
class APIEndPointConstants{
    
    //    static let baseUrl = "http://68.183.82.159" // Stagging
    //    static let webUrl = app_staging_url
    
    //    static let baseUrl = "https://partner.trainman.in" // Prod
    //    static let webUrl = app_production_url
    
    static var baseUrl = "http://68.183.82.159" // Dev
    static var webUrl = web_dev_url
    
    static let getAllStaticUrl = "\(baseUrl)/static/json/wls-constants.json"
    static var app_production_url = "https://partner.trainman.in"
    static var app_staging_url = "https://partner.flightman.in"
    static var web_production_url = "https://partner.trainman.in"
    static var web_staging_url = "https://partner.flightman.in"
    static var auth_api_end_point = "\(baseUrl)/services/account/authenticate/"
    static var app_dev_url = "http://139.59.82.22"
    static var web_dev_url = "http://139.59.82.22:4200"
}

