//
//  WebServiceManager.swift
//  Trainman
//
//  Created by Shubham Arora on 03/11/21.
//  Copyright © 2021 KaranKumar. All rights reserved.
//

import UIKit

struct DomainResponse<T: Decodable> {
    enum Result {
        case success(T)
        case failure(String)
    }
    let apiResponse: [String: Any]?
    let result: Result
}

enum APIRequestType {
    case get
    case post
}

struct DisplayableError: Error, LocalizedError {
    let errorDescription: String?
    
    init(_ description: String) {
        errorDescription = description
    }
}

protocol WebServiceProtocol {
    func fireRequestWith<T: Decodable>(params: [String: Any]?,
                                       requestPath: String,
                                       requestType: APIRequestType,
                                       body: [String: Any]?,
                                       headers: [String: String]?,
                                       requestTimeout: TimeInterval?,
                                       completion: @escaping (DomainResponse<T>) -> ())
}

class WebServiceManager:  WebServiceProtocol {
    
    private let helper: WebServiceHelper = WebServiceHelper()
    
    func fireRequestWith<T>(params: [String : Any]?, requestPath: String, requestType: APIRequestType, body: [String : Any]?, headers: [String : String]?, requestTimeout: TimeInterval?, completion: @escaping (DomainResponse<T>) -> ()) where T : Decodable {
        
        guard Connectivity.isConnectedToInternet else {
            completion(DomainResponse<T>(apiResponse: nil,
                                         result: .failure(errorMessages.noInternetConnection)))
            
            return
        }
        
       
        let paramAsJsonString = Utility.queryParamString(dict: params)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url: String = helper.getPostRequestPath(with: requestPath, queryParamString: paramAsJsonString)
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        switch requestType {
        case .get:
            request.httpMethod = "GET"
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        self.handleSuccess(response: json, completion: completion)
                    } catch {
                        self.handleError(response: response, error: error, completion: completion)
                    }
                }
            }.resume()
            break
        case .post:
            request.httpMethod = "POST"
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body ?? [:], options: []) else {
                return
            }
            request.httpBody = httpBody
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        self.handleSuccess(response: json, completion: completion)
                    } catch {
                        print(error)
                        self.handleError(response: response, error: error, completion: completion)
                    }
                }
            }.resume()
            break
        }
        
    }
    
    private func handleSuccess <T: Decodable>(response:Any? ,completion: @escaping (DomainResponse<T>) -> ()){
        if let responseData = self.responseData(response: response),
           let modelObject = T.init(from: responseData)  {
            completion(DomainResponse<T>(apiResponse: response as? [String: Any],
                                         result: .success(modelObject)))
        } else {
            completion(DomainResponse<T>(apiResponse: response as? [String: Any],
                                         result: .failure(errorMessage(response: response))))
        }
    }
    
    private func handleError <T: Decodable>(response:Any?,error:Error ,completion: @escaping (DomainResponse<T>) -> ()){
        if let responseData = (error as NSError).userInfo[APIConstantKeys.afnetworkingErrorResponseKey],
           let errorObject = T.init(from: responseData) {
            completion(DomainResponse<T>(apiResponse: nil,
                                         result: .success(errorObject)))
        } else {
            completion(DomainResponse<T>(apiResponse: self.formErrorResponse(error: error.localizedDescription),
                                         result: .failure(errorMessages.defaultAPIErrorMessage)))
        }
    }
    
}
//
extension WebServiceManager {
    
    private func isUnauthError(_ uriResponse: HTTPURLResponse?) -> Bool {
        if let httpResponse = uriResponse,
           httpResponse.statusCode == 403 {
            return true
        } else {
            return false
        }
    }
    
    private func responseData(response: Any?) -> Data? {
        guard let response = response else {
            return nil
        }
        return helper.isSuccessfulResponse(response) ? helper.getDataFrom(response: response) : nil
    }
    
    private func errorMessage(response: Any?) -> String {
        helper.errorMessage(response)
    }
    
    private func formErrorResponse(error: String) -> [String: Any] {
        [APIConstantKeys.errorMsg: error]
    }
}

