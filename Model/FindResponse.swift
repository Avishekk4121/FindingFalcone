//
//  FindResponse.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

enum FindStatus: String, Codable {
    case success
    case notFound = "false"

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = FindStatus(rawValue: raw) ?? .notFound
    }
}

struct FindResponse: Codable {
    let planetName: String?
    let status: FindStatus
    let error: String?

    enum CodingKeys: String, CodingKey {
        case planetName = "planet_name"
        case status
        case error
    }
}
