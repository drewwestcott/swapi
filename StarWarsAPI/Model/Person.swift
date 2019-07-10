//
//  People.swift
//  StarWarsAPI
//
//  Created by Drew Westcott on 01/07/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import Foundation

struct Person: Codable {
    var name: String
    var gender: String
    var films: [String]
}
