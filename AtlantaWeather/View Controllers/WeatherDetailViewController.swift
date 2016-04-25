//
//  WeatherDetailViewController.swift
//  AtlantaWeather
//
//  Created by Rene Candelier on 4/23/16.
//  Copyright © 2016 CNN. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    // MARK: - Properties
    var weatherDetails:WeatherInfo!
    var day = ""
    var date = ""
    
    // MARK: Outlets
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var tempDescriptionLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        weekdayLabel.text = day
        dateLabel.text = date
        if let description = weatherDetails.description {
            tempImageView.image = UIImage(named: "art_\(description.lowercaseString)")
            tempDescriptionLabel.text = description
        }
        highTempLabel.text = "\(Int(weatherDetails.high!))°"
        lowTempLabel.text = "\(Int(weatherDetails.low!))°"
        humidityLabel.text = "Humidity: \(Int(weatherDetails.humidity!)) %"
        pressureLabel.text = "Pressure: \(Int(weatherDetails.pressure!)) hPa"
        // TODO: - Add Wind Dirrection.
        windLabel.text = "Wind: \(Int(weatherDetails.speed!)) km/h"
    }

}
