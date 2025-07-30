//
//  UIFont+.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 7/30/25.
//

import UIKit

enum FontName: String {
    // SUITE
    case suiteSemiBold = "SUITE-SemiBold"
    case suiteMedium = "SUITE-Medium"
    case suiteBold = "SUITE-Bold"
    case suiteExtraBold = "SUITE-ExtraBold"
    
    // Pretendard
    case pretendardThin = "Pretendard-Thin"
    case pretendardExtraLight = "Pretendard-ExtraLight"
    case pretendardBlack = "Pretendard-Black"
    case pretendardExtraBold = "Pretendard-ExtraBold"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardLight = "Pretendard-Light"
}

extension UIFont {
    
    static func custom(_ font: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // MARK: - Head
    static let head_sb18 = custom(.suiteSemiBold, size: 18)

    // MARK: - Title
    static let title1_b24 = custom(.suiteBold, size: 24)
    static let title2_b18 = custom(.pretendardBold, size: 18)
    static let title3_b16 = custom(.pretendardBold, size: 16)
    
    // MARK: - Body 1
    static let body1_eb30 = custom(.suiteExtraBold, size: 30)
    
    // MARK: - Body 2
    static let body2_sb16 = custom(.suiteSemiBold, size: 16)
    
    // MARK: - Body 3
    static let body3_m14 = custom(.suiteMedium, size: 14)
    
    // MARK: - Body 4
    static let body4_m12 = custom(.suiteMedium, size: 12)
    
    // MARK: - Body 5
    static let body5_r16 = custom(.pretendardRegular, size: 16)
    
    // MARK: - Body 6
    static let body6_r18 = custom(.pretendardRegular, size: 18)
    
    // MARK: - Body 7
    static let body7_r14 = custom(.pretendardRegular, size: 14)
    
    // MARK: - Caption
    static let caption_r12 = custom(.pretendardRegular, size: 12)
}
