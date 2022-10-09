//
//  ProfileService.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Moya

// MARK: - ProfileService

enum ProfileService {
    case balances
}

extension ProfileService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.evp.lt/profile")!
    }
    
    var path: String {
        switch self {
        case .balances:
            return "/balances"
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
    
    var sampleData: Data {
        let jsonMock = """
{
   "balances":[
      {
         "amount":1000.00,
         "currency":"EUR"
      },
      {
         "amount":0.00,
         "currency":"USD"
      },
      {
         "amount":0.00,
         "currency":"JPY"
      }
   ],
   "exchangesCount":0
}
"""
        return jsonMock.data(using: .utf8)!
    }
}
