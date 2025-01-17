//
//  AppEnviroment.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 10/11/24.
//

import Foundation
import UIKit

import FirebaseCore

struct AppEnviroment {
    let container: DIContainer
    let systemEventsHandler: SystemEventHandler
}

extension AppEnviroment {
    
    static func bootstrap() -> AppEnviroment {
        FirebaseApp.configure()
        let appState = Store<AppState>(AppState())
        let services = configuredServices()
        let remoteRepositories = configuredRemoteRepositories()
        let interactors = configuredInteractors(
            appState: appState,
            remoteRepository: remoteRepositories,
            services: services
        )
        
        let diContainer = DIContainer(
            appState: appState,
            interactors: interactors,
            services: services
        )
        
        let systemEventsHandler = RealSystemEventHandler(container: diContainer)
        
        return .init(container: diContainer, systemEventsHandler: systemEventsHandler)
    }
    
    /// 외부 데이터소스에 접근하는 레포지토리 의존성을 설정하고 관련 인스턴스를 반환합니다.
    /// - Returns:외부 데이터소스에 접근하기위한 컨테이너
    static func configuredRemoteRepositories() -> DIContainer.RemoteRepositories {
        .init(
            authRepository: AuthRepositoryImpl(),
            studySessionRepository: StudySessionRepositoryImpl(),
            weeklyRepository: WeeklyRepositoryImpl()
        )
    }
    
    /// 앱의 인터랙터를 구성하고 의존성을 설정합니다.
    /// - Parameters:
    ///   - appState: 앱의 상태를 관리하는 글로벌 인스턴스
    ///   - remoteRepository: 외부 데이터소스 접근 레포지토리
    ///   - services: 앱을 구성하는 서비스 인스턴스
    /// - Returns:앱의 인터랙터를 구성하는 컨테이너
    static func configuredInteractors(
        appState: Store<AppState>,
        remoteRepository: DIContainer.RemoteRepositories,
        services: DIContainer.Services
    ) -> DIContainer.Interactors {
        .init(
            userDataInteractor: UserDataMigrationInteractor(
                appState: appState,
                authRepository: remoteRepository.authRepository,
                socialLoginRepository: SocialLoginRepositoryImpl(),
                appleLoginService: services.appleAuthService
            ),
            studyTimeInteractor: StudyTimeInteractorImpl(
                studySessionRepository: remoteRepository.studySessionRepository
            ),
            studySessionInteractor: StudySessionInteractorImpl(
                appState: appState,
                studySessionRepository: remoteRepository.studySessionRepository
            ),
            userPermissionsInteractor: RealUserPermissionsInteractor(
                appState: appState,
                openAppSetting: {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            ),
            weeklyStudyInteractor: WeeklyStudyInteractorImpl(
                appState: appState,
                studySessionRepository: remoteRepository.studySessionRepository
            ),
            rankingDataInteractor: RankingDataInteractorImpl(studySessionRepository: remoteRepository.studySessionRepository, weeklyRepository: remoteRepository.weeklyRepository),
            calendarDataInteractor: CalendarDataInteractorImpl(appstate: appState, studySessionRepository: remoteRepository.studySessionRepository)
        )
    }
    
    /// 앱의 서비스를 구성하는 컨테이너를 반환합니다.
    /// - Returns: 앱의 서비스를 구성하는 컨테이너
    static func configuredServices() -> DIContainer.Services {
        .init(appleAuthService: AppleLoginManager())
    }
}

extension DIContainer {
    struct RemoteRepositories {
        let authRepository: AuthRepository
        let studySessionRepository: StudySessionRepository
        let weeklyRepository: WeeklyRepository
    }
    
    struct Services {
        let appleAuthService: AppleLoginService
    }
}
