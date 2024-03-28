//
//  TMBookingModel.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import Foundation

protocol BookingModelDelegate:AnyObject{
    func loadwebViewUrl(tokenResponse:String)
    func loadError(error:String)
}

class TMBookingModel:BaseViewModelDelegate{
    
    var dataSource: TMBookingRepositoryProtocol
    weak var delegate: BookingModelDelegate?

    init(dataSource: TMBookingRepositoryProtocol = TMBookingRepository()) {
        self.dataSource = dataSource
    }
    
    func fetchAllStaticUrl(){
        dataSource.fetchConstatntUrl{ [weak self] response in
            switch response.result {
            case .success(let data):
                if data.count > 0{
                    self?.setApikeyPoint(data: data)
                    self?.checkValidation()
                }
            case .failure(let error):
                self?.failedToLoadData(error)
            }
        }
    }
    
    func setApikeyPoint(data:[String:String]){
        if let webStagingUrl = data["web_staging_url"]{
            APIEndPointConstants.web_staging_url = webStagingUrl
        }
        if let webProductionUrl = data["web_production_url"]{
            APIEndPointConstants.web_production_url = webProductionUrl
        }
        if let appProductionUrl = data["app_production_url"]{
            APIEndPointConstants.app_production_url = appProductionUrl
        }
        if let appStagingUrl = data["app_staging_url"]{
            APIEndPointConstants.app_staging_url = appStagingUrl
        }
        if let authApiEndPoint = data["auth_api_end_point"]{
            APIEndPointConstants.auth_api_end_point = "\(APIEndPointConstants.baseUrl)\(authApiEndPoint)"
        }
        if let appDevUrl = data["app_dev_url"]{
            APIEndPointConstants.app_dev_url = appDevUrl
        }
        if let webDevUrl = data["web_dev_url"]{
            APIEndPointConstants.web_dev_url = webDevUrl
        }
    }
    
    func checkValidation(){
        dataSource.checkValidationUrl(params: TMBookingRepository.ClientInformation.Request(client_id: BookingSDKViewController.userdetails?.client_id ?? "" , client_token: BookingSDKViewController.userdetails?.client_token ?? "", client_secret: BookingSDKViewController.userdetails?.client_secret ?? "",grant_type:"password"),completionHandler: { [weak self] response in
            switch response.result {
            case .success(let data):
                print(data)
                self?.loadWebViewUrl(token: data.data?.token_response ?? "")
            case .failure(let error):
                self?.failedToLoadData(error)
            }
        })
    }
    
    func loadWebViewUrl(token:String){
        self.delegate?.loadwebViewUrl(tokenResponse: token)
    }
    
    func failedToLoadData(_ error: String) {
        self.delegate?.loadError(error: error)
    }
    
    func getScriptString(status:String) -> String{
            switch status{
            case "zoomIn" :
                return "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" +
                "head.appendChild(meta);"
            case "backbtn" : 
                return "window.webkit.messageHandlers.\(Constants.jsInterfaceTM).postMessage({'close_app':'true'});"
        
            default:
                return ""
            }
        }
    }

struct CloseApp:Encodable{
    let close_app:String
}
