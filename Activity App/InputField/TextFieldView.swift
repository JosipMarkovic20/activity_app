//
//  TextFieldView.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit
import SnapKit

struct TextFieldViewStyle {
    let bottomLineColor: UIColor
    let font: UIFont
    let textColor: UIColor
    let placeholderColor: UIColor
    public init(bottomLineColor: UIColor, font: UIFont, textColor: UIColor, placeholderColor: UIColor) {
        self.bottomLineColor = bottomLineColor
        self.font = font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
    }
}


class TextFieldView: UIView {
    
    let textField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        return textField
    }()
    
    let sideButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    public var buttonPressed: (()->Void)?
    public var textChanged: ((String?)->Void)?
    let inputType: InputType
    
    init(inputType: InputType, buttonIcon: UIImage?, selectedButtonIcon: UIImage?) {
        self.inputType = inputType
        self.sideButton.setImage(buttonIcon, for: .normal)
        self.sideButton.setImage(selectedButtonIcon, for: .selected)
        super.init(frame: .zero)
        setupUI()
    }
    
    public func applyStyle(style: TextFieldViewStyle ) {
        self.bottomLine.backgroundColor = style.bottomLineColor
        textField.font = style.font
        textField.textColor = style.textColor
        textField.applyPlaceholderStyle(font: style.font, textColor: style.textColor, placeholderColor: style.placeholderColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TextFieldView {
    
    func setupUI() {
        self.addSubviews(views: [textField,
                            sideButton,
                            bottomLine])
        setupConstraints()
        setupSideButton()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textChanged?(textField.text)
    }
    
    func setupSideButton(){
        switch inputType{
        case .secureEntry:
            textField.isSecureTextEntry = true
        case .textInput:
            textField.isSecureTextEntry = false
        }
        sideButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    }
    
    @objc func buttonClick(){
        switch inputType{
        case .secureEntry:
            textField.isSecureTextEntry.toggle()
            sideButton.isSelected.toggle()
        case .textInput:
            buttonPressed?()
        }
    }
    
    func setupConstraints() {
        textField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(sideButton.snp.leading).inset(10)
        }
        
        sideButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalTo(textField)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension TextFieldView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString: NSString? = textField.text as NSString?
        let updatedString = nsString?.replacingCharacters(in: range, with: string)
        textField.text = updatedString

        let selectedRange = NSMakeRange(range.location + string.count, 0)
        let from = textField.position(from: textField.beginningOfDocument, offset: selectedRange.location)
        let to = textField.position(from: from!, offset:selectedRange.length)
        textField.selectedTextRange = textField.textRange(from: from!, to: to!)

        textField.sendActions(for: UIControl.Event.editingChanged)

        return false
    }
}
