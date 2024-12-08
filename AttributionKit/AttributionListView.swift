//
//  AttributionListView.swift
//  AttributionKit
//
//  Created by Corey Davis on 7/29/23.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct AttributionListView: View {
    var model: [AttributionModel]
    
    public init(model: [AttributionModel] = AttributionModel.make()) {
        self.model = model
    }
    
    public var body: some View {
        List {
            ForEach(model, id: \.name) { app in
                NavigationLink(destination: AttributionDetailView(model: app),
                               label: { Text(app.name) })
            }
        }
    }
}

#Preview {
    let models = [
        AttributionModel(name: "Dependency 1", license: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        AttributionModel(name: "Dependency 2", license: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        AttributionModel(name: "Dependency 3", license: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
    ]
    NavigationView {
        AttributionListView(model: models)
    }
}
