//
//  DataService.swift
//  StarWarsAPI
//
//  Created by Drew Westcott on 01/07/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import Foundation
import NotificationCenter

class DataService {

    static var shared = DataService()
    
    var people = [Person]()
    
    fileprivate func downloadAPIData(_ url: URL) -> String {
        if let data = try? Data(contentsOf: url) {
            if let results = self.parsePeople(json: data) {
                self.people += results.results
                return results.next
            }
        }
        return ""
    }
    
    func getPeople(url: String) -> ([Person],String) {
        var nextPage = ""
        if let url = URL(string: url) {
            nextPage = downloadAPIData(url)
        }
        return (people,nextPage)
    }
    
    func parsePeople(json: Data) -> People? {
        let decoder = JSONDecoder()
        
        if let jsonPeople = try? decoder.decode(People.self, from: json) {
            return jsonPeople
        } else {
            print("Unable to decode")
            return nil
        }
    }
}
