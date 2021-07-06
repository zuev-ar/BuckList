//
//  ContentView.swift
//  BuckList
//
//  Created by Arkasha Zuev on 06.07.2021.
//

import SwiftUI
import CoreData

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FaildView: View {
    var body: some View {
        Text("Faild!")
    }
}

struct ContentView: View {
    
    enum LoadingState {
        case loading, success, faild
    }
    
    var loadingState = LoadingState.faild
    
    var body: some View {
        Group {
            if loadingState == .loading {
                LoadingView()
            } else if loadingState == .success {
                SuccessView()
            } else if loadingState == .faild {
                FaildView()
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
