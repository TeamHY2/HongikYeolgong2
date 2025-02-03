//
//  RecordView.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 9/23/24.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.injected.interactors.studyTimeInteractor) var studyTimeInteractor
    @State private var studyTime: Loadable<StudyTime> = .notRequest
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NetworkStateView(
            loadables: [AnyLoadable($studyTime)],
            retryAction: loadData
        ) {
            VStack(spacing: 0) {
                // 데이터가 없을 경우 디폴트값으로 표현
                StudyRecordView(selectedDate: selectedDate, studyTime: studyTime.value ?? StudyTime())
                
                Spacer()
                    .frame(height: 52.adjustToScreenHeight)
                
                CaledarView()
                
                Spacer()
                
                Button {
                    // 공유하기 기능 추가
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
    
    // 데이터 불러오기
    func loadData() -> Void {
        studyTimeInteractor.getStudyTime(StudyTime: $studyTime)
    }
}
