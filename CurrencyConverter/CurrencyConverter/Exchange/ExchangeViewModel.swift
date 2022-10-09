//
//  ExchangeViewModel.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import Foundation
import Moya

// MARK: - ExchangeViewModelInput

protocol ExchangeViewModelInput: AnyObject {
    var output: ExchangeViewModelOutput? { get set }
    func requestBalances()
    func onAmountUpdate(_ amount: Double)
    func onCurrencySelected(_ currency: Currency, type: ExchangeFieldType)
    func onSubmit()
}

// MARK: - ExchangeViewModelOutput

protocol ExchangeViewModelOutput: AnyObject {
    func onError(_ message: String)
    func onUpdateBalances(_ balances: [CurrencyBalance])
    func onUpdateAmount(_ amount: Double, type: ExchangeFieldType)
    func onSubmit(from: CurrencyBalance, to: CurrencyBalance, fee: Double)
}

// MARK: - ExchangeViewModel

final class ExchangeViewModel {
    
    // MARK: - Private properties
    
    private let profileProvider = MoyaProvider<ProfileService>(stubClosure: MoyaProvider.delayedStub(1.0))
    private let exchangeProvider = MoyaProvider<ExchangeService>()
    private let feeStrategy: FeeStrategy = FeeDefaultStrategy()
    
    private var profile: Profile? = nil
    private var amount: Double = 0.0
    private var sellCurrency: Currency = .EUR
    private var receiveCurrency: Currency = .EUR
    private var exchangeResult: ExchangeResult? = nil
    
    // MARK: - Public properties
    
    weak var output: ExchangeViewModelOutput?
    
    // MARK: - Private methods
    
    private func isExchangeValid() -> Bool {
        guard amount > 0, sellCurrency != receiveCurrency else { return false }
        guard let profile = profile else { return false }
        let balance = profile.balances.first { [weak self] balance in
            guard let self = self else { return false }
            return balance.currency == self.sellCurrency
        }
        guard let sellBalance = balance?.amount else { return false }
        let fee = feeStrategy.calculate(profile: profile, amount: amount)
        guard amount + fee <= sellBalance else { return false }
        return true
    }
    
    private func requestCalculation() {
        guard isExchangeValid() else { return }
        exchangeProvider.request(.calculate(amount: amount, from: sellCurrency, to: receiveCurrency)) { [weak self] result in
            switch result {
            case .success(let response):
                guard let exchangeResult = try? response.map(ExchangeResult.self) else {
                    self?.output?.onError("Parse error")
                    return
                }
                let amount = Double(exchangeResult.amount) ?? 0.0
                self?.exchangeResult = exchangeResult
                self?.output?.onUpdateAmount(amount, type: .receive)
            case .failure(let error):
                self?.output?.onError(error.errorDescription ?? "Unknown error")
            }
        }
    }
}

// MARK: - ExchangeViewModelInput

extension ExchangeViewModel: ExchangeViewModelInput {
    func requestBalances() {
        profileProvider.request(.balances) { [weak self] result in
            switch result {
            case .success(let response):
                guard let profile = try? response.map(Profile.self) else {
                    self?.output?.onError("Parse error")
                    return
                }
                self?.profile = profile
                self?.output?.onUpdateBalances(profile.balances)
            case .failure(let error):
                self?.output?.onError(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func onAmountUpdate(_ amount: Double) {
        self.amount = amount
        output?.onUpdateAmount(0.0, type: .receive)
        requestCalculation()
    }
    
    func onCurrencySelected(_ currency: Currency, type: ExchangeFieldType) {
        switch type {
        case .sell:
            sellCurrency = currency
        case .receive:
            receiveCurrency = currency
        }
        requestCalculation()
    }
    
    func onSubmit() {
        guard isExchangeValid() else { return }
        guard
            let profile = profile,
            let exchangeResult = exchangeResult
        else {
            return
        }
        guard
            let sellIndex = profile.balances.firstIndex(where: { $0.currency == sellCurrency }),
            let receiveIndex = profile.balances.firstIndex(where: { $0.currency == receiveCurrency })
        else {
            return
        }
        let fee = feeStrategy.calculate(profile: profile, amount: amount)
        let sellAmount = profile.balances[sellIndex].amount - amount - fee
        let exchangeAmount = Double(exchangeResult.amount) ?? 0.0
        let receiveAmount = profile.balances[receiveIndex].amount + exchangeAmount
        self.profile?.balances[sellIndex].amount = sellAmount
        self.profile?.balances[receiveIndex].amount = receiveAmount
        output?.onUpdateBalances(profile.balances)
        
        let from = CurrencyBalance(currency: sellCurrency, amount: amount)
        let to = CurrencyBalance(currency: receiveCurrency, amount: exchangeAmount)
        output?.onSubmit(from: from, to: to, fee: fee)
    }
}
