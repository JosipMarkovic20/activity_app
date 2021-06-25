//
//  SerilizationManager.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation

class SerilizationManager{
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
    
    public static func getEncodedObject<T: Codable>(object: T) -> Data?{
        let encodedData: Data?
        do {
            encodedData = try jsonEncoder.encode(object)
        } catch let error {
            debugPrint("Error while encoding. Received dataClassType: \(T.self). More info: \(error)")
            encodedData=nil
        }
        return encodedData
    }
}
