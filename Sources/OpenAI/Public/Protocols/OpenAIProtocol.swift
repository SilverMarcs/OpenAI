//
//  OpenAIProvider.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

public protocol OpenAIProtocol {
    /**
     This function sends an images query to the OpenAI API and retrieves generated images in response. The Images Generation API enables you to create various images or graphics using OpenAI's powerful deep learning models.

     Example:
     ```
     let query = ImagesQuery(prompt: "White cat with heterochromia sitting on the kitchen table", n: 1, size: ImagesQuery.Size._1024)
     openAI.images(query: query) { result in
       //Handle result here
     }
     ```
     
     - Parameters:
       - query: An `ImagesQuery` object containing the input parameters for the API request. This includes the query parameters such as the text prompt, image size, and other settings.
       - completion: A closure which receives the result when the API request finishes. The closure's parameter, `Result<ImagesResult, Error>`, will contain either the `ImagesResult` object with the generated images, or an error if the request failed.
    **/
    func images(query: ImagesQuery, completion: @escaping (Result<ImagesResult, Error>) -> Void)
    
    /**
     This function sends a chat query to the OpenAI API and retrieves chat conversation responses. The Chat API enables you to build chatbots or conversational applications using OpenAI's powerful natural language models, like GPT-3.
     
     Example:
     ```
     let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: "user", content: "who are you")])
     openAI.chats(query: query) { result in
       //Handle response here
     }
     ```

     - Parameters:
       - query: A `ChatQuery` object containing the input parameters for the API request. This includes the lists of message objects for the conversation, the model to be used, and other settings.
       - completion: A closure which receives the result when the API request finishes. The closure's parameter, `Result<ChatResult, Error>`, will contain either the `ChatResult` object with the model's response to the conversation, or an error if the request failed.
    **/
    func chats(query: ChatQuery, completion: @escaping (Result<ChatResult, Error>) -> Void)
    
    /**
     This function sends a chat query to the OpenAI API and retrieves chat stream conversation responses. The Chat API enables you to build chatbots or conversational applications using OpenAI's powerful natural language models, like GPT-3. The result is returned by chunks.
     
     Example:
     ```
     let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: "user", content: "who are you")])
     openAI.chats(query: query) { result in
       //Handle response here
     }
     ```

     - Parameters:
       - query: A `ChatQuery` object containing the input parameters for the API request. This includes the lists of message objects for the conversation, the model to be used, and other settings.
       - onResult: A closure which receives the result when the API request finishes. The closure's parameter, `Result<ChatStreamResult, Error>`, will contain either the `ChatStreamResult` object with the model's response to the conversation, or an error if the request failed.
       - completion: A closure that is being called when all chunks are delivered or uncrecoverable error occured
    **/
    func chatsStream(query: ChatQuery, control: StreamControl, onResult: @escaping (Result<ChatStreamResult, Error>) -> Void, completion: ((Error?) -> Void)?)
    
    /**
     This function sends a chat query to the OpenAI API and retrieves chat stream conversation responses. 
     
     The Chat API enables you to use custom url to start a chat query.
    **/
    func chatsStream(query: ChatQuery, url: URL, control: StreamControl, onResult: @escaping (Result<ChatStreamResult, Error>) -> Void, completion: ((Error?) -> Void)?)
    
    /**
     This function sends a model query to the OpenAI API and retrieves a model instance, providing owner information. The Models API in this usage enables you to gather detailed information on the model in question, like GPT-3.
     
     Example:
     ```
     let query = ModelQuery(model: .gpt3_5Turbo)
     openAI.model(query: query) { result in
       //Handle response here
     }
     ```

     - Parameters:
       - query: A `ModelQuery` object containing the input parameters for the API request, which is only the model to be queried.
       - completion: A closure which receives the result when the API request finishes. The closure's parameter, `Result<ModelResult, Error>`, will contain either the `ModelResult` object with more information about the model, or an error if the request failed.
    **/
    func model(query: ModelQuery, completion: @escaping (Result<ModelResult, Error>) -> Void)
    
    /**
     This function sends a models query to the OpenAI API and retrieves a list of models. The Models API in this usage enables you to list all the available models.
     
     Example:
     ```
     openAI.models() { result in
       //Handle response here
     }
     ```

     - Parameters:
       - completion: A closure which receives the result when the API request finishes. The closure's parameter, `Result<ModelsResult, Error>`, will contain either the `ModelsResult` object with the list of model types, or an error if the request failed.
    **/
    func models(completion: @escaping (Result<ModelsResult, Error>) -> Void)
    
    /**
     This function sends an `AudioSpeechQuery` to the OpenAI API to create audio speech from text using a specific voice and format.
     
     Example:
     ```
     let query = AudioSpeechQuery(model: .tts_1, input: "Hello, world!", voice: .alloy, responseFormat: .mp3, speed: 1.0)
     openAI.audioCreateSpeech(query: query) { result in
        // Handle response here
     }
     ```
     
     - Parameters:
       - query: An `AudioSpeechQuery` object containing the parameters for the API request. This includes the Text-to-Speech model to be used, input text, voice to be used for generating the audio, the desired audio format, and the speed of the generated audio.
       - completion: A closure which receives the result. The closure's parameter, `Result<AudioSpeechResult, Error>`, will either contain the `AudioSpeechResult` object with the audio data or an error if the request failed.
     */
    func audioCreateSpeech(query: AudioSpeechQuery, completion: @escaping (Result<AudioSpeechResult, Error>) -> Void)
    
    /**
    Transcribes audio data using OpenAI's audio transcription API and completes the operation asynchronously.

    - Parameter query: The `AudioTranscriptionQuery` instance, containing the information required for the transcription request.
    - Parameter completion: The completion handler to be executed upon completion of the transcription request.
                          Returns a `Result` of type `AudioTranscriptionResult` if successful, or an `Error` if an error occurs.
     **/
    func audioTranscriptions(query: AudioTranscriptionQuery, completion: @escaping (Result<AudioTranscriptionResult, Error>) -> Void)
}
