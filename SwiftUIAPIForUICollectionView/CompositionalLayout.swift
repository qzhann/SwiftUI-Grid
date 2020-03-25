//
//  CompositionalLayout.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

// MARK: - Collection Section


/// A section in the Collection. Created because we are unable to extend Section from SwiftUI.
struct CollectionSection<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
}



/* FIXME: - NEXT STEP
 To build a UICollectionView, we need the layout dimensions, the data, and the id.
 
 **How are we going to get those data from its Content?**
 
 */












// MARK: - Collection Item

/// A wrapper around a collection cell, storing its width and height layout dimension information.
fileprivate struct CollectionItem<Content: View>: View {
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

// MARK: - Collection layout dimension

/// Describes the layout dimension of each cell in a Collection. Similar to NSCollectionLayoutDimension.
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
    
    /// Used by items that are not modified with collection layout frame modifier.
    fileprivate static var `default`: CollectionLayoutDimension {
        CollectionLayoutDimension()
    }
}

// MARK: - Collection layout frame modifier

fileprivate struct CollectionLayoutFrameModifier: ViewModifier {
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

extension View {
    
    /// A view modifier that specifies the layout dimensions in a Collection.
    /// - Parameters:
    ///   - width: The width dimension.
    ///   - height: The height dimension.
    func frame(width: CollectionLayoutDimension, height: CollectionLayoutDimension) -> some View {
        self.modifier(CollectionLayoutFrameModifier(width: width, height: height))
    }
}
