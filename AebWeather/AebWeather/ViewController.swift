//
//  ViewController.swift
//  AebWeather
//
//  Created by Владислав Николаев on 13.01.2021.
//

import UIKit

struct AebWeather {
    static var apiKey = "962d550d-7cda-4fc1-94b8-1feb259a0be5"
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    var cities = ["Якутск", "Москва", "Санкт-Петербург"]
    let cityCoordinates: Dictionary<String, Coordinates> = [
        "Якутск": Coordinates(lat: "62.035454", lon: "129.675476"),
        "Москва": Coordinates(lat: "55.75396", lon: "37.620393"),
        "Санкт-Петербург": Coordinates(lat: "59.937500", lon: "30.308611")
    ]
    let refreshControl = UIRefreshControl()
    var actualWeather: Dictionary<String, ResponseData> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AebWeather"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Настройки", style: .plain, target: self, action: #selector(onRightButtonBarClicked))
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        let y = refreshControl.frame.maxY + tableView.adjustedContentInset.top
        tableView.setContentOffset(CGPoint(x: 0, y: -y), animated: true)
        self.view.addSubview(tableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.updateLayout(with: self.view.frame.size)
        refreshWeatherData()
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
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    // called when UITableViewCell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (actualWeather[cities[indexPath.row]] != nil) {
            let detailedViewController = DetailedViewController(responseData: actualWeather[cities[indexPath.row]]!, cityName: cities[indexPath.row])
            self.navigationController?.pushViewController(detailedViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            showAlert(title: "Ошибка", message: "Потяните, чтобы обновить данные о погоде")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    /// onRefresh() is called on pull to refresh
    @objc private func onRefresh(_ sender: AnyObject) {
        refreshWeatherData()
    }
    
    private func refreshWeatherData() {
        for (city, coordinates) in cityCoordinates {
            let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(coordinates.lat)&lon=\(coordinates.lon)")!
            var request = URLRequest(url: url)
            request.addValue(AebWeather.apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                    print("error", error ?? "Unknown error")
                    self.showAlert(title: "Ошибка", message: error.debugDescription)
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {
                    print("response = \(response)")
                    self.showAlert(title: "Ошибка", message: "Ошибка HTTP: " + String(response.statusCode))
                    return
                }

                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    DispatchQueue.main.async {
                        self.onResponseRetrieved(response: responseString!, cityName: city)
                        self.refreshControl.endRefreshing()
                    }
                }
            }
            task.resume()
        }
    }
    
    /// called when weather data was retrieved
    private func onResponseRetrieved(response: String, cityName: String) {
        let data = response.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode(ResponseData.self, from: data)
            actualWeather[cityName] = jsonData
            for cell in tableView.visibleCells {
                if cell.textLabel?.text == cityName {
                    cell.detailTextLabel?.text = String(jsonData.fact.temp)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func onRightButtonBarClicked() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

