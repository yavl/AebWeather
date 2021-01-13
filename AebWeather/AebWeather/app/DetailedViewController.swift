//
//  DetailedView.swift
//  AebWeather
//
//  Created by Владислав Николаев on 14.01.2021.
//

import UIKit

class DetailedViewController: UIViewController {
    let fact: Fact
    let cityName: String
    
    init(fact: Fact, cityName: String) {
        self.fact = fact
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        self.view.addSubview(stackView)
        self.view.backgroundColor = UIColor.systemBackground
        
        let cityNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        cityNameLabel.center = CGPoint(x: 160, y: 80)
        cityNameLabel.textAlignment = NSTextAlignment.center
        cityNameLabel.text = String(cityName)
        cityNameLabel.textColor = UIColor.darkGray
        cityNameLabel.font = cityNameLabel.font.withSize(24)
        stackView.addSubview(cityNameLabel)
        
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        tempLabel.center = CGPoint(x: 160, y: 150)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.text = String(fact.temp) + "°C"
        tempLabel.textColor = UIColor.darkGray
        tempLabel.font = tempLabel.font.withSize(72)
        stackView.addSubview(tempLabel)
        
        let conditionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        conditionLabel.center = CGPoint(x: 160, y: 220)
        conditionLabel.textAlignment = NSTextAlignment.center
        conditionLabel.text = String(fact.condition)
        conditionLabel.textColor = UIColor.darkGray
        conditionLabel.font = tempLabel.font.withSize(24)
        stackView.addSubview(conditionLabel)
    }
}
