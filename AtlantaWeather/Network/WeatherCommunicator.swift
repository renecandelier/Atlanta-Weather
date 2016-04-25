//
//  WeatherCommunicator.swift
//  AtlantaWeather
//
//  Created by Rene Candelier on 4/23/16.
//  Copyright © 2016 CNN. All rights reserved.
//

import UIKit

import Foundation

struct WeatherInfo {
    var description: String?
    var high: Double?
    var low: Double?
    var humidity: Double?
    var speed: Double?
    var pressure: Double?
    
    init (description: String, high: Double?, low: Double?, humidity: Double?, speed: Double?, pressure: Double?) {
        self.description = description
        self.high = high
        self.low = low
        self.humidity = humidity
        self.speed = speed
        self.pressure = pressure
    }
}

class WeatherCommunicator {
    
    // MARK: Properties
    static let apiKey = "83452db1aa36efe97ea7280f4de81d6c"
    static let city = "atlanta,ga"
    
    class func getDailyForcast(completion: (weatherDetail: [WeatherInfo]) -> Void) {
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(city)&mode=json&cnt=5&units=imperial&APPID=\(apiKey)"
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        var dailyForcast = [WeatherInfo]()
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            var highTemp: Double? = nil
            var lowTemp: Double? = nil
            var description = ""
            var humidity: Double? = nil
            var speed: Double? = nil
            var pressure: Double? = nil
            if error == nil {
                do {
                    let weatherDict = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as! [String: AnyObject]
                    if let weatherDetails = weatherDict["list"] as? [[String: AnyObject]]  {
                        for weather in weatherDetails {
                            if let pressureDict = weather["pressure"] as? Double {
                                pressure = round(pressureDict)
                            }
                            if let humidityDict = weather["humidity"] as? Double {
                                humidity = round(humidityDict)
                            }
                            if let speedDict = weather["speed"] as? Double {
                                speed = round(speedDict)
                            }
                            if let temperatureDetails = weather["temp"] as? [String: AnyObject] {
                                if let max = temperatureDetails["max"] as? Double {
                                    highTemp = round(max)
                                }
                                if let low = temperatureDetails["min"] as? Double {
                                    lowTemp = round(low)
                                }
                            }
                            if let tempDetail = weather["weather"] as? [[String: AnyObject]] {
                                if tempDetail.count > 0 {
                                    if let weatherDescription = tempDetail[0]["main"] as? String {
                                        description = weatherDescription
                                    }
                                }
                            }
                            let weatherInfo = WeatherInfo(description: description, high: highTemp, low: lowTemp, humidity: humidity, speed: speed, pressure: pressure)
                            dailyForcast.append(weatherInfo)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(weatherDetail: dailyForcast)
            })
        }
        task.resume()
    }
    
    class func getCurrentForcast(completion: (weatherDetail: WeatherInfo) -> Void) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&mode=json&cnt=5&units=imperial&APPID=\(apiKey)"
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            var highTemp: Double? = nil
            var lowTemp: Double? = nil
            var description = ""
            var humidity: Double? = nil
            var speed: Double? = nil
            var pressure: Double? = nil
            if error == nil {
                do {
                    let weatherDict = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as! [String: AnyObject]
                    if let weatherInformation = weatherDict["main"] as? Dictionary<String, AnyObject>, let weatherDetails = weatherDict["weather"] as? [[String: AnyObject]], let windDict = weatherDict["wind"] as? Dictionary<String, AnyObject> {
                        if weatherDetails.count > 0 {
                            if let weatherDescription = weatherDetails[0]["main"] as? String {
                                description = weatherDescription
                            }
                        }
                        if let low = weatherInformation["temp_min"] as? Double, let max = weatherInformation["temp_max"] as? Double, let pressureDict = weatherInformation["pressure"] as? Double, let humidityDict = weatherInformation["humidity"] as? Double {
                            pressure = round(pressureDict)
                            humidity = round(humidityDict)
                            highTemp = round(max)
                            lowTemp = round(low)
                        }
                        if let windSpeed = windDict["speed"] as? Double {
                            speed = round(windSpeed)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            let weatherInfo = WeatherInfo(description: description, high: highTemp, low: lowTemp, humidity: humidity, speed: speed, pressure: pressure)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(weatherDetail: weatherInfo)
            })
        }
        task.resume()
    }
    
    
}

