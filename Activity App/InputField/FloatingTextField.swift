//
//  FloatingTextField.swift
//  Activity App
//
//  Created by Josip Marković on 25.06.2021..
//

import Foundation
import UIKit

private extension TimeInterval {
    static let animation300ms: TimeInterval = 0.25
}

private extension UIColor {
    static let inactive: UIColor = .gray
}

private enum Constants {
    static let placeholderSize: CGFloat = 14
    static let paddingHorizontal: CGFloat = 15
    static let bottomPadding = 8
    
}

enum TextFieldViewType {
    case filled(color: UIColor)
    case border(color: UIColor)
}



public class FloatingTextField: UITextField {
    
    // MARK: - Subviews
    private var border = UIView()
    private var label = UILabel()
    private var placeholderLabel = UILabel()
    
    var textFieldType: TextFieldViewType = .filled(color: .white)
    
    private var scale: CGFloat {
        Constants.placeholderSize / fontSize
    }
    
    private var fontSize: CGFloat {
        font?.pointSize ?? 0
    }
    
    private var labelHeight: CGFloat {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }
    
    private var textHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }
    
    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: labelHeight, left: Constants.paddingHorizontal, bottom: CGFloat(Constants.bottomPadding), right: Constants.paddingHorizontal)
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public func applyPlaceholderStyle(font: UIFont, textColor: UIColor, placeholderColor: UIColor) {
        label.font = font
        placeholderLabel.font = font
        label.textColor = textColor
        placeholderLabel.textColor = placeholderColor
    }
    
    // MARK: - UITextField
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }
    
    public override var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            label.text = placeholder
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !isFirstResponder else {
            return
        }
        
        label.transform = .identity
        label.frame = bounds.inset(by: textInsets)
        placeholderLabel.transform = .identity
        placeholderLabel.frame = bounds.inset(by: textInsets)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        switch textFieldType {
        case .border(let color):
            border.backgroundColor = color
            border.isUserInteractionEnabled = false
            addSubview(border)
        case .filled(let color):
            backgroundColor = color
        }
        borderStyle = .none
        
        
        
        label.font = font
        label.text = placeholder
        label.isUserInteractionEnabled = false
        addSubview(label)
        
        placeholderLabel.font = font
        placeholderLabel.text = placeholder
        placeholderLabel.isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        
        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
        addTarget(self, action: #selector(handlePlaceholder), for: .editingChanged)
    }
    
    @objc
    private func handlePlaceholder() {
        if isEmpty {
            placeholderLabel.isHidden = false
        }else {
            placeholderLabel.isHidden = true
        }
    }
    
    @objc
    private func handleEditing() {
        updateLabel()
        updateBorder()
    }
    
    private func updateBorder() {
        let borderColor = isFirstResponder ? tintColor : .inactive
        UIView.animate(withDuration: .animation300ms) {
            self.border.backgroundColor = borderColor
        }
    }
    
    private func updateLabel(animated: Bool = true) {
        let isActive = isFirstResponder || !isEmpty
        let offsetY = -label.bounds.height * (1 - scale) / 2
        let transform = CGAffineTransform(translationX: 0, y: offsetY - labelHeight)
        
        guard animated else {
            label.transform = isActive ? transform : .identity
            return
        }
        
        UIView.animate(withDuration: .animation300ms) {
            if isActive {
                self.label.transform = transform
                self.label.font = self.label.font.withSize(11)
            }else {
                self.label.transform = .identity
                
            }
            
        }completion: { completion in
            if !isActive {
                self.label.font = self.label.font.withSize(17)
            }
            
        }
    }
}
