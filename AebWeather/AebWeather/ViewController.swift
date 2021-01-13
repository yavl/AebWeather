//
//  ViewController.swift
//  AebWeather
//
//  Created by Владислав Николаев on 13.01.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let cities = ["Якутск", "Москва", "Санкт-Петербург"]
    let cityCoordinates: Dictionary<String, Coordinates> = [
        "Якутск": Coordinates(lat: "55.75396", lon: "37.620393"),
        "Москва": Coordinates(lat: "55.75396", lon: "37.620393"),
        "Санкт-Петербург": Coordinates(lat: "59.937500", lon: "30.308611")
    ]
    let refreshControl = UIRefreshControl()

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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
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
        cell.detailTextLabel?.text = "0°C"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    /// refresh() is called on pull to refresh
    @objc private func refresh(_ sender: AnyObject) {
        let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=55.75396&lon=37.620393")!
        var request = URLRequest(url: url)
        let apiKey = "962d550d-7cda-4fc1-94b8-1feb259a0be5"
        request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            if responseString != nil {
                DispatchQueue.main.async {
                    self.onResponseRetrieved(response: responseString!)
                    self.refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    /// called when weather data was retrieved
    private func onResponseRetrieved(response: String) {
        let data = response.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode(ResponseData.self, from: data)
            let factWeather = jsonData.fact
            
            for cell in tableView.visibleCells {
                cell.detailTextLabel?.text = String(factWeather.temp)
            }
        } catch {
            print(error)
        }
    }
}

