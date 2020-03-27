//
//  Flow.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

/// The SwiftUI API for UICollectionView.
struct Flow<Data> where Data: RandomAccessCollection, Data.Element: Identifiable {

    // MARK: Instance properties

    private var data: Data  // FIXME: Need to find a way to make SwiftUI call updateUIView when the data changes. (@State simply won't compile)
                            // Consider using a wrapper class, who will emit changes once its data content willChange.
    var sections = [0]


    // MARK: Initializers

    /// Step 0 initializer.
        /// Usage:
        /// ```
        /// Flow(items, cellWidth: .fractional(0.5), cellHeight: .exactly(44)) { item in
        ///     Text(item)
        /// }
        /// ```
    //    init<Data, CellContent>(_ data: Data, @ViewBuilder cellContent: @escaping (Data.Element) -> CellContent) where Data: RandomAccessCollection, CellContent: View, Data.Element: Identifiable {
    //        self.content = EmptyView() as! Content
    //    }


    /// Step 1 initializer.
        /// Usage:
        /// ```
        /// Flow(items) { item in
        ///     Text(item)
        /// }
        /// [.frame(width: .defaultWidth, height: .defaultHeight)]
        /// ```
    init<CellContent>(_ data: Data, @ViewBuilder cellContent: @escaping (Data.Element) -> CellContent) where Data: RandomAccessCollection, CellContent: View, Data.Element: Identifiable {
        self.data = data
    }
    
}


// MARK: - UIViewRepresentable

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

extension Flow: UIViewRepresentable {
    
    /// Responsible for storing the collection view diffable data source.
    class Coordinator: NSObject {
        var parent: Flow
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
        collectionView.backgroundColor = .black
        collectionView.register(TemporaryCell.self, forCellWithReuseIdentifier: TemporaryCell.reuseIdentifier)
        
        // Sets up the diffable data source and store in the coordinator.
        context.coordinator.dataSource = UICollectionViewDiffableDataSource<Int, HashableWrapper<Data.Element>>(collectionView: collectionView) { (collectionView, indexPath, wrapper) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemporaryCell.reuseIdentifier, for: indexPath) as? TemporaryCell else { fatalError("Could not create new cell") }
            cell.configure(using: "\(wrapper.content.id)")
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
    private func createLayout(widthDimension: FlowLayoutDimension = .defaultWidth, heightDimension: FlowLayoutDimension = .defaultHeight) -> UICollectionViewLayout {
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


