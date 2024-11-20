//
//  ActionButtonsView.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/19/24.
//

import SwiftUI
struct ActionButtonsView: View {
    var completeGoal: () -> Void
    var deleteGoal: () -> Void
    var isComplete: Bool

    var body: some View {
        VStack(spacing: 16) {
            Button(action: completeGoal) {
                Text("Complete Goal")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isComplete)

            Button(action: deleteGoal) {
                Text("Delete Goal")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
