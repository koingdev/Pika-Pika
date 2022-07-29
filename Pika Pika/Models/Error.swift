//
//  Error.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import Foundation

enum AuthError: Error, CustomStringConvertible {
    case invalidInput
    
    var description: String {
        switch self {
        case .invalidInput:
            return "The provided input is not valid."
        }
    }
}
