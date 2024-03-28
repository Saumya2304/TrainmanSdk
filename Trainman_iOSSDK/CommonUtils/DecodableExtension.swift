//
//  DecodableExtension.swift
//  TrainmanBookingSDK
//
//  Created by Somya on 02/05/22.
//
import Foundation

extension Decodable {
    
    init?(from: Any?) {
        
        if let data = from as? Data {
            self.init(data: data)
        } else {
            guard let data = Utility.JSONSerializedData(object: from) else {
                return nil
            }
            self.init(data: data)
        }
    }
    
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print((error as? DecodingError).debugDescription)
            return nil
        }
    }
}

extension Encodable {
    
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
}
