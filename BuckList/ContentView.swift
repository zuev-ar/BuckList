//
//  ContentView.swift
//  BuckList
//
//  Created by Arkasha Zuev on 06.07.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
