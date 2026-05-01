//
//  FalconeAPIProtocol.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

protocol FalconeAPIProtocol {
    func fetchPlanets() async throws -> [Planet]
    func fetchVehicles() async throws -> [Vehicle]
    func fetchToken() async throws -> String
    func findFalcone(token: String, planets: [String], vehicles: [String]) async throws -> FindResponse
}
