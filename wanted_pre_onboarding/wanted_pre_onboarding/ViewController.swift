//
//  ViewController.swift
//  wanted_pre_onboarding
//
//  Created by AirM2 on 2022/09/12.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    
    var countRow: Int!
    
    let defaultQueue = DispatchQueue.global()  // 디폴트 글로벌큐
    let mainQueue = DispatchQueue.main
    var weather: Weather?
    var main: Main?
    var name: String?
    var nameList: [ String ] = []
    var temp: Double?
    var tempList: [ Double ] = []
    var humidity: Double?
    var humidityList: [ Double ] = []
    
    var weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        fetchData()
    }
    
    func fetchData() {
        defaultQueue.async(qos: .userInitiated) {
            // data fetch
            WeatherService().getWeather { result in
                switch result {
                case .success(let weatherResponse):
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.temp = weatherResponse.main.temp
                    self.tempList.append(self.temp!)
                    self.humidity = weatherResponse.main.humidity
                    self.humidityList.append(self.humidity!)
                    self.name = weatherResponse.name
                    self.nameList.append(self.name!)
                    
                    print(self.nameList)
                case .failure(_ ):
                    print("error")
                }
                DispatchQueue.main.async {
                    self.countRow = self.nameList.count
                    self.myTable.reloadData()
                }
            }
        }
    }
}

private var apiKey: String {
    get {
        // 생성한 .plist 파일 경로 불러오기
        guard let filePath = Bundle.main.path(forResource: "api_key", ofType: "plist") else {
            fatalError("Couldn't find file 'api_key.plist'.")
        }
        
        // .plist를 딕셔너리로 받아오기
        let plist = NSDictionary(contentsOfFile: filePath)
        
        // 딕셔너리에서 값 찾기
        guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
            fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'api_key.plist'.")
        }
        return value
    }
}
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(nameList.count)
        return countRow ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.name.text = nameList[indexPath.row]
        let stringTemp = self.tempList.map { String($0) }
        let stringHumi = self.humidityList.map { String($0) }
        cell.temp.text = stringTemp[indexPath.row]
        cell.humi.text = stringHumi[indexPath.row]

        
        return cell
    }
}
