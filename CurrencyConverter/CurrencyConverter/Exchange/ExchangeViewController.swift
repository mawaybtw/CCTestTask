//
//  ExchangeViewController.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 07.10.2022.
//

import UIKit
import SnapKit

// MARK: - ExchangeViewController

class ExchangeViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: ExchangeViewModelInput = ExchangeViewModel()
    private let mainView = ExchangeMainView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.output = self
        viewModel.requestBalances()
        
        title = "Currency converter"
        setupNavigationBar()
        setupMainView()
        setupKeyboardDismiss()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "primaryColor") ?? .blue
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13.0)
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupMainView() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainView.onAmountUpdate { [weak self] text in
            guard
                let text = text,
                let amount = Double(text)
            else {
                return
            }
            self?.viewModel.onAmountUpdate(amount)
        }
        mainView.onCurrencySelected { [weak self] currency, type in
            self?.viewModel.onCurrencySelected(currency, type: type)
        }
        mainView.onSubmit = { [weak self] in
            self?.viewModel.onSubmit()
        }
    }
    
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ExchangeViewModelOutput

extension ExchangeViewController: ExchangeViewModelOutput {
    func onError(_ message: String) {
        mainView.showErrorMessage(message)
    }
    
    func onUpdateBalances(_ balances: [CurrencyBalance]) {
        mainView.updateBalances(balances)
    }
    
    func onUpdateAmount(_ amount: Double, type: ExchangeFieldType) {
        mainView.updateAmount(amount, type: type)
    }
    
    func onSubmit(from: CurrencyBalance, to: CurrencyBalance, fee: Double) {
        let title = "Currency converted"
        let fromAmount = String(format: "%.2f", from.amount)
        let toAmount = String(format: "%.2f", to.amount)
        var message = "You have converted \(fromAmount) \(from.currency) to \(toAmount) \(to.currency)."
        if fee > 0 {
            let feeString = String(format: "%.2f", fee)
            message += " Commission Fee - \(feeString) \(from.currency)"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Done", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
