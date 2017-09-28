//
//  ViewController.swift
//  weatherApplication
//
//  Created by Hao on 9/28/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource ,UITableViewDelegate,UITableViewDataSource {
   
    
    //MARK: - Properties
    var weather: Weather? {
        willSet{
            self.weather = DataService.shared.weather
        }
        didSet{
            self.nameLocal.text = DataService.shared.weather?.location.name
            self.conditionLabel.text = DataService.shared.weather?.current.condition.text
            self.dateLabel.text = DataService.shared.weather?.forecast.forecastday[0].date_epoch.dayWeek()
            guard let currentTemp = DataService.shared.weather?.current.temp_c else {return}
            self.currentTempLabel.text = "\(currentTemp) ℃"
            guard let minTemp = DataService.shared.weather?.forecast.forecastday[0].day.mintemp_c else {return}
            self.minTempLabel.text = "\(minTemp)"
            guard let maxTemp = DataService.shared.weather?.forecast.forecastday[0].day.maxtemp_c else {return}
            self.maxTempLabel.text = "\(maxTemp)"
        }
    }
    @IBOutlet weak var nameLocal: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var photoImage: UIImageView!
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: notificationKey, object: nil)
        DataService.shared.requestData()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func updateData() {
        self.weather = DataService.shared.weather
        myCollectionView.reloadData()
        myTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    //MARK: Use CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = DataService.shared.weather?.forecast.forecastday[0].hour.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        if indexPath.row == 0 {
            cell.hourLabel.text = "Now"
            guard let temp = DataService.shared.weather?.current.temp_c else { fatalError("Error") }
            cell.tempOfHourLabel.text? = "\(temp)"
            guard let  icon = DataService.shared.weather?.current.condition.icon else { fatalError("Error") }
            cell.conditionOfHourLabel.downloadedFrom(urlString: "https:\(icon)")
        }
        else {
            cell.hourLabel.text = DataService.shared.hours[indexPath.row - 1].time_epoch.gethour()
            let temp = DataService.shared.hours[indexPath.row - 1].temp_c
            cell.tempOfHourLabel.text = "\(temp)"
            let icon =  DataService.shared.hours[indexPath.row - 1].condition.icon
            cell.conditionOfHourLabel.downloadedFrom(urlString: "https:\(icon)")
            
        }
        return cell
    }
    
    //MARK: Use TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = DataService.shared.weather?.forecast.forecastday.count else { return 0 }
        return count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CustomTableViewCell
        cell.dateOfWeekLabel.text = DataService.shared.weather?.forecast.forecastday[indexPath.row + 1].date_epoch.dayWeek()
        
        guard let maxTemp = DataService.shared.weather?.forecast.forecastday[indexPath.row + 1].day.maxtemp_c else {
            fatalError("")
        }
        cell.tempMaxInDayLabel.text = "\(maxTemp)"
        guard let minTemp = DataService.shared.weather?.forecast.forecastday[indexPath.row + 1].day.mintemp_c else {
            fatalError("")
        }
        cell.tempMinInDayLabel.text = "\(minTemp)"
        
        guard let  icon = DataService.shared.weather?.forecast.forecastday[indexPath.row + 1].day.condition.icon else { fatalError("") }
        cell.conditionOfDay.downloadedFrom(urlString: "https:\(icon)")
        
        return cell
    }
  
    
}
