//
//  ArrayX.swift
//  Pika Pika
//
//  Created by KoingDev on 31/7/22.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        0 <= index && index < count ? self[index] : nil
    }
}
