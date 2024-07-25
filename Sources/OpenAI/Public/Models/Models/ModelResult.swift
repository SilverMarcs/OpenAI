//
//  Model.swift
//
//
//  Created by Aled Samuel on 08/04/2023.
//

import Foundation

/// The model object matching the specified ID.
public struct ModelResult: Codable, Equatable {
    /// The model identifier, which can be referenced in the API endpoints.
    public let id: String
    /// The proper name of model
    public let name: String
    /// The Unix timestamp (in seconds) when the model was created.
    public let created: TimeInterval?
    /// The object type, which is always "model".
    public let object: String?
    /// The organization that owns the model.
    public let ownedBy: String?
    
    // Custom initializer to handle decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? self.id.capitalized
        self.created = try container.decodeIfPresent(TimeInterval.self, forKey: .created)
        self.object = try container.decodeIfPresent(String.self, forKey: .object)
        self.ownedBy = try container.decodeIfPresent(String.self, forKey: .ownedBy)
    }

    public init(id: String, name: String?, created: TimeInterval?, object: String?, ownedBy: String?) {
        self.id = id
        self.name = name ?? id.capitalized
        self.created = created
        self.object = object
        self.ownedBy = ownedBy
    }

    // Coding keys to map the JSON keys to the struct properties
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case created
        case object
        case ownedBy = "owned_by"
    }
}
