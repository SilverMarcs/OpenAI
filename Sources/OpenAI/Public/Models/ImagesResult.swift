//
//  ImagesResult.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

/// Returns a list of image objects.
public struct ImagesResult: Decodable, Equatable {

    public let created: TimeInterval
    public let data: [Self.Image]

    /// Represents the url or the content of an image generated by the OpenAI API.
    public struct Image: Decodable, Equatable {

        /// The base64-encoded JSON of the generated image, if response_format is b64_json
        public let b64Json: String?
        /// The prompt that was used to generate the image, if there was any revision to the prompt.
        public let revisedPrompt: String?
        /// The URL of the generated image, if response_format is url (default).
        public let url: String?

        public enum CodingKeys: String, CodingKey {
            case b64Json = "b64_json"
            case revisedPrompt = "revised_prompt"
            case url
        }
    }

    public enum CodingKeys: CodingKey {
        case created
        case data
    }
}
