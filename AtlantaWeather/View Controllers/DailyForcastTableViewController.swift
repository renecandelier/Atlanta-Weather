//
//  DailyForcastTableViewController.swift
//  AtlantaWeather
//
//  Created by Rene Candelier on 4/23/16.
//  Copyright © 2016 CNN. All rights reserved.
//

import UIKit

class DailyForcastTableViewController: UITableViewController {
    
    // MARK: - Properties
    var dailyForcast = [WeatherInfo]()
    let todaysDate = NSDate()
    let dateFormatter = NSDateFormatter()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Add refresh feature.
        // TODO: Handle connectivity issues.
        startActivityIndicator()
        WeatherCommunicator.getCurrentForcast { (weatherDetail) in
            self.indicator.stopAnimating()
            self.dailyForcast.append(weatherDetail)
            WeatherCommunicator.getDailyForcast() { (weatherDetail) -> Void in
                self.indicator.stopAnimating()
                self.dailyForcast += weatherDetail
                self.tableView.reloadData()
            }
        }
    }
    
    func startActivityIndicator(){
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.color = UIColor(red:0.12, green:0.66, blue:0.96, alpha:1.00)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func setDay(row: Int, format: String) -> String {
        let nextDay = NSTimeInterval(60 * 60 * 24 * row)
        let newDate = todaysDate.dateByAddingTimeInterval(nextDay)
        dateFormatter.dateFormat = format
        let dayOfWeek = dateFormatter.stringFromDate(newDate)
        return dayOfWeek
    }
    
}

extension DailyForcastTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForcast.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let weatherDetails = dailyForcast[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TopCell", forIndexPath: indexPath) as! TodayTableViewCell
            if let high = weatherDetails.high, let low = weatherDetails.low, let description = weatherDetails.description {
                cell.highLabel.text = "\(Int(high))°"
                cell.lowLabel.text = "\(Int(low))°"
                cell.iconImageView.image = UIImage(named: "art_\(description.lowercaseString)")
                cell.temperatureDetailLabel.text = description
                let today = NSDate()
                dateFormatter.dateFormat = "MMMM dd"
                let dateFormatted = dateFormatter.stringFromDate(today)
                cell.dayLabel.text = "Today, " + dateFormatted
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("BottomCell", forIndexPath: indexPath) as! NextDaysTableViewCell
            // Different Approach on Setting up the cell
            cell.setupForWeather(weatherDetails)
            if indexPath.row == 1 {
                cell.dayLabel.text = "Tomorrow"
            } else {
                cell.dayLabel.text = setDay(indexPath.row, format: "EEEE")
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 166
        } else {
            return 85
        }
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            let row = tableView.indexPathForSelectedRow!.row
            let upcoming = segue.destinationViewController as! WeatherDetailViewController
            upcoming.weatherDetails = dailyForcast[row]
            upcoming.date = setDay(row, format: "MMMM dd")
            if row == 0 || row == 1 {
                if row == 0 {
                    upcoming.day = "Today"
                } else {
                    upcoming.day = "Tomorrow"
                }
            } else {
                upcoming.day = setDay(row, format: "EEEE")
            }
        }
    }
}
