//
//  BalancesView.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 07.10.2022.
//

import UIKit
import SnapKit

// MARK: - BalancesView

final class BalancesView: UIView {
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My balances".uppercased()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 32.0
        return stackView
    }()
    
    private var balancesLabels: [UILabel] = []
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitleLabel()
        addScrollView()
        addBalances()
    }
    
    // MARK: - Layout
    
    private func addTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview()
        }
    }
    
    private func addScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(32.0)
        }
    }
    
    private func addBalances() {
        
//        for currency in Currency.allCases {
//            let label = UILabel()
//            label.text = "0.00 \(currency.rawValue)"
//            stackView.addArrangedSubview(label)
//            balancesLabels.append(label)
//        }
        
        let containerView = UIView()
        containerView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(containerView).inset(16.0)
            $0.top.bottom.equalTo(containerView)
        }

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    // MARK: - Public methods
    
    func addBalances(_ balances: [CurrencyBalance]) {
        for balance in balances {
            let label = UILabel()
            let amount = String(format: "%.2f", balance.amount)
            let currency = balance.currency.rawValue
            label.text = "\(amount) \(currency)"
            containerStackView.addArrangedSubview(label)
            balancesLabels.append(label)
        }
    }
    
    func updateBalances(_ balances: [CurrencyBalance]) {
        if balancesLabels.isEmpty && !balances.isEmpty {
            addBalances(balances)
        }
        guard balancesLabels.count == balances.count else {
            return
        }
        for index in 0..<balancesLabels.count {
            let label = balancesLabels[index]
            let balance = balances[index]
            let amount = String(format: "%.2f", balance.amount)
            let currency = balance.currency
            label.text = "\(amount) \(currency)"
        }
    }
}
