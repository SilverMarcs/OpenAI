//
//  ModelsResult.swift
//
//
//  Created by Aled Samuel on 08/04/2023.
//

import Foundation

/// A list of model objects.
public struct ModelsResult: Codable, Equatable {
    /// A list of model objects.
    public let data: [ModelResult]
    // The object type, which is always `list`
    public let object: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([ModelResult].self, forKey: .data)
        self.object = try container.decodeIfPresent(String.self, forKey: .object)
    }

    public init(data: [ModelResult], object: String?) {
        self.data = data
        self.object = object
    }

    public enum CodingKeys: String, CodingKey {
        case data
        case object
    }
}

