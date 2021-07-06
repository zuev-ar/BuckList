//
//  ContentView.swift
//  BuckList
//
//  Created by Arkasha Zuev on 06.07.2021.
//

import SwiftUI
import CoreData

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    static func > (lhs: User, rhs: User) -> Bool {
        lhs.lastName > rhs.lastName
    }
}

struct ContentView: View {
    let values = [1, 5, 3, 6, 2 ,9].sorted()
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ].sorted()
    
    var body: some View {
        List(values, id: \.self) {
            Text(String($0))
        }
        List(users) { user in
            Text(" \(user.firstName), \(user.lastName)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
