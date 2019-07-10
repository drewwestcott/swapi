//
//  ViewController.swift
//  StarWarsAPI
//
//  Created by Drew Westcott on 01/07/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var personTableView: UITableView!
    @IBOutlet var filmSegmentedControl: UISegmentedControl!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var people = [Person]()
    var selectedPeople = [Person]()
    let apiUrl = "https://swapi.co/api/people"
    var nextRequest = "" {
        didSet {
            if !nextRequest.isEmpty {
                requestData(url: nextRequest)
            }
        }
    }

    func requestData(url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.anitmateIndicator()
            }
            
            let dataService = DataService.shared
            (self.people, self.nextRequest) = dataService.getPeople(url: url)
            DispatchQueue.main.async {
                self.refreshPersonList()
            }
        }
    }
    
    func anitmateIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personTableView.delegate = self
        personTableView.dataSource = self
        navigationItem.title = "Star Wars"
        
        anitmateIndicator()
        
        requestData(url: apiUrl)
    }
    
    func refreshPersonList() {
        switch filmSegmentedControl.selectedSegmentIndex {
        case 0:
            displayCharactersIn(film: "https://swapi.co/api/films/1/")
        case 1:
            displayCharactersIn(film: "https://swapi.co/api/films/2/")
        default:
            displayCharactersIn(film: "https://swapi.co/api/films/3/")
        }
    }
    
    @IBAction func filmTapped(_ sender: Any) {
        print(filmSegmentedControl.selectedSegmentIndex)
        refreshPersonList()
    }
    
    func displayCharactersIn(film: String) {
        selectedPeople.removeAll(keepingCapacity: true)
        for person in people {
            if person.films.contains(film) {
                selectedPeople.append(person)
            }
        }
        personTableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
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
