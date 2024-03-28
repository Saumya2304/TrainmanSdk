//
//  AlertHelper.swift
//  TrainmanBooking_iOSSDK
//
//  Created by Somya on 09/05/22.
//

import Foundation
import UIKit

class AlertHelper {
    func showAlert(vc:UIViewController,msg:String,title:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
