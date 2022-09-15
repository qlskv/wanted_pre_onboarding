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
    var weather: Weather?
    var main: Main?
    var name: String?
    var nameList: [ String ] = []
    var temp: Double?
    var tempList: [ Double ] = []
    var temp_min: Double?
    var temp_minList: [ Double ] = []
    var temp_max: Double?
    var temp_maxList: [ Double ] = []
    var humidity: Double?
    var humidityList: [ Double ] = []
    var icon: String?
    var iconList: [ String ] = []
    var urllist: [ String ] = []
    var feels_like: Double?
    var feels_likeList: [ Double ] = []
    var pressure: Int?
    var pressureList: [ Int ] = []
    var speed: Double?
    var speedList: [ Double ] = []
    var des: String?
    var desList: [ String ] = []
    
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
                    self.icon = weatherResponse.weather.first?.icon
                    self.iconList.append(self.icon!)
                    self.des = weatherResponse.weather.first?.description
                    self.desList.append(self.des!)
                    self.getImage(self.iconList.count - 1)
                    self.temp = weatherResponse.main.temp
                    self.tempList.append(self.temp!)
                    self.temp_min = weatherResponse.main.temp_min
                    self.temp_minList.append(self.temp_min!)
                    self.temp_max = weatherResponse.main.temp_max
                    self.temp_maxList.append(self.temp_max!)
                    self.humidity = weatherResponse.main.humidity
                    self.humidityList.append(self.humidity!)
                    self.feels_like = weatherResponse.main.feels_like
                    self.feels_likeList.append(self.feels_like!)
                    self.pressure = weatherResponse.main.pressure
                    self.pressureList.append(self.pressure!)
                    self.speed = weatherResponse.wind.speed
                    self.speedList.append(self.speed!)
                    self.name = weatherResponse.name
                    self.nameList.append(self.name!)
                    
//                    print(self.nameList)
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(nameList.count)
        return countRow ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.name.text = nameList[indexPath.row]
        let stringTemp = self.tempList.map { String($0) }
        let stringHumi = self.humidityList.map { String($0) }
        cell.temp.text = stringTemp[indexPath.row]
        cell.humi.text = stringHumi[indexPath.row]

        DispatchQueue.main.async {
            if let url = URL(string: self.urllist[indexPath.row]) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    print(url)
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.icon.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        도시이름, 날씨 아이콘, 현재기온, 체감기온, 헌재습도, 최저기온, 최고기온, 기압, 풍속, 날씨설명
        setSelect(indexPath.row)
        self.performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
    
    func setSelect(_ index:Int) {
        UserDefaults.standard.set(nameList[index], forKey: "NAME")
        UserDefaults.standard.set(urllist[index], forKey: "IMAGE")
        UserDefaults.standard.set(tempList[index], forKey: "TEMP")
        //체감
        UserDefaults.standard.set(feels_likeList[index], forKey: "FEEL")
        UserDefaults.standard.set(humidityList[index], forKey: "HUMIDITY")
        //최저
        UserDefaults.standard.set(temp_minList[index], forKey: "TEMP_MIN")
        //최고
        UserDefaults.standard.set(temp_maxList[index], forKey: "TEMP_MAX")
        //기압
        UserDefaults.standard.set(pressureList[index], forKey: "PRESS")
        //풍속
        UserDefaults.standard.set(speedList[index], forKey: "SPEED")
        //날씨설명
        UserDefaults.standard.set(desList[index], forKey: "DES")
    }
    
    func getImage(_ index: Int) {

        let url = "https://openweathermap.org/img/wn/\(self.iconList[index] )@2x.png"
        urllist.append(url)
        print(urllist)

    }
    
}
