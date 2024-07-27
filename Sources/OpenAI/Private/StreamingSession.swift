//
//  StreamingSession.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 18/04/2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Combine

final class StreamingSession<ResultType: Codable>: NSObject, Identifiable, URLSessionDelegate, URLSessionDataDelegate, Cancellable {
    
    enum StreamingError: Error {
        case unknownContent
        case emptyContent
    }
    
    var onReceiveContent: ((StreamingSession, ResultType) -> Void)?
    var onProcessingError: ((StreamingSession, Error) -> Void)?
    var onComplete: ((StreamingSession, Error?) -> Void)?
    
    private let streamingCompletionMarker = "[DONE]"
    private let urlRequest: URLRequest
    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var previousChunkBuffer = ""

    // Property to keep track of the URLSessionTask
        private var dataTask: URLSessionDataTask?
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    func perform() {
        dataTask = self.urlSession.dataTask(with: self.urlRequest)
        dataTask?.resume()
    }
    
    // Method to cancel the URLSessionTask
    func cancel() {
        dataTask?.cancel()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onComplete?(self, error)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let stringContent = String(data: data, encoding: .utf8) else {
            onProcessingError?(self, StreamingError.unknownContent)
            return
        }
        processJSON(from: stringContent)
    }
    
}

extension StreamingSession {
    
    #if DEBUG
    private func processJSON(from stringContent: String) {
//        print("Raw string content received:\n\(stringContent.trimmingCharacters(in: .whitespacesAndNewlines))")
        
        if stringContent.isEmpty {
            print("⚠️ Received empty string content")
            return
        }
        
        let jsonObjects = "\(previousChunkBuffer)\(stringContent)"
            .components(separatedBy: "data:")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
//        print("Processed JSON objects:\n\(jsonObjects.joined(separator: "\n"))")
        
        previousChunkBuffer = ""
        
        for (index, jsonContent) in jsonObjects.enumerated() {
            print("\n--- Processing JSON content #\(index + 1) ---")
            prettyPrintJSON(jsonContent)
            
            if jsonContent.hasPrefix(":") {
                print("⏩ Skipping SSE comment")
                continue
            }
            
            if jsonContent == streamingCompletionMarker {
                print("🏁 Stream completion marker found, skipping")
                continue
            }
            
            let parts = jsonContent.components(separatedBy: "\n\n:")
            let cleanJsonContent = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let jsonData = cleanJsonContent.data(using: .utf8) else {
                print("❌ Failed to convert JSON content to Data")
                onProcessingError?(self, StreamingError.unknownContent)
                continue
            }
            
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(ResultType.self, from: jsonData)
                print("✅ Successfully decoded JSON")
                onReceiveContent?(self, object)
            } catch {
                print("❌ Error decoding JSON:")
                print("🔍 Error details: \(error)")
                print("🔍 Problematic JSON content:")
                prettyPrintJSON(cleanJsonContent)
                
                if let decoded = try? decoder.decode(APIErrorResponse.self, from: jsonData) {
                    print("⚠️ Decoded as API Error Response")
                    onProcessingError?(self, decoded)
                } else if index == jsonObjects.count - 1 {
                    print("📌 Partial JSON detected, storing in buffer")
                    previousChunkBuffer = "data: \(cleanJsonContent)"
                } else {
                    print("❓ Unhandled JSON decoding error")
                    onProcessingError?(self, error)
                }
            }
        }
        
        print("🏁 Finished processing all JSON objects")
    }
    #else
    private func processJSON(from stringContent: String) {
        if stringContent.isEmpty {
            return
        }
        
        let jsonObjects = "\(previousChunkBuffer)\(stringContent)"
            .components(separatedBy: "data:")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        previousChunkBuffer = ""
        
        for (index, jsonContent) in jsonObjects.enumerated() {
            if jsonContent.hasPrefix(":") {
                continue
            }
            
            if jsonContent == streamingCompletionMarker {
                continue
            }
            
            let parts = jsonContent.components(separatedBy: "\n\n:")
            let cleanJsonContent = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let jsonData = cleanJsonContent.data(using: .utf8) else {
                onProcessingError?(self, StreamingError.unknownContent)
                continue
            }
            
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(ResultType.self, from: jsonData)
                onReceiveContent?(self, object)
            } catch {
                if let decoded = try? decoder.decode(APIErrorResponse.self, from: jsonData) {
                    onProcessingError?(self, decoded)
                } else if index == jsonObjects.count - 1 {
                    previousChunkBuffer = "data: \(cleanJsonContent)"
                } else {
                    onProcessingError?(self, error)
                }
            }
        }
    }
    #endif

    private func prettyPrintJSON(_ jsonString: String) {
        if let data = jsonString.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
            print(prettyPrintedString)
        } else {
            print(jsonString)  // Fallback if pretty-printing fails
        }
    }
}
