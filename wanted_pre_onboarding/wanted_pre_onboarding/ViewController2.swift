//
//  ViewController2.swift
//  wanted_pre_onboarding
//
//  Created by AirM2 on 2022/09/13.
//

import UIKit
//        도시이름, 날씨 아이콘, 현재기온, 체감기온, 헌재습도, 최저기온, 최고기온, 기압, 풍속, 날씨설명
class ViewController2: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var press: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = UserDefaults.standard.string(forKey: "NAME")
        icon.text = UserDefaults.standard.string(forKey: "IMAGE")
        temp.text = UserDefaults.standard.string(forKey: "TEMP")
        feelsLike.text = UserDefaults.standard.string(forKey: "FEEL")
        humidity.text = UserDefaults.standard.string(forKey: "HUMIDITY")
        press.text = UserDefaults.standard.string(forKey: "PRESS")
        minTemp.text = UserDefaults.standard.string(forKey: "TEMP_MIN")
        maxTemp.text = UserDefaults.standard.string(forKey: "TEMP_MAX")
        speed.text = UserDefaults.standard.string(forKey: "SPEED")
        des.text = UserDefaults.standard.string(forKey: "DES")
        
    }

}
