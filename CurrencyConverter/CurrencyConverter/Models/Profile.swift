//
//  Profile.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Foundation

// MARK: - CurrencyBalance

class CurrencyBalance: Codable {
    
    var currency: Currency
    var amount: Double
    
    init(currency: Currency, amount: Double) {
        self.currency = currency
        self.amount = amount
    }
}

// MARK: - Profile

class Profile: Codable {
    
    var balances: [CurrencyBalance]
    var exchangesCount: Int
    
    init(balances: [CurrencyBalance], exchangesCount: Int) {
        self.balances = balances
        self.exchangesCount = exchangesCount
    }
}
