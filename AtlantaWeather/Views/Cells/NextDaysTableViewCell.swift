//
//  NextDaysTableViewCell.swift
//  AtlantaWeather
//
//  Created by Rene Candelier on 4/23/16.
//  Copyright © 2016 CNN. All rights reserved.
//

import UIKit

class NextDaysTableViewCell: UITableViewCell {
    
    // MARK : Properties
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureDetailLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    func setupForWeather(weather: WeatherInfo) {
        highLabel.text = "\(Int(weather.high!))°"
        lowLabel.text = "\(Int(weather.low!))°"
        iconImageView.image = UIImage(named: "ic_\(weather.description!.lowercaseString)")
        temperatureDetailLabel.text = weather.description!
    }
    
}
