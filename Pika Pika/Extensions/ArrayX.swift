//
//  ArrayX.swift
//  Pika Pika
//
//  Created by KoingDev on 31/7/22.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        exists(index: index) ? self[index] : nil
    }
    
    func exists(index: Index) -> Bool {
        0 <= index && index < count
    }
}
