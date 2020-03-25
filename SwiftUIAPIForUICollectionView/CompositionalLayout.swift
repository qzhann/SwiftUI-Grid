//
//  CompositionalLayout.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

fileprivate struct CustomFrameModifier: ViewModifier {
    var widthDimension: CollectionLayoutDimension
    var heightDimension: CollectionLayoutDimension
    
    init(width: CollectionLayoutDimension, height: CollectionLayoutDimension) {
        self.widthDimension = width
        self.heightDimension = height
    }
    
    func body(content: Content) -> some View {
        CollectionItem(content: content, width: widthDimension, height: heightDimension)
    }
}

/// Describes the layout dimension of each cell in a Flow. Similar to NSCollectionLayoutDimension.
struct CollectionLayoutDimension {
    var exactDimension: CGFloat?
    var fraction: CGFloat?
    
    private init(exactDimension: CGFloat? = nil, fraction: CGFloat? = nil) {
        self.exactDimension = exactDimension
        self.fraction = fraction
    }
    
    static func exactly(_ exactDimension: CGFloat) -> CollectionLayoutDimension {
        CollectionLayoutDimension(exactDimension: exactDimension)
    }
    
    static func fractional(_ fraction: CGFloat) -> CollectionLayoutDimension {
        CollectionLayoutDimension(fraction: fraction)
    }
}

struct CollectionItem<Content: View>: View {
    let content: Content
    let widthDimension: CollectionLayoutDimension
    let heightDimension: CollectionLayoutDimension
    
    init(content: Content, width: CollectionLayoutDimension, height: CollectionLayoutDimension) {
        self.content = content
        self.widthDimension = width
        self.heightDimension = height
    }
    
    var body: some View {
        content
    }
}

extension View {
    
    /// A view modifier that specifies the layout dimensions in a Flow.
    /// - Parameters:
    ///   - width: The width dimension.
    ///   - height: The height dimension.
    func frame(width: CollectionLayoutDimension, height: CollectionLayoutDimension) -> some View {
        self.modifier(CustomFrameModifier(width: width, height: height))
    }
}
