//
//  ExchangeMainView.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 07.10.2022.
//

import UIKit
import SnapKit

// MARK: - ExchangeMainView

final class ExchangeMainView: UIView {
    
    // MARK: - Subviews
    
    private let balancesView = BalancesView()
    private let exchangeView = ExchangeView()
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 11.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 21.0
        button.backgroundColor = UIColor(named: "primaryColor")
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("submit".uppercased(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0)
        return button
    }()
    
    // MARK: - Public properties
    
    var onSubmit: (() -> Void)?
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addBalancesView()
        addExchangeView()
        addErrorMessageLabel()
        addSubmitButton()
    }
    
    // MARK: - Layout
    
    private func addBalancesView() {
        addSubview(balancesView)
        balancesView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(24.0)
        }
    }
    
    private func addExchangeView() {
        addSubview(exchangeView)
        exchangeView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(balancesView.snp.bottom).offset(32.0)
        }
    }
    
    private func addErrorMessageLabel() {
        addSubview(errorMessageLabel)
        errorMessageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(exchangeView.snp.bottom).offset(8.0)
        }
    }
    
    private func addSubmitButton() {
        addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(42.0)
        }
        submitButton.addTarget(self, action: #selector(onSubmitButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Public methods
    
    func updateBalances(_ balances: [CurrencyBalance]) {
        balancesView.updateBalances(balances)
    }
    
    func updateAmount(_ amount: Double, type: ExchangeFieldType) {
        exchangeView.updateAmount(amount, type: type)
    }
    
    func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
    
    func onAmountUpdate(_ closure: ((String?) -> Void)?) {
        exchangeView.onEndEditing(closure)
    }
    
    func onCurrencySelected(_ closure: ((Currency, ExchangeFieldType) -> Void)?) {
        exchangeView.onCurrencySelected(closure)
    }
    
    @objc func onSubmitButtonTapped() {
        onSubmit?()
    }
}
