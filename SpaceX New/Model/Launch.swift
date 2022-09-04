//
//  Launch.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 27.08.2022.
//

import Foundation

struct Launch: Codable {
    let docs: [Doc]?
    
    init(docs: [Doc]) {
        self.docs = docs
    }
    
    init?(launchesData: [String:  Any]) {
        docs = [Doc(infoData: launchesData)]
    }
    
    static func getLaunches(from value: Any) -> [Launch] {
        guard let docsData = value as? [String: Any] else { return [] }
        guard let launchesData = docsData["docs"] as? [[String: Any]] else { return [] }
        return launchesData.compactMap { Launch(launchesData: $0)}
    }
}

struct Doc: Codable, Hashable {
    let success: Bool?
    let name: String?
    let dateUnix: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case name
        case dateUnix = "date_unix"
    }
    
    init(success: Bool, name: String, dateUnix: Int) {
        self.success = success
        self.name = name
        self.dateUnix = dateUnix
    }
    
    init(infoData: [String: Any]) {
        success = infoData["success"] as? Bool
        name = infoData["name"] as? String
        dateUnix = infoData["date_unix"] as? Int
    }
    
    static func getInformation(from value: Any) -> [Doc] {
        guard let infoData = value as? [[String: Any]] else { return [] }
        return infoData.compactMap { Doc(infoData: $0) }
    }
}
