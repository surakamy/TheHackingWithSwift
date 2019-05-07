//
//  Petition.swift
//  Project7
//
//  Created by Dmytro Kholodov on 5/7/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import Foundation

enum PetitionCategory {
    case recent
    case top
}

func getSourceUrl(for category: PetitionCategory = .recent) -> URL? {
    let urlString: String

    switch category {
    case .recent:
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    case .top:
        // urlString "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    return URL(string: urlString)
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
