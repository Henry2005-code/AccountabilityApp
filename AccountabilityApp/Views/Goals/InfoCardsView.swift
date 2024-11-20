//
//  InfoCardsView.swift
//  AccountabilityApp
//
//  Created by Henry Fowobaje on 11/19/24.
//

import SwiftUI
struct InfoCardsView: View {
    var targetDate: String
    var streak: String

    var body: some View {
        HStack(spacing: 16) {
            InfoCard(label: "Target Date", value: targetDate)
            InfoCard(label: "Streak", value: streak)
        }
    }
}
