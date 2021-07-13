//
//  ContentView.swift
//  BuckList
//
//  Created by Arkasha Zuev on 06.07.2021.
//

import SwiftUI
import CoreData
import MapKit
import LocalAuthentication

struct CircleView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
    }
}

struct AddButtonView: View {
    var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingEditScreen: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.title = "Example location"
                    newLocation.coordinate = centerCoordinate
                    self.locations.append(newLocation)
                    self.selectedPlace = newLocation
                    self.showingEditScreen = true
                }, label: {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(.trailing)
                })
            }
        }
    }
}

struct UnlockButtonView: View {
    let delegate: UnlockButtonViewDelegate
    
    var body: some View {
        VStack {
            Button("Unlock Places") {
                delegate.authenticate()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

protocol UnlockButtonViewDelegate {
    func authenticate()
}

struct TypeAlert: Identifiable {
    var id: String { name }
    let name: String
}

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingAlert: TypeAlert?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingAlert: $showingAlert, annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                CircleView()
                
                AddButtonView(centerCoordinate: centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingEditScreen: $showingEditScreen)
                
            } else {
                UnlockButtonView(delegate: self)
            }
        }
        .alert(item: $showingAlert) { detail in
            if detail.name == "AuthenticationError" {
                return Alert(title: Text("Error"), message: Text("Authentication error"), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                })
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
}

extension ContentView: UnlockButtonViewDelegate {
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.showingAlert = TypeAlert(name: "AuthenticationError")
                    }
                }
            }
        } else {
            self.showingAlert = TypeAlert(name: "AuthenticationError")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
