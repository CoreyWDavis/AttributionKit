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

struct AttributionListView_Previews: PreviewProvider {
    static var previews: some View {
        AttributionListView(model: [
            AttributionModel(name: "My App", license: "My License")
        ])
    }
}
