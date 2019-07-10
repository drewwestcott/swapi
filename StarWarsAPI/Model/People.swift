//
//  People.swift
//  StarWarsAPI
//
//  Created by Drew Westcott on 01/07/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import Foundation

struct People: Codable {
    var count: Int
    var next: String
    var results: [Person]
}
