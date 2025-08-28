//
//  BaseButton.swift
//  HongikYeolgong2-iOS
//
//  Created by 최주원 on 8/28/25.
//

import UIKit
import Then
import SnapKit

enum BaseButtonStyle {
    case blue
    case gray600
    case gray800
    
    var backgroundColor: UIColor {
        switch self {
            case .blue:
                return .blue100
            case .gray600:
                return .gray600
            case .gray800:
                return .gray600
        }
    }
    
    var fontColor: UIColor {
        switch self {
            case .blue:
                return .white
            case .gray600:
                return .gray100
            case .gray800:
                return .gray100
        }
    }
    
}

/// # 기존 활용 버튼
/// - buttonStyle : 버튼 스타일 ( 배경색 기준 선택 -> 배경, 폰트 색상 적용 )
/// - text : 버튼 label 내용
/// - leftImageView : 왼쪽 아이콘 활용할 때 입력
/// - onTap : 버튼 탭 이벤트
/// - radius : 버튼 테두리 반경 ( 기본 4 )
///
/// ## 해당 컴포넌트 .gray600 제외 다른 스타일 사용 시 스타일 입력하며 선언
/// > .blue 사용 예시:
/// let button = BaseButton(style: .blue)
///
// [ 사용 예시 ]
// private lazy var bassButton2 = BaseButton(style: .blue).then {
//      $0.text = "테스트 버튼"
//      $0.onTap = { print("baseButton 클릭 2")}
//      // 이미지 필요한 경우에만 입력
//      $0.leftImageView = UIImageView(image: .instagramLogo)
//      // radius 기본값 4 외 사용 시 입력
//       $0.radius = 8
// }
class BaseButton: UIButton {
    /// 버튼 스타일 ( 배경, 폰트 색상 지정 )
    /// .blue
    var buttonStyle: BaseButtonStyle = .gray600 {
        didSet {
            backgroundColor = buttonStyle.backgroundColor
            label.textColor = buttonStyle.fontColor
        }
    }
    
    /// 버튼 제목
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    /// 오른쪽 표시 부분
    var leftImageView: UIImageView? {
        didSet {
            // 기존 뷰 제거
            oldValue?.removeFromSuperview()
            // 추가할 이미지가 있는 경우 stackView 추가
            if let newView = leftImageView {
                stackView.insertArrangedSubview(newView, at: 0)
            }
        }
    }
    
    /// 뷰 탭했을때 이벤트
    var onTap: (() -> Void)?
    
    /// 바튼 테두리 반경
    var radius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    
    // MARK: - Private UI Components
    private let label = UILabel().then {
        $0.font = .body2_sb16
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [label]).then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
    }
    
    // MARK: - Initialization
    // 스타일 지정 생성자
    init(style: BaseButtonStyle = .gray600) {
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
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = buttonStyle.backgroundColor
        layer.cornerRadius = radius
        label.textColor = buttonStyle.fontColor
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        onTap?()
    }

}
