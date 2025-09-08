//
//  DefaultUserUseCase.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 9/5/25.
//

final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loginUser() async -> UserInfo {
        await userRepository.loginUser()
    }
}
