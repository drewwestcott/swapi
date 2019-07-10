//
//  ViewController.swift
//  StarWarsAPI
//
//  Created by Drew Westcott on 01/07/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filmSegmentedControl: UISegmentedControl!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var people = [Person]()
    var selectedPeople = [Person]()
    let API_URL = "https://swapi.co/api/people"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Star Wars"
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async {
           let dataService = DataService.shared
            self.people = dataService.getPeople(url: self.API_URL)
            DispatchQueue.main.async {
                self.displayCharactersIn(film: "https://swapi.co/api/films/1/")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func filmChanged(_ sender: Any) {
        switch filmSegmentedControl.selectedSegmentIndex {
        case 0:
            displayCharactersIn(film: "https://swapi.co/api/films/1/")
        case 1:
            displayCharactersIn(film: "https://swapi.co/api/films/2/")
        default:
            displayCharactersIn(film: "https://swapi.co/api/films/3/")
        }
    }
    
    func displayCharactersIn(film: String) {
        selectedPeople.removeAll(keepingCapacity: true)
        for person in people {
            if person.films.contains(film) {
                selectedPeople.append(person)
            }
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let person = selectedPeople[indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.gender
        return cell
    }
}
