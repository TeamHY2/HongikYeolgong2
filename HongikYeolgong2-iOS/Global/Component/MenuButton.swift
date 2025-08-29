//
//  MenuButton.swift
//  HongikYeolgong2-iOS
//
//  Created by 최주원 on 8/27/25.
//

import UIKit
import Then
import SnapKit

/// # 메뉴 공통 버튼
/// - title : 버튼 좌측 내용
/// - rightContentView : 버튼 우측 view
/// - onTap : 버튼 클릭 클로저
class MenuButton: UIView {
    // MARK: - Public Properties
    /// 버튼 제목
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    /// 오른쪽 표시 부분
    var rightContentView: UIView? {
        didSet {
            // 기존 뷰 제거
            oldValue?.removeFromSuperview()
            // 새로 추가할 뷰 있는 경우 stackView 추가
            if let newView = rightContentView {
                stackView.addArrangedSubview(newView)
            }
        }
    }

    /// 뷰 탭했을때 이벤트
    var onTap: (() -> Void)?

    // MARK: - Private UI Components
    private let titleLabel = UILabel().then {
        $0.textColor = .gray200
        $0.font = .body5_r16
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }

    // MARK: - Initialization
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
        backgroundColor = .gray800
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        onTap?()
    }
}
