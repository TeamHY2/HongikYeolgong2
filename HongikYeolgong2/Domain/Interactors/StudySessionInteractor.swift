//
//  WeeklyStudyInteractor.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 10/24/24.
//

import SwiftUI
import Combine

protocol StudySessionInteractor {
    func startStudy()
    func endStudy()
    func pauseStudy()
    func resumeStudy()
    func addTime()
    func uploadStudySession(startTime: Date, endTime: Date)
    func setStartTime(_ startTime: Date)
}

final class StudySessionInteractorImpl: StudySessionInteractor {
    
    private let appState: Store<AppState>
    private let cancleBag = CancelBag()
    private let studySessionRepository: StudySessionRepository
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    private let addedTime: TimeInterval = .init(hours: 6)
    
    private var lastTime: Date?
    private var subscription: AnyCancellable?
    
    init(appState: Store<AppState>,
         studySessionRepository: StudySessionRepository) {
        self.appState = appState
        self.studySessionRepository = studySessionRepository
    }
    
    /// 스터디세션을 시작합니다.
    func startStudy() {
        let startTime = appState.value.studySession.startTime
        let timeDiff = Date().timeIntervalSince(startTime)
        let timeDiffMinutes = TimeInterval(minutes: Int(timeDiff / 60))
        let endTime = startTime + addedTime
        let remainingTime = endTime.timeIntervalSince(startTime) - timeDiffMinutes
        
        appState.bulkUpdate { appState in
            appState.studySession.isStudying = true
            appState.studySession.endTime = endTime
            appState.studySession.remainingTime = remainingTime
        }
        
        startTimer()
        registerNotification(for: .extensionAvailable, endTimeInMinute: remainingTime)
        registerNotification(for: .urgent, endTimeInMinute: remainingTime)
    }
    
    /// 타이머를 시작합니다.
    func startTimer() {
        subscription = timer.sink { [weak appState] _ in
            appState?[\.studySession.remainingTime] -= 1
        }
    }
    
    /// 타이머를 중지합니다.
    func stopTimer() {
        appState[\.studySession.isStudying] = false
        subscription?.cancel()
        lastTime = nil
    }
    
    /// 스터디세션을 종료하고 열람실 이용정보를 서버에 업로드합니다.
    func endStudy() {
        stopTimer()
        cancelAllNotification()
        
        let startTime: Date = appState.value.studySession.startTime
        let remainingTime = appState.value.studySession.remainingTime
        // 최대시간
        // 최근이용 시작시간 + 6시간
        let maxEndTime = appState.value.studySession.startTime.addingTimeInterval(.init(hours: 6))
        // 남은시간이 0인경우 최대시간 적용
        let endTime: Date = remainingTime <= 0 ? maxEndTime : .now
        
        uploadStudySession(startTime: startTime, endTime: endTime)
    }
    
    /// 스터디 일시중지
    func pauseStudy() {
        assert(appState.value.studySession.isStudying, "스터디세션 시작상태가 아님")
        subscription?.cancel()
        lastTime = .now
    }
    
    /// 스터디 다시시작
    func resumeStudy() {
        assert(appState.value.studySession.isStudying, "스터디세션 시작상태가 아님")
        
        guard let lastTime = lastTime else { return }
        let currentTime: Date = .now
        let timeDifferent = currentTime.timeIntervalSince(lastTime)
        
        appState[\.studySession.remainingTime] -= timeDifferent
        startTimer()
    }
    
    /// 열람실 이용시간을 연장합니다.
    func addTime() {
        let startTime: Date = appState.value.studySession.startTime
        let endTime: Date = .now
        
        uploadStudySession(startTime: startTime, endTime: endTime)
        
        appState.bulkUpdate { appState in
            appState.studySession.startTime = .now
            appState.studySession.endTime += addedTime
            appState.studySession.remainingTime += addedTime
        }
        
        let remainingTime = appState.value.studySession.remainingTime
        
        cancelAllNotification()
        registerNotification(for: .extensionAvailable, endTimeInMinute: remainingTime)
        registerNotification(for: .urgent, endTimeInMinute: remainingTime)
    }
        
    /// 서버에 스터디세션을 업로드 합니다.
    /// - Parameters:
    ///   - startTime: 시작시간
    ///   - endTime: 종료시간
    func uploadStudySession(startTime: Date, endTime: Date) {
        studySessionRepository
            .uploadStudyRecord(startTime: startTime, endTime: endTime)
            .sink { _ in
            } receiveValue: { _ in
            }
            .store(in: cancleBag)
    }
    
    /// 열람실 이용 시작시간을 설정합니다.
    /// - Parameter startTime: 시작시간
    func setStartTime(_ startTime: Date) {
        appState.bulkUpdate { appState in
            appState.studySession.startTime = startTime
            appState.studySession.firstStartTime = startTime
        }
    }
    
    /// 열람실 이용종료 Notification을 등록합니다.
    func registerNotification(for type: LocalNotification, endTimeInMinute: TimeInterval) {
        guard appState.value.userData.isOnAlarm else { return }
        let content = configuredNotificationContent(for: type)
        let trigger = configuredNotificationTrigger(for: type, endTime: endTimeInMinute)
        let request = UNNotificationRequest(
            identifier: "\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// Notification Content 설정
    func configuredNotificationContent(for type: LocalNotification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.body = type.message
        content.sound = .default
        return content
    }
    
    /// Notification Trigger 설정
    func configuredNotificationTrigger(for type: LocalNotification, endTime: TimeInterval) -> UNTimeIntervalNotificationTrigger? {
        let triggerTime = endTime - type.timeOffset
        
//        assert(endTime - triggerTime == type.timeOffset, "잘못된 시간이 등록되었습니다.")
//        assert(triggerTime > 0, "잔여 시간이 부족합니다. (필요: \(Int(type.timeOffset/60))분, 현재: \(Int(endTime/60))분)")
        
        guard triggerTime > 0 else {
            return nil
        }
        return UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)
    }
    
    private func cancelAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
