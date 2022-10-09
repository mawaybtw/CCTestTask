//
//  ExchangeService.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Moya

// MARK: - ExchangeService

enum ExchangeService {
    case calculate(amount: Double, from: Currency, to: Currency)
}

extension ExchangeService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.evp.lt/currency/commercial")!
    }
    
    var path: String {
        switch self {
        case .calculate(let amount, let fromCurrency, let toCurrency):
            return "/exchange/\(amount)-\(fromCurrency)/\(toCurrency)/latest"
        }
    }
    
    var method: Method {
        .get
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        nil
    }
}
