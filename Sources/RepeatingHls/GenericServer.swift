//
//  File.swift
//  
//
//  Created by Damiaan Dufaux on 14/08/2024.
//

import Foundation

struct GenericServer {
    let manifest: ManifestGenerator
    let files: [Data]    
    
    func get(path: String) throws -> Data {
        if path == "/manifest.m3u8" {
            return manifest.generate().data(using: .utf8)!
        } else if path.hasPrefix("/fileSequence") {
            let numberString = path.suffix(from: path.index(path.startIndex, offsetBy: 13)).prefix(1)
            guard let number = Int(numberString) else { throw InvalidNumber(number: numberString) }
            guard files.indices.contains(number) else { throw NotFound(path: path) }
            return files[number]
        }
        throw NotFound(path: path)
    }
    
    struct NotFound: Error {
        let path: String
    }
    
    struct InvalidNumber: Error {
        let number: Substring
    }
}
