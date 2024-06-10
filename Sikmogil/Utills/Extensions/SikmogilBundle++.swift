//
//  SikmogilBundle++.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/4/24.
//

import Foundation

// API KEY 또는 URL을 Plist 로 관리하기 위한 Extension
extension Bundle{
    
    // OpenWeatherMap API Key
    var baseURL: String{
        guard let filePath = Bundle.main.path(forResource: "SikmogilPlist", ofType: "plist") else{
            fatalError("Couldn't find file 'TodayWeatherAPI.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "BASE_URL") as? String else{
            fatalError("Couldn't find key 'API_KEY' in 'TodayWeatherAPI.plist'.")
        }
        
        return value
    }
    
}
