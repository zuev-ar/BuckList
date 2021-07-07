//
//  MapView.swift
//  BuckList
//
//  Created by Arkasha Zuev on 07.07.2021.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
