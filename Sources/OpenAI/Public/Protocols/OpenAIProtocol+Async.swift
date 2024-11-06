//
//  OpenAIProtocol+Async.swift
//
//
//  Created by Maxime Maheo on 10/02/2023.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
public extension OpenAIProtocol {
    func images(
        query: ImagesQuery
    ) async throws -> ImagesResult {
        try await withCheckedThrowingContinuation { continuation in
            images(query: query) { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    func chats(
        query: ChatQuery
    ) async throws -> ChatResult {
        try await withCheckedThrowingContinuation { continuation in
            chats(query: query) { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    func chatsStream(
        query: ChatQuery,
        control: StreamControl = StreamControl()
    ) -> AsyncThrowingStream<ChatStreamResult, Error> {
        return AsyncThrowingStream { continuation in
            chatsStream(query: query, control: control)  { result in
                continuation.yield(with: result)
            } completion: { error in
                continuation.finish(throwing: error)
            }
            
            continuation.onTermination = { @Sendable termination in
                control.cancel()
            }
        }
    }
    
    func chatsStream(
        query: ChatQuery,
        url: URL,
        control: StreamControl = StreamControl()
    ) -> AsyncThrowingStream<ChatStreamResult, Error> {
        return AsyncThrowingStream { continuation in
            chatsStream(query: query, url: url, control: control)  { result in
                continuation.yield(with: result)
            } completion: { error in
                continuation.finish(throwing: error)
            }
            
            continuation.onTermination = { @Sendable termination in
                control.cancel()
            }
        }
    }
    
    func model(
        query: ModelQuery
    ) async throws -> ModelResult {
        try await withCheckedThrowingContinuation { continuation in
            model(query: query) { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    func models() async throws -> ModelsResult {
        try await withCheckedThrowingContinuation { continuation in
            models() { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    func audioCreateSpeech(
        query: AudioSpeechQuery
    ) async throws -> AudioSpeechResult {
        try await withCheckedThrowingContinuation { continuation in
            audioCreateSpeech(query: query) { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    func audioTranscriptions(
        query: AudioTranscriptionQuery
    ) async throws -> AudioTranscriptionResult {
        try await withCheckedThrowingContinuation { continuation in
            audioTranscriptions(query: query) { result in
                switch result {
                case let .success(success):
                    return continuation.resume(returning: success)
                case let .failure(failure):
                    return continuation.resume(throwing: failure)
                }
            }
        }
    }
}
