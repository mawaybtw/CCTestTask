//
//  ExchangeFieldView.swift
//  CurrencyConverter
//
//  Created by Vladislav Pavlenko on 08.10.2022.
//

import UIKit
import SnapKit
import DropDown

// MARK: - ExchangeFieldType

enum ExchangeFieldType {
    case sell
    case receive
}

// MARK: - ExchangeFieldView

final class ExchangeFieldView: UIView {
    
    // MARK: - Private properties
    
    private var fieldType: ExchangeFieldType = .sell
    
    // MARK: - Subviews
    
    private let imageView: UIImageView = {
        let image = UIImage(systemName: "arrow.up.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .red
        return imageView
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sell"
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.text = "0.00"
        textField.font = .systemFont(ofSize: 13.0)
        textField.keyboardType = .decimalPad
        textField.textColor = .black
        return textField
    }()
    
    private let pickerView = CurrencyPickerView()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.1)
        return view
    }()
    
    private let dropDown = DropDown()
    
    // MARK: - Public methods
    
    var onEndEditing: ((String?) -> Void)? = nil
    var onCurrencySelected: ((Currency, ExchangeFieldType) -> Void)? = nil
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
        addTypeLabel()
        addTextField()
        addPickerView()
        addSeparatorView()
        addDropDown()
    }
    
    // MARK: - Layout
    
    private func addImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(36.0)
        }
    }
    
    private func addTypeLabel() {
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(imageView)
        }
        typeLabel.setContentHuggingPriority(.required, for: .horizontal)
        typeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func addTextField() {
        textField.delegate = self
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalTo(typeLabel.snp.trailing).offset(16.0)
            $0.top.equalTo(typeLabel)
        }
    }
    
    private func addPickerView() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.leading.equalTo(textField.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(imageView)
        }
    }
    
    private func addSeparatorView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(typeLabel)
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8.0)
            $0.height.equalTo(1.0)
        }
    }
    
    private func addDropDown() {
        dropDown.dataSource = Currency.allCases.map { $0.rawValue }
        dropDown.anchorView = pickerView
        dropDown.selectionAction = { [weak self] _, item in
            guard let self = self else { return }
            guard let currency = Currency(rawValue: item) else { return }
            self.updateCurrency(currency)
            self.onCurrencySelected?(currency, self.fieldType)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDropDown))
        pickerView.addGestureRecognizer(tap)
    }
    
    // MARK: - Public methods
    
    func setFieldType(_ type: ExchangeFieldType) {
        guard fieldType != type else { return }
        fieldType = type
        switch type {
        case .sell:
            imageView.image = UIImage(systemName: "arrow.up.circle.fill")
            imageView.tintColor = .red
            typeLabel.text = "Sell"
            textField.textColor = .black
            textField.text = "0.00"
            textField.isEnabled = true
        case .receive:
            imageView.image = UIImage(systemName: "arrow.down.circle.fill")
            imageView.tintColor = .systemGreen
            typeLabel.text = "Receive"
            textField.textColor = .systemGreen
            textField.text = "+ 0.00"
            textField.isEnabled = false
        }
    }
    
    func updateAmount(_ amount: Double) {
        let amountString = String(format: "%.2f", amount)
        switch fieldType {
        case .sell:
            textField.text = amountString
        case .receive:
            textField.text = "+ \(amountString)"
        }
    }
    
    func updateCurrency(_ currency: Currency) {
        pickerView.updateCurrency(currency)
    }
    
    @objc func showDropDown() {
        dropDown.bottomOffset = CGPoint(x: 0, y: pickerView.frame.size.height + 8.0)
        dropDown.show()
    }
}

// MARK: - UITextFieldDelegate

extension ExchangeFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let index = currentText.firstIndex(of: ".") else {
            return true
        }
        guard string != "." else {
            return false
        }
        let distance = currentText.distance(from: currentText.startIndex, to: index)
        return distance + 2 >= range.location
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEndEditing?(textField.text)
    }
}
