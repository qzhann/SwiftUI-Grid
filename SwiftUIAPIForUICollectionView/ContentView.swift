//
//  ContentView.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI


var identifiedItems: [TemporaryItem] {
    let numbers = Array(0..<940)
    return numbers.map { TemporaryItem(text: "\($0)") }
}

struct ContentView: View {
    var body: some View {
        Flow(identifiedItems) { item in
            Text(item.text)
                .frame(width: .fractionalWidth(0.2), height: .fractionalWidth(0.2))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
