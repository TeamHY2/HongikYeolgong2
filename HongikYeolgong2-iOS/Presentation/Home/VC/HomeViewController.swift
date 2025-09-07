//
//  HomeViewController.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 8/26/25.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private let viewModel: HomeViewModel
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setConstraint()
    }

    private func addSubViews() {
        view.addSubview(loginButton)
    }
    
    private func setConstraint() {
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc
    private func loginButtonTapped() {
        print("tapped")
    }
}
