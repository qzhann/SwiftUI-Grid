//
//  CompositionalLayout.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

// MARK: - Flow Section

/// A section in the Flow. Created because we are unable to extend Section from SwiftUI.
struct FlowSection<Content: View>: View {
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

// MARK: - Flow layout dimension

/// Describes the layout dimension of each cell in a Flow. Similar to NSCollectionLayoutDimension.
struct FlowLayoutDimension {
    var dimension: CGFloat
    
    var isExact: Bool
    var isFractionalWidth: Bool
    var isFractionalHeight: Bool
    
    init(dimension: CGFloat, isExact: Bool, isFractionalWidth: Bool, isFractionalHeight: Bool) {
        self.dimension = dimension
        self.isExact = isExact
        self.isFractionalWidth = isFractionalWidth
        self.isFractionalHeight = isFractionalHeight
        
        assert(isExact || isFractionalWidth || isFractionalHeight, "FlowLayoutDimension initialization failure. Dimension either needs to be fractional or exact.")
    }
    
    static var kDefaultEstimateHeight: CGFloat = 44.0
    
    static func exactly(_ exactDimension: CGFloat) -> FlowLayoutDimension {
        FlowLayoutDimension(dimension: exactDimension, isExact: true, isFractionalWidth: false, isFractionalHeight: false)
    }
    
    static func fractionalWidth(_ fraction: CGFloat) -> FlowLayoutDimension {
        FlowLayoutDimension(dimension: fraction, isExact: false, isFractionalWidth: true, isFractionalHeight: false)
    }
    
    static func fractionalHeight(_ fraction: CGFloat) -> FlowLayoutDimension {
        FlowLayoutDimension(dimension: fraction, isExact: false, isFractionalWidth: false, isFractionalHeight: true)
    }
    
    /// Used by items that are not modified with collection layout frame modifier.
    static var defaultWidth: FlowLayoutDimension {
        .fractionalWidth(1.0)
    }
    
    /// Used by items that are not modified with collection layout frame modifier.
    static var defaultHeight: FlowLayoutDimension {
        .exactly(kDefaultEstimateHeight)
    }
    
}

// MARK: FlowLayoutDimension to NSCollectionLayoutDimension

extension NSCollectionLayoutDimension {
    
    /// Creates a NSCollectionLayoutDimension from a FlowLayoutDimension.
    static func equivalent(_ flowLayoutDimension: FlowLayoutDimension) -> NSCollectionLayoutDimension {
        if flowLayoutDimension.isExact {
            return .absolute(flowLayoutDimension.dimension)
        } else if flowLayoutDimension.isFractionalWidth {
            return .fractionalWidth(flowLayoutDimension.dimension)
        } else if flowLayoutDimension.isFractionalHeight {
            return .fractionalHeight(flowLayoutDimension.dimension)
        } else {
            fatalError("Layout dimension conversion incorrect.")
        }
    }
}
