import SwiftUI

struct FocusNowView: View {
    let focusItem: TodoItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Фокус на сейчас")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let focusItem {
                Text(focusItem.title)
                    .font(.headline)

                HStack(spacing: 8) {
                    Label(focusItem.priority.rawValue, systemImage: focusItem.priority.icon)
                        .font(.caption)
                        .foregroundStyle(focusItem.priority.color)

                    Spacer()

                    if let dueDate = focusItem.dueDate {
                        let isOverdue = dueDate < Date() && !Calendar.current.isDateInToday(dueDate) && !focusItem.isDone

                        Label(
                            dueDate.formatted(date: .abbreviated, time: .omitted),
                            systemImage: isOverdue ? "exclamationmark.triangle.fill" : "calendar"
                        )
                        .font(.caption)
                        .foregroundStyle(isOverdue ? .red : .secondary)
                    }
                }
            } else {
                Text("Нет активных задач")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FocusDashboardView: View {
    let overdueCount: Int
    let dueTodayCount: Int
    let completionRate: Double
    let isOverdueActive: Bool
    let isTodayActive: Bool
    let onTapOverdue: () -> Void
    let onTapToday: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Button(action: onTapOverdue) {
                    StatCardView(
                        title: "Просрочено",
                        value: "\(overdueCount)",
                        color: .red,
                        isActive: isOverdueActive
                    )
                }
                .buttonStyle(.plain)

                Button(action: onTapToday) {
                    StatCardView(
                        title: "Сегодня",
                        value: "\(dueTodayCount)",
                        color: .orange,
                        isActive: isTodayActive
                    )
                }
                .buttonStyle(.plain)

            }

            HStack(spacing: 8) {
                ProgressView(value: completionRate) {
                    Text("Прогресс")
                        .font(.caption)
                }

                Text("\(Int(completionRate * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct StatCardView: View {
    let title: String
    let value: String
    let color: Color
    let isActive: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isActive ? color : .clear, lineWidth: 1)
        }
    }
}
