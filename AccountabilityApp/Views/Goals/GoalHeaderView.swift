//
//  GoalHeaderView.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/19/24.
//

import SwiftUI
struct GoalHeaderView: View {
    var title: String
    var iconName: String
    var completionPercentage: Double

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.purple)

            HStack(spacing: 16) {
                Image(systemName: iconName)
                    .foregroundColor(.yellow)
                    .font(.system(size: 32))

                VStack(alignment: .leading) {
                    Text("\(Int(completionPercentage))%")
                        .font(.title2)
                        .bold()
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            ProgressView(value: completionPercentage, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.black))
                .frame(height: 8)
                .padding(.horizontal)
        }
    }
}
