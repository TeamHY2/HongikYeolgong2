
import SwiftUI

enum CellStyle: CaseIterable {
    case dayCount00
    case dayCount01
    case dayCount02
    case dayCount03
}

struct Day: Identifiable {
    var id = UUID().uuidString
    let dayOfNumber: String
    var usageRecord: [AllStudyRecord] = []
    
    var todayUsageCount: [Int] {
        return usageRecord.map {$0.studyCount}
    }
}

struct CalendarCell: View {
    
    let dayInfo: Day
    var isSelected: Bool
    var onTap: () -> Void
    
    private var cellStyle: CellStyle {
        let maxUsageCount = dayInfo.todayUsageCount.max() ?? 0
        
        if maxUsageCount >= 3 {
            return .dayCount03
        } else if maxUsageCount >= 2 {
            return .dayCount02
        } else if maxUsageCount >= 1 {
            return .dayCount01
        } else {
            return .dayCount00
        }
    }
    
    private var isVisible: Bool {
        dayInfo.dayOfNumber.isEmpty
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack {
                Text(dayInfo.dayOfNumber)
                    .font(.suite(size: 14, weight: .medium))
                    .foregroundStyle(getForegroundStyle())
            }
            .frame(width: 38.adjustToScreenWidth,height: 38.adjustToScreenHeight)
            .background(Image(getImageForCellStyle())
                .resizable()
                .frame(width: 48.adjustToScreenWidth,height: 48.adjustToScreenHeight))
            .cornerRadius(8)
            .opacity(isVisible ? 0 : 1)
            .overlay(isVisible || isSelected ? nil : Color.dark.opacity(0.6))
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .disabled(isVisible || cellStyle == .dayCount00)
    }
    
    private func getImageForCellStyle() -> ImageResource {
        switch cellStyle {
            case .dayCount00: return .dayCount00
            case .dayCount01: return .dayCount01
            case .dayCount02: return .dayCount02
            case .dayCount03: return .dayCount03
        }
    }
    
    private func getForegroundStyle() -> Color {
        switch cellStyle {
            case .dayCount00: return .gray300
            case .dayCount01: return .gray100
            case .dayCount02: return .white
            case .dayCount03: return .gray600
        }
    }
}

