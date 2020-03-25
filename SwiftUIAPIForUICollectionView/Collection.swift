//
//  Collection.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

/// The SwiftUI API for UICollectionView.
struct Collection<Content: View>: UIViewRepresentable {
    let content: Content
//    let collectionViewLayout: UICollectionViewCompositionalLayout!
    
    
//    init<Data, ID, CellContent>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder cellContent: () -> Content) {
//        self.content = content()
//    }
    
    func makeUIView(context: Context) -> UICollectionView {
        return UICollectionView()
    }
    
    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        //
    }
}

//struct Flow_Previews: PreviewProvider {
//    static var previews: some View {
//        Collection {
//            VStack {
//                Text("a")
//                Text("b")
//            }
//        }
//    }
//}
