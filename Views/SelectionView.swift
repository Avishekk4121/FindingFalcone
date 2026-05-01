//
//  SelectionView.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import SwiftUI

struct SelectionView: View {

    @StateObject var vm = FalconeViewModel()
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeader()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        ForEach(0..<FalconeViewModel.destinationCount, id: \.self) { index in
                            DestinationCard(vm: vm, index: index)
                        }

                        // TOTAL TIME
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .foregroundColor(.indigo)
                            Text("Total Time: \(vm.totalTime) hours")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.indigo.opacity(0.08))
                        .cornerRadius(10)

                        // FIND BUTTON
                        Button {
                            Task {
                                await vm.findFalcone()
                                if vm.result != nil { navigate = true }
                            }
                        } label: {
                            HStack {
                                if vm.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: "magnifyingglass")
                                    Text("Find Falcone")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(vm.isSelectionValid ? Color.indigo : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!vm.isSelectionValid || vm.isLoading)

                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .task { await vm.loadData() }
            .navigationDestination(isPresented: $navigate) {
                ResultView(vm: vm)
            }
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
}

private struct DestinationCard: View {

    @ObservedObject var vm: FalconeViewModel
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Destination \(index + 1)")
                .font(.headline)

            // PLANET SELECTION
            Menu {
                ForEach(vm.availablePlanets(at: index)) { planet in
                    Button(planet.name) {
                        vm.destinations[index].planet = planet
                        vm.destinations[index].vehicle = nil
                    }
                }
            } label: {
                HStack {
                    Text(vm.destinations[index].planet?.name ?? "Select Planet")
                        .foregroundColor(vm.destinations[index].planet == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            // VEHICLE SELECTION
            if let selectedPlanet = vm.destinations[index].planet {

                Text("Select Vehicle")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ForEach(vm.availableVehicles(for: selectedPlanet, at: index)) { vehicle in
                    let isSelected = vm.destinations[index].vehicle?.id == vehicle.id
                    Button { vm.destinations[index].vehicle = vehicle } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(vehicle.name)
                                    .fontWeight(.medium)
                                Text("Speed: \(vehicle.speed)  |  Range: \(vehicle.maxDistance)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.indigo)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(isSelected ? Color.indigo.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
    }
}
