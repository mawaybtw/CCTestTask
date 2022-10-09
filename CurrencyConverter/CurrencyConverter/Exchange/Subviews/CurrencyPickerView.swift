//
//  CurrencyPickerView.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import UIKit
import SnapKit
import DropDown

// MARK: - CurrencyPickerView

final class CurrencyPickerView: UIView {
    
    // MARK: - Subviews
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "EUR"
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(systemName: "chevron.down")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCurrencyLabel()
        addImageView()
    }
    
    // MARK: - Layout
    
    private func addCurrencyLabel() {
        addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        currencyLabel.setContentHuggingPriority(.required, for: .horizontal)
        currencyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func addImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(4.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(currencyLabel)
            $0.width.equalTo(20.0)
        }
    }
    
    // MARK: - Public methods
    
    func updateCurrency(_ currency: Currency) {
        currencyLabel.text = currency.rawValue
    }
}
