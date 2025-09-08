//
//  HomeViewModel.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 9/5/25.
//

import Combine

final class HomeViewModel: ViewModelType {
    
    private let userUseCase: UserUseCase
    private var cancellable = Set<AnyCancellable>()
    private let userNameSubject = CurrentValueSubject<String?, Never>("")
    
    // MARK: - Input & Output
    struct Input {
        let loginButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let userName: AnyPublisher<String?, Never>
    }
    
    func transform(_ input: Input) -> Output {
        input.loginButtonTapped.sink { [weak self] in
            guard let self = self else { return }
            userNameSubject.send("testUser")
        }
        .store(in: &cancellable)
        
       return Output(userName: userNameSubject.eraseToAnyPublisher())
    }
    
    // MARK: - Initializer
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
}
