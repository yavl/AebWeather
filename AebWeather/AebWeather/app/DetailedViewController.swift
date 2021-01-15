//
//  DetailedView.swift
//  AebWeather
//
//  Created by Владислав Николаев on 14.01.2021.
//

import UIKit

let windDirection = [
    "nw": "сз",
    "n": "с",
    "ne": "св",
    "e": "в",
    "se": "юв",
    "s": "ю",
    "sw": "юз",
    "w": "ю",
    "c": "штиль",
]

let weatherCondition = [
    "clear": "ясно",
    "partly-cloudy": "малооблачно",
    "cloudy": "облачно с прояснениями",
    "overcast": "пасмурно",
    "drizzle": "морось",
    "light-rain": "небольшой дождь",
    "rain": "дождь",
    "moderate-rain": "умеренно сильный дождь",
    "heavy-rain": "сильный дождь",
    "continuous-heavy-rain": "длительный сильный дождь",
    "showers": "ливень",
    "wet-snow": "дождь со снегом",
    "light-snow": "небольшой снег",
    "snow": "снег",
    "snow-showers": "снегопад",
    "hail": "град",
    "thunderstorm": "гроза",
    "thunderstorm-with-rain": "дождь с грозой",
    "thunderstorm-with-hail": "гроза с градом",
]

class DetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let responseData: ResponseData
    let cityName: String
    let forecastIndex: Int
    
    init(responseData: ResponseData, cityName: String, forecastIndex: Int = -1) {
        self.responseData = responseData
        self.cityName = cityName
        self.forecastIndex = forecastIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.backgroundColor = UIColor.systemBackground
        
        let scrollViewContainer = UIStackView()
        scrollViewContainer.axis = .vertical
        scrollViewContainer.spacing = 10
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewContainer)
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let temp: String
        let condition: String
        let humidity: String
        let wind_dir: String
        let wind_speed: String
        let pressure_mm: String
        if forecastIndex < 0 {
            temp = String(responseData.fact.temp)
            condition = weatherCondition[String(responseData.fact.condition)]!
            humidity = String(responseData.fact.humidity)
            wind_dir = windDirection[String(responseData.fact.wind_dir)]!
            wind_speed = String(responseData.fact.wind_speed)
            pressure_mm = String(responseData.fact.pressure_mm)
        } else {
            temp = String(responseData.forecasts[forecastIndex].parts.day.temp_avg)
            condition = weatherCondition[String(responseData.forecasts[forecastIndex].parts.day.condition)]!
            humidity = String(responseData.forecasts[forecastIndex].parts.day.humidity)
            wind_dir = windDirection[String(responseData.forecasts[forecastIndex].parts.day.wind_dir)]!
            wind_speed = String(responseData.forecasts[forecastIndex].parts.day.wind_speed)
            pressure_mm = String(responseData.forecasts[forecastIndex].parts.day.pressure_mm)
        }
        
        addWeatherLabel(text: String(cityName), size: 24, scrollViewContainer: scrollViewContainer)
        addWeatherLabel(text: temp + "°C", size: 72, heightAnchor: 80, scrollViewContainer: scrollViewContainer)
        addWeatherLabel(text: condition, size: 24, scrollViewContainer: scrollViewContainer)
        addWeatherLabel(text: "Влажность: " + humidity + "%", size: 24, scrollViewContainer: scrollViewContainer)
        addWeatherLabel(text: "Ветер: " + wind_dir + ", " + wind_speed + " м/c", size: 24, scrollViewContainer: scrollViewContainer)
        addWeatherLabel(text: "Давление: " + pressure_mm + " мм рт.ст", size: 24, scrollViewContainer: scrollViewContainer)
        
        if (forecastIndex < 0) {
            scrollView.refreshControl = UIRefreshControl()
            tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            scrollViewContainer.addArrangedSubview(tableView)
            self.updateLayout(with: self.view.frame.size)
        }
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func addWeatherLabel(text: String, size: CGFloat, heightAnchor: CGFloat = 50, scrollViewContainer: UIStackView) {
        let labelColor: UIColor
        if traitCollection.userInterfaceStyle == .light {
            labelColor = UIColor.darkGray
        } else {
            labelColor = UIColor.lightGray
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        label.textAlignment = NSTextAlignment.center
        label.text = text
        label.textColor = labelColor
        label.font = label.font.withSize(size)
        label.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        scrollViewContainer.addArrangedSubview(label)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.responseData.forecasts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day: String
        switch indexPath.row {
        case 0:
            day = "Сегодня днём"
        case 1:
            day = "Завтра"
        case 2:
            day = "Послезавтра"
        default:
            day = responseData.forecasts[indexPath.row].date
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = day
        cell.detailTextLabel?.text = String(responseData.forecasts[indexPath.row].parts.day.temp_avg)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    // called when UITableViewCell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedViewController = DetailedViewController(responseData: responseData, cityName: cityName, forecastIndex: indexPath.row)
        self.navigationController?.present(detailedViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
