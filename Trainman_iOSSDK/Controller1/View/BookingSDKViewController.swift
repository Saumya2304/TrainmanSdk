//
//  BookingSDKViewController.swift
//  TrainmanBooking_iOSSDK
//
//  Created by Somya on 06/05/22.
//

import UIKit
import WebKit

public class BookingSDKViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    let viewmodel = TMBookingModel()
    let clientPDF = SavePDFFile()
    var url = ""
    static var userdetails:TMBookingRepository.ClientInformation.Request?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.delegate = self
        clientPDF.delegate = self
        //viewmodel.fetchAllStaticUrl()
        showActivityIndicatory()
        self.view.backgroundColor = .white
        registerNib()
        self.loadWebView(urlString: url)
    }
    
    public override func viewWillAppear(_ animated: Bool){
        print("appear")
    }
    
    public func registerNib(){
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "BookingSDKViewController", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
    }
    
    public func setuserDetails(url:String){
        self.url = url
    }
    
    public func setuserDetails(clientid:String,clienttoken:String,clientsecret:String,flag:APP_TYPE){
        BookingSDKViewController.userdetails = TMBookingRepository.ClientInformation.Request(client_id: clientid, client_token: clienttoken, client_secret: clientsecret, grant_type: "password")
        setServerUrl( serverflag: flag)
    }
    
    public func setServerUrl(serverflag:APP_TYPE){
        if serverflag == APP_TYPE.STAGING{ //Stagging
            APIEndPointConstants.baseUrl = APIEndPointConstants.app_staging_url
            APIEndPointConstants.webUrl =  APIEndPointConstants.web_staging_url
        }else if serverflag == APP_TYPE.PRODUCTION{//Prod
            APIEndPointConstants.baseUrl = APIEndPointConstants.app_production_url
            APIEndPointConstants.webUrl = APIEndPointConstants.web_production_url
        }else{// Dev
            APIEndPointConstants.baseUrl = APIEndPointConstants.app_dev_url
            APIEndPointConstants.webUrl = APIEndPointConstants.web_dev_url
        }
    }
    
    //MARK: -ActivityIndicator
    public func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        activityView.tag = 100
        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    
}

//MARK: -WEBVIEW
extension BookingSDKViewController:WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate{
    public func loadWebView(urlString:String){
        DispatchQueue.main.async {
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            self.webView.backgroundColor = .white
            self.webView.navigationDelegate = self
            self.webView.uiDelegate = self
            self.webView.scrollView.isMultipleTouchEnabled = false
            self.webView.load(urlRequest)
            self.webView.configuration.userContentController.add(self, name: Constants.jsInterfaceTM)
            self.removeZoomOut()
            self.showActivityIndicatory()
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(navigationResponse.response.url ?? "")
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start")
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.viewWithTag(100)?.isHidden = true
        self.removeZoomOut()
        print("stop")
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        print(navigationAction.request.url ?? "")
        return nil
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dict:[String:String] = message.body as? [String : String]{
            if dict["close_app"] == "true"{
                self.navigationController?.popViewController(animated: false)
            }else if dict["pdf_url"] != "" {
                clientPDF.savePdf(urlString: dict["pdf_url"] ?? "", fileName: "TrainTicket")
            }
        }
    }
    
    public func removeZoomOut(){
        let script: WKUserScript = WKUserScript(source:  viewmodel.getScriptString(status:"zoomIn"), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
        
    }
    
}

//MARK: -API
extension BookingSDKViewController:BookingModelDelegate {
    func loadwebViewUrl(tokenResponse: String) {
        let urlString = "\(APIEndPointConstants.webUrl)/auth?tokenResponse=\(tokenResponse)"
        loadWebView(urlString: urlString)
        
    }
    
    func loadError(error: String) {
        DispatchQueue.main.async {
            self.view.viewWithTag(100)?.isHidden = true
            AlertHelper().showAlert(vc: self, msg: error, title: "Error")
        }
    }
}

//MARK: - SAVE PDF
extension BookingSDKViewController:SavePdfdelegate {
    func successPdfSave(url:URL) {
        self.view.viewWithTag(100)?.isHidden = true
        UIApplication.shared.open(url)
    }
    
    func failurePdf() {
        self.view.viewWithTag(100)?.isHidden = true
    }
}
