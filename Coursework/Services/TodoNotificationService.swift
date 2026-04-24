import Foundation
import UserNotifications

enum TodoNotificationService {
    private static let scheduledIDsKey = "todo_scheduled_notification_ids_v1"

    static func requestAuthorizationIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else {
            return
        }

        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    static func sendTestNotification() async {
        let center = UNUserNotificationCenter.current()
        let testID = "todo.test.notification"

        center.removePendingNotificationRequests(withIdentifiers: [testID])
        center.removeDeliveredNotifications(withIdentifiers: [testID])

        let content = UNMutableNotificationContent()
        content.title = "Тестовое уведомление"
        content.body = "Уведомления работают корректно"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: testID, content: content, trigger: trigger)
        await addRequest(request)
    }

    static func syncNotifications(for items: [TodoItem]) async {
        let center = UNUserNotificationCenter.current()
        let previouslyScheduledIDs = UserDefaults.standard.stringArray(forKey: scheduledIDsKey) ?? []

        center.removePendingNotificationRequests(withIdentifiers: previouslyScheduledIDs)
        center.removeDeliveredNotifications(withIdentifiers: previouslyScheduledIDs)

        let settings = await center.notificationSettings()
        let isAllowed = settings.authorizationStatus == .authorized
            || settings.authorizationStatus == .provisional

        guard isAllowed else {
            UserDefaults.standard.set([], forKey: scheduledIDsKey)
            return
        }

        var newlyScheduledIDs: [String] = []

        for item in items where !item.isDone {
            guard let dueDate = item.dueDate else {
                continue
            }

            let ids = notificationIDs(for: item.id)

            if let soonDate = soonReminderDate(for: dueDate), soonDate > Date() {
                let request = makeRequest(
                    id: ids.soonID,
                    title: "Срок скоро",
                    body: "\(item.title): дедлайн уже завтра",
                    fireDate: soonDate
                )
                await addRequest(request)
                newlyScheduledIDs.append(ids.soonID)
            }

            if let dueDayDate = dueDayReminderDate(for: dueDate), dueDayDate > Date() {
                let request = makeRequest(
                    id: ids.dueDayID,
                    title: "Срок сегодня",
                    body: "\(item.title): не забудьте завершить задачу",
                    fireDate: dueDayDate
                )
                await addRequest(request)
                newlyScheduledIDs.append(ids.dueDayID)
            }
        }

        UserDefaults.standard.set(newlyScheduledIDs, forKey: scheduledIDsKey)
    }

    private static func notificationIDs(for itemID: UUID) -> (soonID: String, dueDayID: String) {
        (
            soonID: "todo.deadline.soon.\(itemID.uuidString)",
            dueDayID: "todo.deadline.today.\(itemID.uuidString)"
        )
    }

    private static func soonReminderDate(for dueDate: Date) -> Date? {
        let calendar = Calendar.current
        let dueStart = calendar.startOfDay(for: dueDate)

        guard let previousDay = calendar.date(byAdding: .day, value: -1, to: dueStart) else {
            return nil
        }

        return calendar.date(bySettingHour: 18, minute: 0, second: 0, of: previousDay)
    }

    private static func dueDayReminderDate(for dueDate: Date) -> Date? {
        let calendar = Calendar.current
        let dueStart = calendar.startOfDay(for: dueDate)
        return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: dueStart)
    }

    private static func makeRequest(id: String, title: String, body: String, fireDate: Date) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        return UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    }

    private static func addRequest(_ request: UNNotificationRequest) async {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().add(request) { _ in
                continuation.resume()
            }
        }
    }
}
