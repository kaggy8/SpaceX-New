//
//  Launch.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 24.08.2022.
//

struct Launch: Decodable {
    let name: String
    let dateUnix: Int
    let success: Bool
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateUnix = "date_unix"
        case success
        case id
    }
}
