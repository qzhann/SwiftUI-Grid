//
//  Helper.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/29/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

/// A wrapper struct that conforms to Hashable, with an Identifiable content.
struct HashableWrapper<Content>: Hashable where Content: Identifiable {
    
    let content: Content
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content.id)
    }
    
    static func == (lhs: HashableWrapper<Content>, rhs: HashableWrapper<Content>) -> Bool {
        return lhs.content.id == rhs.content.id
    }
}
