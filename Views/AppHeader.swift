//
//  AppHeader.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import SwiftUI

struct AppHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "airplane.departure")
                .font(.title2)
                .foregroundColor(.white)
            Text("Finding Falcone")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(Color.indigo)
    }
}
