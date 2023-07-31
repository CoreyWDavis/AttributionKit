//
//  AttributionDetailView.swift
//  AttributionKit
//
//  Created by Corey Davis on 7/29/23.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct AttributionDetailView: View {
    var model: AttributionModel
    
    public init(model: AttributionModel) {
        self.model = model
    }
    
#if os(iOS)
    public var body: some View {
        ScrollView {
            makeDetailStack()
                .navigationBarTitle("\(model.name)", displayMode: .large)
        }
    }
#elseif os(macOS)
    public var body: some View {
        ScrollView {
            makeDetailStack()
                .navigationTitle(model.name)
        }
    }
#endif
    
    private func makeDetailStack() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(model.license)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct AttributionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AttributionDetailView(model: AttributionModel(name: "My App", license: "My License"))
        }
    }
}
