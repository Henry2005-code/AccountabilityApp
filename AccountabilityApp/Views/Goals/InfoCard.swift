//
//  InfoCard.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/15/24.
//


import SwiftUI

struct InfoCard: View {
    var label: String
    var value: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
