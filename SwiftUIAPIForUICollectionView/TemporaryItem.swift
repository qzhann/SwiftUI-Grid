//
//  TemporaryItem.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 4/6/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import Foundation

struct TemporaryItem: Identifiable {
    var id = UUID()
    var text: String
    
    static var testItems: [TemporaryItem] {
        let numbers = Array(0..<940)
        return numbers.map { TemporaryItem(text: "\($0)") }
    }
    
    static var simpleTestItems: [TemporaryItem] = [
        TemporaryItem(text: "1"),
        TemporaryItem(text: "2"),
        TemporaryItem(text: "3")
    ]
}
