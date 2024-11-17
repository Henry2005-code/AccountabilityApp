//
//  ActivityItem.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/15/24.
//


import SwiftUI

struct ActivityItem: View {
    var label: String
    var description: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .padding(6)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
