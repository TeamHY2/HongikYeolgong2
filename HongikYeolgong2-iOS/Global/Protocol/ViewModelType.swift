//
//  ViewModelType.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 9/8/25.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output    
    func transform(_ input: Input) -> Output
}
