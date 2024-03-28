//
//  BaseViewModel.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//

import Foundation

protocol BaseViewModelDelegate: AnyObject {
    
    func failedToLoadData(_ error: String)
}

protocol BaseViewModelType {
    func bootstrap()
    var delegate: delegateType? { get }
    var dataSource: dataSourceType { get }
    associatedtype delegateType
    associatedtype dataSourceType
}
