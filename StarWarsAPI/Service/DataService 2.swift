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
    
    fileprivate func downloadAPIData(_ url: URL) {
            if let data = try? Data(contentsOf: url) {
                if let results = self.parsePeople(json: data) {
                    self.people += results.results
                    if !results.next.isEmpty {
                        if let nextPage = URL(string: results.next) {
                            self.downloadAPIData(nextPage)
                        }
                    }
                }
            }
    }
    
    func getPeople(url: String) -> [Person] {
        
        //TODO: Need to pass in a URL in case next parameter is not null
        
        if let url = URL(string: url) {
            downloadAPIData(url)
        }
        
        return people
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
