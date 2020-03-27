//
//  ContentView.swift
//  SwiftUIAPIForUICollectionView
//
//  Created by Zihan Qi on 3/24/20.
//  Copyright © 2020 Zihan Qi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("a")
            Text("b")
        }
    .frame(width: 250, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
