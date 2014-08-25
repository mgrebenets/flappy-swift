//
//  RingBuffer.swift
//  FlappySwift
//
//  Created by Grebenets, Maksym on 8/25/14.
//  Copyright (c) 2014 News Corp. All rights reserved.
//

class RingBuffer<T> {
    var items = [T]()
    private var startIndex = 0

    var count: Int {
        return items.count
    }

    func reset() {
        startIndex = items.startIndex
    }

    func add(item: T) {
        items.append(item)
    }

    subscript(i: Int) -> T {
        return items[(startIndex + i) % items.count]
    }

    func shift() {
        if items.isEmpty { return }
        startIndex = (startIndex + 1) % items.count
    }
}

extension RingBuffer {
    var first: T? {
        return items.isEmpty ? nil : self[0]
    }
    var last: T? {
        return items.isEmpty ? nil : self[items.count - 1]
    }
}
