//
//  HYTextField.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 8/17/25.
//

import UIKit
import SnapKit
import Then

final class HYTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
    
    private lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(resource: .close), for: .normal)
        $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .gray800
        textColor = .gray200
        font = .body5_r16
        layer.cornerRadius = 8
        rightViewMode = .never
        rightView = deleteButton
    }
    
    func setPlaceholder(text: String) {
        placeholder = text
        setPlaceholder(color: .gray400)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var padding = padding
        padding.right += deleteButton.bounds.width
        return bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 14
        return padding
    }
    
    @objc
    func deleteButtonTapped() {
        text = ""
    }
}

extension HYTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightViewMode = textField.text?.isEmpty == false ? .always : .never
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightViewMode = .never
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.rightViewMode = (textField.text?.isEmpty == false) ? .always : .never
        }
        return true
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyYellowButtonPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let button = HYTextField()
            button.setPlaceholder(text: "닉네임을 입력해주세요")
            return button
        }.previewLayout(.sizeThatFits)
    }
}
#endif
