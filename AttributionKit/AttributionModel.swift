//
//  AttributionModel.swift
//  AttributionKit
//
//  Created by Corey Davis on 7/29/23.
//

import Foundation

public struct AttributionModel: Codable {
    public var name: String
    public var license: String
    
    public init(name: String, license: String) {
        self.name = name
        self.license = license
    }
}

extension AttributionModel {
    public static func make() -> [AttributionModel] {
        guard
            let path = Bundle.main.path(forResource: "Attributions", ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            let attributions = try? PropertyListDecoder().decode([AttributionModel].self, from: data)
        else { return [] }
        let sorted = sort(attributions)
        return sorted
    }
    
    private static func sort(_ models: [AttributionModel]) -> [AttributionModel] {
        return models.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
