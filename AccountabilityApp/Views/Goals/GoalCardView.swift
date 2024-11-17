//
//  GoalCardView.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/15/24.
//


import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    var body: some View {
        HStack {
            Circle()
                .fill(Color.yellow.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: goal.iconName)
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.headline)
                ProgressView(value: goal.completionPercentage, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                    .frame(height: 6)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(3)
                HStack {
                    Text("\(Int(goal.completionPercentage))% Complete")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(goal.daysLeft) days left")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 8)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
