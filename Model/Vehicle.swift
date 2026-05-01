//
//  Vehicle.swift
//  FindingFalcone
//
//  Created by Abhishek Pandey on 01/05/26.
//

struct Vehicle: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let totalCount: Int
    let maxDistance: Int
    let speed: Int

    enum CodingKeys: String, CodingKey {
        case name, speed
        case totalCount = "total_no"
        case maxDistance = "max_distance"
    }
}
