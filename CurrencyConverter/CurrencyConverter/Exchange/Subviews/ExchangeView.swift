//
//  ExchangeView.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import UIKit
import SnapKit

// MARK: - ExchangeView

final class ExchangeView: UIView {
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency exchange".uppercased()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    private let sellFieldView = ExchangeFieldView()
    private let receiveFieldView = ExchangeFieldView()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitleLabel()
        addSellFieldView()
        addReceiveFieldView()
    }
    
    // MARK: - Layout
    
    private func addTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview()
        }
    }
    
    private func addSellFieldView() {
        sellFieldView.setFieldType(.sell)
        addSubview(sellFieldView)
        sellFieldView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
        }
    }
    
    private func addReceiveFieldView() {
        receiveFieldView.setFieldType(.receive)
        addSubview(receiveFieldView)
        receiveFieldView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(sellFieldView.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Public methods
    
    func updateAmount(_ amount: Double, type: ExchangeFieldType) {
        switch type {
        case .sell:
            sellFieldView.updateAmount(amount)
        case .receive:
            receiveFieldView.updateAmount(amount)
        }
    }
    
    func updateCurrency(_ currency: Currency, type: ExchangeFieldType) {
        switch type {
        case .sell:
            sellFieldView.updateCurrency(currency)
        case .receive:
            receiveFieldView.updateCurrency(currency)
        }
    }
    
    func onEndEditing(_ closure: ((String?) -> Void)?) {
        sellFieldView.onEndEditing = closure
    }
    
    func onCurrencySelected(_ closure: ((Currency, ExchangeFieldType) -> Void)?) {
        sellFieldView.onCurrencySelected = closure
        receiveFieldView.onCurrencySelected = closure
    }
}
