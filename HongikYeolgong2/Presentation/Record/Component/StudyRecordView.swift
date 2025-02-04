//
//  StudyRecordView.swift
//  HongikYeolgong2
//
//  Created by 최주원 on 11/13/24.
//

import SwiftUI

struct StudyRecordView: View {
    @Binding var selectedDate: Date?
    var studyTime: StudyTime
    
    var body: some View {
        VStack(spacing: 0){
            Text(selectedDate?.formattedFullDate() ?? Date().formattedFullDate())
                .font(.suite(size: 12, weight: .medium))
                .foregroundStyle(.gray300)
            
            Spacer()
                .frame(height: 6.adjustToScreenHeight)
            
            Text("\(studyTime.dayHours)H \(studyTime.dayMinutes)M")
                .font(.suite(size: 30, weight: .extrabold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(.sRGB, red: 211/255, green: 214/255, blue: 224/255, opacity: 1),
                            Color(.sRGB, red: 211/255, green: 214/255, blue: 224/255, opacity: 0.6)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
                .frame(height: 24.adjustToScreenHeight)
            
            HStack(spacing: 13.adjustToScreenWidth) {
                RecordCell(markImage: Image(.clock),
                           title: selectedDate?.getYearString() ?? Date().getYearString() + "년",
                           hours: studyTime.yearHours,
                           minutes: studyTime.yearMinutes)
                RecordCell(markImage: Image(.calendarDots),
                           title: selectedDate?.formattedMonth() ?? Date().formattedMonth() + "월",
                           hours: studyTime.monthHours,
                           minutes: studyTime.monthMinutes)
            }
        }
    }
}
