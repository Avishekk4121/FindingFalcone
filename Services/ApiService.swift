//
//  APIService.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

import Foundation

final class APIService: FalconeAPIProtocol {

    static let shared = APIService()

    private let baseURL = "https://findfalcone.geektrust.com"

    private init() {}

    // MARK: - Fetch Planets

    func fetchPlanets() async throws -> [Planet] {
        let url = try makeURL(path: "/planets")
        let (data, response) = try await URLSession.shared.data(from: url)
        try validate(response: response)
        return try JSONDecoder().decode([Planet].self, from: data)
    }

    // MARK: - Fetch Vehicles

    func fetchVehicles() async throws -> [Vehicle] {
        let url = try makeURL(path: "/vehicles")
        let (data, response) = try await URLSession.shared.data(from: url)
        try validate(response: response)
        return try JSONDecoder().decode([Vehicle].self, from: data)
    }

    // MARK: - Fetch Token

    func fetchToken() async throws -> String {
        let url = try makeURL(path: "/token")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)

        struct TokenResponse: Decodable { let token: String }
        return try JSONDecoder().decode(TokenResponse.self, from: data).token
    }

    // MARK: - Find Falcone

    func findFalcone(token: String, planets: [String], vehicles: [String]) async throws -> FindResponse {
        let url = try makeURL(path: "/find")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        struct FindRequest: Encodable {
            let token: String
            let planetNames: [String]
            let vehicleNames: [String]

            enum CodingKeys: String, CodingKey {
                case token
                case planetNames = "planet_names"
                case vehicleNames = "vehicle_names"
            }
        }

        request.httpBody = try JSONEncoder().encode(
            FindRequest(token: token, planetNames: planets, vehicleNames: vehicles)
        )

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return try JSONDecoder().decode(FindResponse.self, from: data)
    }

    // MARK: - Helpers

    private func makeURL(path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw APIError.invalidURL
        }
        return url
    }

    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.httpError(statusCode: -1)
        }
        guard 200...299 ~= http.statusCode else {
            throw APIError.httpError(statusCode: http.statusCode)
        }
    }
}
