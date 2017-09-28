//
//  DataService.swift
//  weatherApplication
//
//  Created by Hao on 9/28/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import Foundation
let notificationKey = Notification.Name.init("requestAPI")

class DataService {
    static let shared: DataService = DataService()
    let urlString = "https://api.apixu.com/v1/forecast.json?key=fea52b02813c4e4a870232445172709&q=hanoi&days=7"
    private var _weather: Weather?
    var weather: Weather? {
        get {
            if _weather == nil {
                requestData()
            }
            return _weather
        } set {
            _weather = newValue
        }
    }
    var forecastday : [ForecastDay] = []
    private var _hours: [Hour]?
    var hours: [Hour] {
        get {
            if _hours == nil {
                createArrayHourInDays()
            }
            return _hours ?? []
        }
        set {
            _hours = newValue
        }
    }
    func createArrayHourInDays() {
        if let timeCurrent = weather?.current.last_updated_epoch {
            _hours = weather?.forecast.forecastday[0].hour.filter {
                $0.time_epoch > timeCurrent
            }
        }
        for i in 0...23 {
            _hours?.append((weather?.forecast.forecastday[1].hour[i])!)
        }
        
    }
    func requestData() {
        guard let url = URL(string: urlString) else { return }
        let requestURL = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else { return }
            guard data != nil else { return }
            DispatchQueue.main.async {
                self._weather = try? JSONDecoder().decode(Weather.self, from: data!)
                NotificationCenter.default.post(name: notificationKey, object: nil )
            }
        }
        task.resume()
    }
}
