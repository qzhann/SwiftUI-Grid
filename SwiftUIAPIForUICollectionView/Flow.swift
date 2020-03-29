//
//  Flow.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

protocol CompositionalLayoutApplicable {
    var widthDimension: FlowLayoutDimension { get set }
    var heightDimension: FlowLayoutDimension { get set }
}

/// The SwiftUI API for UICollectionView.
struct Flow<Data, CellContent>: CompositionalLayoutApplicable where Data: RandomAccessCollection, Data.Element: Identifiable, CellContent: View {

    // MARK: Instance properties
    var data: Data  // FIXME: Need to find a way to make SwiftUI call updateUIView when the data changes. (@State simply won't compile)
                            // Consider using a wrapper class, who will emit changes once its data content willChange.
    var sections = [0]
    var cellContentProvider: (Data.Element) -> CellContent
    
    var widthDimension: FlowLayoutDimension
    var heightDimension: FlowLayoutDimension

    // MARK: Initializers

    /// Step 1 initializer.
        /// Usage:
        /// ```
        /// Flow(items) { item in
        ///     Text(item)
        /// }
        /// [.frame(width: .defaultWidth, height: .defaultHeight)]
        /// ```
    init(_ data: Data, widthDimension: FlowLayoutDimension = .defaultWidth, heightDimension: FlowLayoutDimension = .defaultHeight, @ViewBuilder cellContentProvider: @escaping (Data.Element) -> CellContent) {
        self.data = data
        self.widthDimension = widthDimension
        self.heightDimension = heightDimension
        self.cellContentProvider = cellContentProvider
    }
    
}


// MARK: - UIViewRepresentable

extension Flow: UIViewRepresentable {
    
    /// Responsible for storing the collection view diffable data source.
    class Coordinator: NSObject {
        var parent: Flow
        var cellWrapperControllers: [UIViewController] = []
        var dataSource: UICollectionViewDiffableDataSource<Int, HashableWrapper<Data.Element>>!
        
        init(_ parent: Flow) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates the UICollectionView and sets up the diffable data source.
    func makeUIView(context: Context) -> UICollectionView {
        // Creates the UICollectionView
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // FIXME: This should respect .background() modifier if it exists
        collectionView.backgroundColor = .systemBackground
        collectionView.register(WrapperCell<CellContent>.self, forCellWithReuseIdentifier: kWrapperCellReuseIdentifier)
        
        // Sets up the diffable data source and store in the coordinator.
        context.coordinator.dataSource = UICollectionViewDiffableDataSource<Int, HashableWrapper<Data.Element>>(collectionView: collectionView) { (collectionView, indexPath, dataWrapper) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWrapperCellReuseIdentifier, for: indexPath) as? WrapperCell<CellContent> else { fatalError("Could not dequeue cell") }
            // Sets the content by using the cell content provider on the current model data
            cell.setContent(self.cellContentProvider(dataWrapper.content))
            return cell
        }
        
        applyDataSourceSnapshot(context: context, animated: true)
        
        return collectionView
    }
        
    /// Apply diffable data source changes. Triggered by change in data (@State).
    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        applyDataSourceSnapshot(context: context, animated: true)
    }
    
    /// Creates a simple flow layout using the specified width and height dimensions for each cell.
    /// - Parameters:
    ///   - widthDimension: The width dimension for each cell.
    ///   - heightDimension: The height dimension for each cell.
    private func createLayout() -> UICollectionViewLayout {
        // Each item takes up the entire height in the group and its preferred width.
        let itemSize = NSCollectionLayoutSize(widthDimension: .equivalent(widthDimension), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Each group takes up the entire width in the section and its preferred height.
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .equivalent(heightDimension))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    /// Applies changes in data to the diffable data source.
    private func applyDataSourceSnapshot(context: Context, animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, HashableWrapper<Data.Element>>()
        snapshot.appendSections(sections)
        snapshot.appendItems(data.map { HashableWrapper(content: $0) })
        context.coordinator.dataSource.apply(snapshot, animatingDifferences: animated)
    }
}


