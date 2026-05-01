//
//  ResultView.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import SwiftUI

struct ResultView: View {

    @ObservedObject var vm: FalconeViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            AppHeader()

            VStack(spacing: 24) {
                Spacer()

                if vm.isLoading {
                    ProgressView("Searching the galaxy...")
                        .font(.headline)
                } else if let result = vm.result {

                    switch result.status {
                    case .success:
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)

                        Text("Success!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Text("Falcone found on")
                            .foregroundColor(.secondary)

                        Text(result.planetName ?? "Unknown")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)

                    case .notFound:
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)

                        Text("Mission Failed")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)

                        Text("Falcone was not found")
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                        Text("Time Taken: \(vm.totalTime) hours")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.indigo.opacity(0.08))
                    .cornerRadius(10)

                } else {
                    Text("No result available")
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button { vm.reset(); dismiss() } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Start Again")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}
