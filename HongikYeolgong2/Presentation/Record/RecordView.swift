//
//  RecordView.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 9/23/24.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.injected.interactors.studyTimeInteractor) var studyTimeInteractor
    @Environment(\.injected.interactors.calendarDataInteractor) var calendarDataInteractor
    @State private var studyTime: Loadable<StudyTime> = .notRequest
    @State private var allStudy: Loadable<[AllStudyRecord]> = .notRequest
    @State private var selectedDate: Date?
    
    // 캘린더 상태를 외부에서 관리
    @State private var currentDate = Date()
    @State private var currentMonth: [Day] = []
    
    var body: some View {
        NetworkStateView(
            loadables: [AnyLoadable($studyTime), AnyLoadable($allStudy)],
            retryAction: loadData
        ) {
            VStack(spacing: 0) {
                record
                
                Spacer()
                // 공유하기 버튼
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let image = captureAsImage(){
                            shareImage(image: image)
                        }
                    }
                } label: {
                    HStack(spacing: 4){
                        Image(.export)
                        Text("기록 공유하기")
                            .font(.pretendard(size: 16, weight: .bold))
                            .foregroundStyle(.gray100)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.gray800)
                    .cornerRadius(4)
                }

            }
            .padding(.horizontal, 32.adjustToScreenWidth)
            .padding(.top, 32.adjustToScreenHeight)
            .padding(.bottom, 36.adjustToScreenHeight)
            .onAppear(perform: loadData)
        }
        .modifier(IOSBackground())
    }
    
    // 기록 관련 컴포넌트
    var record: some View {
        VStack(spacing: 0){
            // 기록 view
            // 데이터가 없을 경우 디폴트값으로 표현
            StudyRecordView(selectedDate: $selectedDate, studyTime: studyTime.value ?? StudyTime())
            
            Spacer()
                .frame(height: 52.adjustToScreenHeight)
            
            // 캘린더 view
            switch allStudy {
                case .success(let value):
                    CaledarView(
                        AllStudy: value,
                        currentDate: $currentDate,
                        currentMonth: $currentMonth,
                        selectedDate: $selectedDate
                    )
                default:
                    CaledarView(
                        AllStudy: [],
                        currentDate: $currentDate,
                        currentMonth: $currentMonth,
                        selectedDate: $selectedDate
                    )
            }
        }
    }
    
    // 공유 용도 View
    var snapshotContent: some View {
        VStack(spacing: 0) {
            record
            Spacer().frame(height: 1.adjustToScreenHeight)
            Image(.logo)
                .resizable()
                .frame(width: 25, height: 25)
        }
        .padding(.horizontal, 32.adjustToScreenWidth)
        .padding(.top, 32.adjustToScreenHeight)
        .padding(.bottom, 70.adjustToScreenHeight)
        .modifier(IOSBackground())
    }
    
    // 데이터 불러오기
    func loadData() -> Void {
        studyTimeInteractor.getStudyTime(StudyTime: $studyTime)
        calendarDataInteractor.getAllStudy(studyRecords: $allStudy)
    }
    
    // 캡처 함수 (공유 이미지 생성)
    func captureAsImage() -> UIImage? {
        let controller = UIHostingController(rootView: snapshotContent)
        guard let view = controller.view else { return nil }

        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 666.adjustToScreenHeight)
        
        let fittingSize = view.sizeThatFits(targetSize)
        view.frame = CGRect(origin: .zero, size: fittingSize)
        view.backgroundColor = .dark

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // 공유하기 기능
    func shareImage(image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        rootViewController.present(activityViewController, animated: true)
    }
}
