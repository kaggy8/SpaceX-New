//
//  Rocket.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 07.08.2022.
//

struct Rocket: Decodable {
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let firstFlight: String
    let flickrImages: [String]
    let name: String
    let country: String
    let costPerLaunch: Int
    let firstStage: FirstStage
    let secondStage: SecondStage
    let payloadWeights: [PayloadWeights]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case height
        case diameter
        case mass
        case firstFlight = "first_flight"
        case flickrImages = "flickr_images"
        case name
        case country
        case costPerLaunch = "cost_per_launch"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case payloadWeights = "payload_weights"
        case id
    }
}

struct Height: Decodable {
    let meters: Double
    let feet: Double
}

struct Diameter: Decodable {
    let meters: Double
    let feet: Double
}

struct Mass: Decodable {
    let kg: Int
    let lb: Int
}

struct FirstStage: Decodable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
    
    enum CodingKeys: String, CodingKey {
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSec = "burn_time_sec"
    }
}

struct SecondStage: Decodable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Int?
    
    enum CodingKeys: String, CodingKey {
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSec = "burn_time_sec"
    }
}

struct PayloadWeights: Decodable {
    let kg: Int
    let lb: Int
}
