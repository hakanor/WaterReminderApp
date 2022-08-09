//
//  DataService.swift
//  WaterTrackerApp
//
//  Created by Hakan Or on 9.08.2022.
//

import Foundation

class DataService {
    
    // MARK: - Properties
    let defaults = UserDefaults.standard
    
    var currentDay: Int {
        let now = Date()
        let day = Calendar.current.component(.day, from: now)
        
        return day
    }
    
    // MARK: - Life Cycle
    init() {
        let latestUpdateDay = getLatestUpdateDay()

        if latestUpdateDay != currentDay {
            defaults.set(0, forKey: "currentAmount")
        }
    }
    
    // MARK: - Functions
    func getCurrentAmount() -> Double {
        // içilen su miktarı
        let savedAmount = defaults.double(forKey: "currentAmount")
        return savedAmount
    }
    
    func getLatestUpdateDay() -> Int {
        // son su içilen gün
        let latestUpdateDay = defaults.integer(forKey: "latestUpdateDay")
        return latestUpdateDay
    }
    
    func addWater(amount: Double) {
        // en son içtiğin gün ve içilen su değerini arttırmak
        let currentAmount = getCurrentAmount()
        let newAmount = currentAmount + amount
        
        defaults.set(newAmount, forKey: "currentAmount")
        defaults.set(currentDay, forKey: "latestUpdateDay")
    }
}
