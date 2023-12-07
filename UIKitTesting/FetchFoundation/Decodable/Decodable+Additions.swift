//
//  Decodable+Additions.swift
//  FetchHop
//
//  Created by Yevhen Strohanov on 4/29/20.
//  Copyright © 2020 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

extension Decodable {
    public static func dateDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        return decoder
    }
    
    public static func decode(json: String) throws -> Self {
        guard let jsonData = json.data(using: .utf8) else {
            throw DataError.noData
        }
        
        return try dateDecoder().decode(Self.self, from: jsonData)
    }

    public static func decode(data: Data) throws -> Self {
        return try dateDecoder().decode(Self.self, from: data)
    }

    public static func decode(dictionary: [String: Any]) throws -> Self {
        return try dateDecoder().decode(Self.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }

    public static func object(from dictionary: NSDictionary) -> Self? {
        guard let dictionary = dictionary as? [String: Any] else { return nil }
        return try? Self.decode(dictionary: dictionary)
    }
}

extension Array where Element: Decodable {
    static func decode(data: Data) throws -> Self {
        return try dateDecoder().decode([Element].self, from: data)
    }
}
