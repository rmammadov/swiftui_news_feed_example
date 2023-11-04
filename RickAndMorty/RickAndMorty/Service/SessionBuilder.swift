//
//  SessionBuilder.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import Foundation


struct SessionBuilder {
    static let MEMORY_CAPACITY = 30 * 1024 * 1024
    static let DISK_CAPACITY = 25 * 1024 * 1024
    
    static func build() -> URLSession {
        let cache = URLCache(memoryCapacity: MEMORY_CAPACITY, diskCapacity: DISK_CAPACITY, directory: nil)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        let session = URLSession(configuration: configuration)
        
        return session
    }
}
