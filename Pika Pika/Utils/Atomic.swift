//
//  Atomic.swift
//  Pika Pika
//
//  Created by KoingDev on 31/7/22.
//

import Foundation

@propertyWrapper
class Atomic<Value> {
    private let queue = DispatchQueue(label: "atomic.queue",attributes: .concurrent)
    private var value: Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get {
            return queue.sync {
                return value
            }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                self.value = newValue
            }
        }
    }
    
    var projectedValue: Atomic<Value> {
        return self
    }
    
    func mutate(_ mutation: @escaping (inout Value) -> Void) {
        return queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            mutation(&self.value)
        }
    }
}
