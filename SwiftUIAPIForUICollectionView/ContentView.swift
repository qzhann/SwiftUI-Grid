//
//  ContentView.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

struct TemporaryItem: Identifiable {
    var id = UUID()
    var text: String
    
    static var testItems: [TemporaryItem] {
        let numbers = Array(0..<94)
        return numbers.map { TemporaryItem(text: "\($0)") }
    }
    
    static var simpleTestItems: [TemporaryItem] = [TemporaryItem(text: "1")]
}

struct ContentView: View {
    var body: some View {
        Flow(TemporaryItem.testItems) { item in
            Text(item.text)
        }
        .frame(height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
