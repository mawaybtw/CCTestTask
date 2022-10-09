//
//  ExchangeResult.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Foundation

// MARK: - ExchangeResult

struct ExchangeResult: Codable {
    var currency: Currency
    var amount: String
}
