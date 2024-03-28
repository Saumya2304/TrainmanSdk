//
//  TMBookingRepository.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import Foundation
import UIKit
protocol TMBookingRepositoryProtocol{
    func fetchConstatntUrl(completionHandler: @escaping (DomainResponse<[String:String]>) -> ())
    func checkValidationUrl(params:TMBookingRepository.ClientInformation.Request,completionHandler: @escaping (DomainResponse<TMBookingRepository.ValidationToken.Response>) -> ())
}

class TMBookingRepository:TMBookingRepositoryProtocol{
    
    
    let serviceManager: WebServiceProtocol
    
    init(serviceManager: WebServiceProtocol = WebServiceManager()) {
        self.serviceManager = serviceManager
    }
    
    struct ValidationToken {
        struct Response: Decodable {
            let data: TokenResponse?
            let error: String?
            
            struct TokenResponse:Decodable{
                let token_response: String?
            }
        }
    }
    
    struct ClientInformation{
        struct Request:Encodable{
            let client_id :String 
            let client_token :String
            let client_secret :String
            let grant_type :String
        }
    }
    
    func fetchConstatntUrl(completionHandler: @escaping (DomainResponse<[String:String]>) -> ()) {
        serviceManager.fireRequestWith(params: nil, requestPath: APIEndPointConstants.getAllStaticUrl, requestType: .get, body: nil, headers: nil, requestTimeout: nil) {(response:DomainResponse<[String:String]>) in
            completionHandler(response)
        }
    }
    
    
    func checkValidationUrl(params:TMBookingRepository.ClientInformation.Request,completionHandler: @escaping (DomainResponse<ValidationToken.Response>) -> ()) {
        serviceManager.fireRequestWith(params: nil, requestPath: APIEndPointConstants.auth_api_end_point, requestType: .post, body: params.toDictionary(), headers: nil, requestTimeout: nil) {(response:DomainResponse<ValidationToken.Response>) in
            completionHandler(response)
        }
    }
    
}
