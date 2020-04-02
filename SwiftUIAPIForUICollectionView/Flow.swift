//
//  Flow.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 4/1/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

/// The SwiftUI API for UICollectionView.
struct Flow<Data, CellContent>: View where Data : RandomAccessCollection, Data.Element : Identifiable, CellContent : View {
    
    var content: CollectionViewRepresentableView<Data, CellContent>
    
    var body: some View {
        content
    }
    
    /// Initializes a `Flow` using a cell content provider that returns a `View`.
    /// - Parameters:
    ///   - data: The collection of identified data that is used to generate the cell content.
    ///   - cellContentProvider: Supplies a  `View` That will be used to generate the cell content using `FlowLayoutDimension.defaultWidth` and `FlowLayoutDimension.defaultHeight`.
    internal init(_ data: Data, @ViewBuilder cellContentProvider: @escaping (Data.Element) -> CellContent) {
        self.content = CollectionViewRepresentableView(data, widthDimension: .defaultWidth, heightDimension: .defaultHeight, cellContentProvider: cellContentProvider)
    }
    
}

extension Flow where CellContent: FlowLayoutApplicableView {
    
    /// Initializes a `Flow` using a cell conten provider that returns a `FlowLayoutApplicableView`, which specifies the width and height layout dimensions.
    /// - Parameters:
    ///   - data: The collection of identified data that is used to generate the cell content.
    ///   - cellContentProvider: Supplies a  `FlowLayoutApplicableView` That will be used to generate the cell content using its specified width and height dimensions.
    internal init(_ data: Data, @ViewBuilder cellContentProvider: @escaping (Data.Element) -> CellContent) {
        let sampleCellContent = cellContentProvider(data.first!)
        let widthDimension = sampleCellContent.widthDimension
        let heightDimension = sampleCellContent.heightDimension
        self.content = CollectionViewRepresentableView(data, widthDimension: widthDimension, heightDimension: heightDimension, cellContentProvider: cellContentProvider)
    }
}

// MARK: - Flow Item

protocol FlowLayoutApplicableView: View {
    var widthDimension: FlowLayoutDimension { get set }
    var heightDimension: FlowLayoutDimension { get set }
}

/// A wrapper around a collection cell, storing its width and height layout dimension information.
struct FlowItem<Content>: FlowLayoutApplicableView where Content : View {
    let content: Content
    var widthDimension: FlowLayoutDimension
    var heightDimension: FlowLayoutDimension

    init(content: Content, width: FlowLayoutDimension, height: FlowLayoutDimension) {
        self.content = content
        self.widthDimension = width
        self.heightDimension = height
    }

    var body: some View {
        content
    }
}

extension View {

    /// A view modifier that specifies its width and height `FlowLayoutDimension`s. The dimensions will be applied if the modified `View` is wrapped inside of a `Flow`.
    /// - Parameters:
    ///   - width: The width dimension.
    ///   - height: The height dimension.
    func frame(width: FlowLayoutDimension, height: FlowLayoutDimension) -> some FlowLayoutApplicableView {
        FlowItem(content: self, width: width, height: height)
    }
}

extension Flow {
    /// A view modifier that specifies the layout dimensions for each item a `Flow`.
    /// - Parameters:
    ///   - width: The width dimension.
    ///   - height: The height dimension.
    func frame(width: FlowLayoutDimension, height: FlowLayoutDimension) -> some View {
        CollectionViewRepresentableView(self.content.data, widthDimension: width, heightDimension: height, cellContentProvider: self.content.cellContentProvider)
    }
}
