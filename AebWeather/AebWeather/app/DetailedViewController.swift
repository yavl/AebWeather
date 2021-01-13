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
        
        let labelColor: UIColor
        if traitCollection.userInterfaceStyle == .light {
            labelColor = UIColor.darkGray
        } else {
            labelColor = UIColor.lightGray
        }
        
        let cityNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        cityNameLabel.textAlignment = NSTextAlignment.center
        cityNameLabel.text = String(cityName)
        cityNameLabel.textColor = labelColor
        cityNameLabel.font = cityNameLabel.font.withSize(24)
        cityNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scrollViewContainer.addArrangedSubview(cityNameLabel)
        
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.text = String(fact.temp) + "°C"
        tempLabel.textColor = labelColor
        tempLabel.font = tempLabel.font.withSize(72)
        tempLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        scrollViewContainer.addArrangedSubview(tempLabel)
        
        let conditionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        conditionLabel.textAlignment = NSTextAlignment.center
        conditionLabel.text = String(fact.condition)
        conditionLabel.textColor = labelColor
        conditionLabel.font = tempLabel.font.withSize(24)
        conditionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scrollViewContainer.addArrangedSubview(conditionLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.backgroundColor = UIColor.systemBackground

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = 10

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let redView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        view.backgroundColor = .red
        return view
    }()

    let blueView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = .blue
        return view
    }()

    let greenView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1200).isActive = true
        view.backgroundColor = .green
        return view
    }()
}
