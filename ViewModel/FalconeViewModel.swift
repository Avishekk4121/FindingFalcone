//
//  FalconeViewModel.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import Foundation

@MainActor
final class FalconeViewModel: ObservableObject {

    static let destinationCount = 4
    @Published var planets: [Planet] = []
    @Published var vehicles: [Vehicle] = []
    @Published var destinations: [Destination] = Array(repeating: Destination(), count: 4)

    // MARK: - State

    @Published var result: FindResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let api: FalconeAPIProtocol

    init(api: FalconeAPIProtocol = APIService.shared) {
        self.api = api
    }

    // MARK: - Load Data

    func loadData() async {
        do {
            async let planetsResponse = api.fetchPlanets()
            async let vehiclesResponse = api.fetchVehicles()
            planets = try await planetsResponse
            vehicles = try await vehiclesResponse
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func availablePlanets(at index: Int) -> [Planet] {
        planets.filter { planet in
            !destinations.contains(where: { $0.planet?.name == planet.name }) ||
            destinations[index].planet?.name == planet.name
        }
    }

    func availableVehicles(for planet: Planet, at index: Int) -> [Vehicle] {
        vehicles.filter { vehicle in
            guard vehicle.maxDistance >= planet.distance else { return false }
            let totalUsed = destinations.filter { $0.vehicle?.name == vehicle.name }.count
            let selfUsed = destinations[index].vehicle?.name == vehicle.name ? 1 : 0
            return (totalUsed - selfUsed) < vehicle.totalCount
        }
    }

    // MARK: - Time Calculation and validation

    var totalTime: Int {
        destinations.reduce(0) { time, dest in
            guard let planet = dest.planet, let vehicle = dest.vehicle else { return time }
            return time + planet.distance / vehicle.speed
        }
    }

    var isSelectionValid: Bool {
        destinations.allSatisfy { $0.planet != nil && $0.vehicle != nil }
    }

    // MARK: - Find Falcone

    func findFalcone() async {
        guard isSelectionValid else { return }
        isLoading = true
        errorMessage = nil

        do {
            let token = try await api.fetchToken()
            let planetNames = destinations.compactMap { $0.planet?.name }
            let vehicleNames = destinations.compactMap { $0.vehicle?.name }
            result = try await api.findFalcone(token: token, planets: planetNames, vehicles: vehicleNames)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func reset() {
        destinations = Array(repeating: Destination(), count: Self.destinationCount)
        result = nil
        isLoading = false
        errorMessage = nil
    }
}
