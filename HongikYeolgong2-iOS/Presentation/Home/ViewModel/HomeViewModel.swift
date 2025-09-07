//
//  HomeViewModel.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 9/5/25.
//

final class HomeViewModel {
    private let userUseCase: UserUseCase
    
    var userName: String = ""
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
}
