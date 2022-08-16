//
//  DiscoveryGrid.swift
//  orion
//
//  Created by Alberto Delle Donne on 15/08/22.
//

import SwiftUI

struct DiscoveryGrid: View {
    let spacing: CGFloat = 10
    var body: some View {
        HStack(alignment: .top,spacing: spacing) {
            LazyVStack(spacing: spacing) {
                ForEach(0 ..< 30) { _ in
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.blue)
                        .frame(height: CGFloat.random(in: 70 ... 200))
                }
            }
            LazyVStack(spacing: spacing) {
                ForEach(0 ..< 30) { _ in
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.blue)
                        .frame(height: CGFloat.random(in: 70 ... 200))
                }
            }
        }
    }
}

struct DiscoveryGrid_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
}
