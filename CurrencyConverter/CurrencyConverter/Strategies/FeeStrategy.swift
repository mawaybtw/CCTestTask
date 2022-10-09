//
//  FeeStrategy.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Foundation

// MARK: - FeeStrategy
protocol FeeStrategy: AnyObject {
    func calculate(profile: Profile, amount: Double) -> Double
}

// MARK: - FeeDefaultStrategy

class FeeDefaultStrategy: FeeStrategy {
    func calculate(profile: Profile, amount: Double) -> Double {
        return amount * 0.07
    }
}

// MARK: - FeeAmountLessStrategy

class FeeAmountLessStrategy: FeeStrategy {
    func calculate(profile: Profile, amount: Double) -> Double {
        if amount <= 200.0 {
            return 0.0
        }
        return amount * 0.07
    }
}
