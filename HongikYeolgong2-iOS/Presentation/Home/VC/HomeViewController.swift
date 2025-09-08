//
//  HomeViewController.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 8/26/25.
//

import UIKit
import SnapKit
import Then
import Combine

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
    
    private let loginButtonTapSubject = PassthroughSubject<Void, Never>.init()
    private var cancellable = Set<AnyCancellable>()
    private let userNameText = UILabel()
    
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
        dataBind()
    }
    
    private func dataBind() {
        let output = viewModel.transform(
            HomeViewModel.Input(loginButtonTapped: loginButtonTapSubject.eraseToAnyPublisher())
        )
        
        output.userName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: userNameText)
            .store(in: &cancellable)
    }
    
    private func addSubViews() {
        view.addSubview(loginButton)
        view.addSubview(userNameText)
    }
    
    private func setConstraint() {
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        userNameText.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(loginButton.snp.bottom).offset(10)
        }
    }
    
    private func updateUserName(_ userName: String) {
        self.userNameText.text = userName
    }
    
    @objc
    private func loginButtonTapped() {
        loginButtonTapSubject.send()
    }
}
