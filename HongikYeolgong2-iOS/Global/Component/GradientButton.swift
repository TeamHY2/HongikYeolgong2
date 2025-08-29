//
//  GradientButton.swift
//  HongikYeolgong2-iOS
//
//  Created by 최주원 on 8/29/25.
//

import UIKit
import Then
import SnapKit

enum GradientButtonType {
    case main // 기본 색상
    case sub  // 서브 생상 (좌석 버튼)
    
    func bagroundColor(isEnabled: Bool = true)-> [CGColor] {
        switch self {
            case .main:
                return isEnabled ?
                    [   // 활성화 색상
                        UIColor(red: 51/255, green: 79/255, blue: 178/255, alpha: 1).cgColor,
                        UIColor(red: 83/255, green: 115/255, blue: 227/255, alpha: 1).cgColor
                    ] : [   // 비활성화 색상
                        UIColor(red: 19/255, green: 30/255, blue: 72/255, alpha: 1).cgColor,
                        UIColor(red: 25/255, green: 38/255, blue: 88/255, alpha: 1).cgColor
                    ]
            case .sub:
                return
                    [
                        UIColor(red: 24/255, green: 43/255, blue: 112/255, alpha: 1).cgColor,
                        UIColor(red: 36/255, green: 60/255, blue: 143/255, alpha: 1).cgColor
                    ]
        }
    }
    
    func borderColor(isEnabled: Bool = true)-> CGColor {
        switch self {
            case .main:
                return isEnabled ? UIColor.blue200.cgColor: UIColor.blue400.cgColor
            case .sub:
                return UIColor.blue400.cgColor
        }
    }
    
    func fontColor(isEnabled: Bool) -> UIColor {
        switch self {
            case .main:
                return isEnabled ? .white : .gray300
            case .sub:
                return .gray100
        }
    }
    
}

/// # 그라데이션 색상 버튼
/// - buttonStyle : 버튼 스타일 ( 배경색 기준 선택 -> 배경, 폰트 색상 적용 )
/// - title : 버튼 제목
/// - onTap : 버튼 클릭 액션
/// 생성자를 통해 GradientButton(style: .sub)사용하거나 내부 $0.buttonStyle = .sub 를 수정해서 사용하거나 편의에 따라 사용
class GradientButton: UIButton {
    /// 버튼 스타일 (기본, 서브(좌석 버튼용))
    var buttonStyle: GradientButtonType = .main {
        didSet {
            gradientLayer.colors = buttonStyle.bagroundColor(isEnabled: isEnabled)
            setTitleColor(buttonStyle.fontColor(isEnabled: isEnabled), for: .normal)
            layer.borderColor = buttonStyle.borderColor(isEnabled: isEnabled)
        }
    }
    
    /// 버튼 제목
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    /// 뷰 탭했을때 이벤트
    var onTap: (() -> Void)?
    
    private lazy var gradientLayer = CAGradientLayer().then {
        $0.colors = buttonStyle.bagroundColor()
        $0.type = .conic
        $0.locations = [0.0, 0.7, 1.0]
        $0.startPoint = CGPoint(x: 0.5, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.15)
    }
    
    override var isEnabled: Bool{
        didSet {
            // 활성화 여부에따른 색상 변경
            gradientLayer.colors = buttonStyle.bagroundColor(isEnabled: isEnabled)//isEnabled ? bagroundColor[0] : bagroundColor[1]
            setTitleColor(buttonStyle.fontColor(isEnabled: isEnabled), for: .normal)
            layer.borderColor = buttonStyle.borderColor(isEnabled: isEnabled)
        }
    }
    
    // MARK: - Initialization
    // 스타일 지정 생성자
    init(style: GradientButtonType = .main) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    // MARK: - Private Methods
    private func setupView() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.blue200.cgColor
        layer.borderWidth = 1
        layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel?.font = .body2_sb16
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // 이벤트 추가
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
