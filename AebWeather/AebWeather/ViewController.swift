//
//  ViewController.swift
//  AebWeather
//
//  Created by Владислав Николаев on 13.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    private var cities = ["Якутск", "Санкт-Петербург", "Москва"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lightBlue = UIColor.init(red: 47 / 255, green: 136 / 255, blue: 239 / 255, alpha: 1.0)
        
        self.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = lightBlue
        self.navigationItem.title = "Table"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = lightBlue
        self.navigationController?.navigationBar.backgroundColor = lightBlue
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = lightBlue
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.updateLayout(with: self.view.frame.size)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.cities.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = self.cities[indexPath.row]
        return cell
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
}

