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
        let numbers = Array(0..<940)
        return numbers.map { TemporaryItem(text: "\($0)") }
    }
    
    static var simpleTestItems: [TemporaryItem] = [
        TemporaryItem(text: "1"),
        TemporaryItem(text: "2"),
        TemporaryItem(text: "3")
    ]
}

struct ContentView: View {
    var simpleTestItems: [TemporaryItem] = [TemporaryItem(text: "1")]
    var body: some View {
        Flow(TemporaryItem.testItems) { item in
            VStack {
                Text(item.text)
                //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding()
                .background(Color.yellow)
            }
        }
        .frame(width: .fractionalWidth(0.2), height: .fractionalWidth(0.2))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
