//
//  TestFlow.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/26/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

/// The SwiftUI API for UICollectionView.
struct TestFlow<Data>: View where Data: RandomAccessCollection, Data.Element: Identifiable {
    
    // MARK: Instance properties
    
    private var data: Data!  // FIXME: This may cause problems because we may have triggered @State to emit changes during initialization, thus calling updateUIView too early.
    var sections = [0]
    
    
    // MARK: - Initializers
    
    init<CellContent>(_ data: Data, @ViewBuilder cellContent: @escaping (Data.Element) -> CellContent) where Data: RandomAccessCollection, CellContent: View, Data.Element: Identifiable {
        self.data = data
    }
    
    var body: some View {
        Text("Hello")
    }
}
