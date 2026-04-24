import SwiftUI

struct ContentView: View {
    @State private var items: [TodoItem]

    @State private var showingAddSheet = false
    @State private var statusFilter: StatusFilter = .all
    @State private var priorityFilter: PriorityFilter = .all
    @State private var sortOption: SortOption = .focus
    @State private var onlyWithDueDate = false

    init() {
        _items = State(initialValue: TodoPersistence.loadItems() ?? [])
    }

    private var openItems: [TodoItem] {
        items.filter { !$0.isDone }
    }

    private var overdueCount: Int {
        openItems.filter {
            guard let dueDate = $0.dueDate else { return false }
            return dueDate < Date() && !Calendar.current.isDateInToday(dueDate)
        }.count
    }

    private var dueTodayCount: Int {
        openItems.filter {
            guard let dueDate = $0.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate)
        }.count
    }

    private var completionRate: Double {
        guard !items.isEmpty else { return 0 }
        return Double(items.filter(\.isDone).count) / Double(items.count)
    }

    private var focusItem: TodoItem? {
        openItems.sorted(by: focusSort).first
    }

    private var displayedItems: [TodoItem] {
        let filtered = items.filter { item in
            let statusMatches: Bool
            switch statusFilter {
            case .all:
                statusMatches = true
            case .active:
                statusMatches = !item.isDone
            case .today:
                statusMatches = {
                    guard !item.isDone, let dueDate = item.dueDate else { return false }
                    return Calendar.current.isDateInToday(dueDate)
                }()
            case .overdue:
                statusMatches = {
                    guard !item.isDone, let dueDate = item.dueDate else { return false }
                    return dueDate < Date() && !Calendar.current.isDateInToday(dueDate)
                }()
            case .done:
                statusMatches = item.isDone
            }

            let priorityMatches = priorityFilter.matches(item.priority)
            let dueDateMatches = !onlyWithDueDate || item.dueDate != nil
            return statusMatches && priorityMatches && dueDateMatches
        }

        switch sortOption {
        case .focus:
            return filtered.sorted(by: focusSort)
        case .dueDate:
            return filtered.sorted(by: dueDateSort)
        case .priority:
            return filtered.sorted(by: prioritySort)
        case .title:
            return filtered.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }

    private var displayedItemIDs: [UUID] {
        displayedItems.map(\.id)
    }

    var body: some View {
        NavigationStack {
            List {
                if !items.isEmpty {
                    Section {
                        if let focusItem, let focusBinding = binding(for: focusItem.id) {
                            NavigationLink {
                                TodoDetailView(item: focusBinding)
                            } label: {
                                FocusNowView(focusItem: focusItem)
                            }
                            .buttonStyle(.plain)
                            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        } else {
                            FocusNowView(focusItem: nil)
                                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        }

                        FocusDashboardView(
                            overdueCount: overdueCount,
                            dueTodayCount: dueTodayCount,
                            completionRate: completionRate,
                            isOverdueActive: statusFilter == .overdue,
                            isTodayActive: statusFilter == .today,
                            onTapOverdue: {
                                statusFilter = (statusFilter == .overdue) ? .all : .overdue
                                priorityFilter = .all
                            },
                            onTapToday: {
                                statusFilter = (statusFilter == .today) ? .all : .today
                                priorityFilter = .all
                            }
                        )
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    }
                }

                Section("Задачи") {
                    ForEach(displayedItemIDs, id: \.self) { itemID in
                        if let itemBinding = binding(for: itemID) {
                            NavigationLink {
                                TodoDetailView(item: itemBinding)
                            } label: {
                                TodoRowView(item: itemBinding.wrappedValue)
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                            .alignmentGuide(.listRowSeparatorTrailing) { dimensions in
                                dimensions[.listRowSeparatorTrailing]
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    itemBinding.wrappedValue.isDone.toggle()
                                } label: {
                                    Label(
                                        itemBinding.wrappedValue.isDone ? "Вернуть" : "Выполнено",
                                        systemImage: itemBinding.wrappedValue.isDone ? "arrow.uturn.backward.circle" : "checkmark.circle"
                                    )
                                }
                                .tint(itemBinding.wrappedValue.isDone ? .orange : .green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteItem(withID: itemID)
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteDisplayedItems)
                }
            }
            .navigationTitle("To-Do Notes")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Menu {
                            ForEach(StatusFilter.allCases) { filter in
                                Button {
                                    statusFilter = filter
                                } label: {
                                    if statusFilter == filter {
                                        Label(filter.rawValue, systemImage: "checkmark")
                                    } else {
                                        Text(filter.rawValue)
                                    }
                                }
                            }
                        } label: {
                                Text("Статус")
                                Text(statusFilter.rawValue)
                        }

                        Menu {
                            ForEach(PriorityFilter.allCases) { filter in
                                Button {
                                    priorityFilter = filter
                                } label: {
                                    if priorityFilter == filter {
                                        Label(filter.rawValue, systemImage: "checkmark")
                                    } else {
                                        Text(filter.rawValue)
                                    }
                                }
                            }
                        } label: {
                                Text("Приоритет")
                                Text(priorityFilter.rawValue)
                        }

                        Menu {
                            ForEach(SortOption.allCases) { option in
                                Button {
                                    sortOption = option
                                } label: {
                                    if sortOption == option {
                                        Label(option.rawValue, systemImage: "checkmark")
                                    } else {
                                        Text(option.rawValue)
                                    }
                                }
                            }
                        } label: {
                                Text("Сортировка")
                                Text(sortOption.rawValue)
                        }

                        Button {
                            onlyWithDueDate.toggle()
                        } label: {
                            if onlyWithDueDate {
                                Label("Только со сроком", systemImage: "checkmark")
                            } else {
                                Text("Только со сроком")
                            }
                        }

                        Divider()

                        Button("Сбросить фильтры") {
                            resetFilters()
                        }
                    } label: {
                        Label("Фильтр", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }

                ToolbarItem(placement: .automatic) {
                    Button {
                        Task {
                            await TodoNotificationService.requestAuthorizationIfNeeded()
                            await TodoNotificationService.sendTestNotification()
                        }
                    } label: {
                        Label("Тест", systemImage: "bell.badge")
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Добавить", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTodoSheet { newItem in
                    items.insert(newItem, at: 0)
                }
            }
            .task {
                await TodoNotificationService.requestAuthorizationIfNeeded()
                await TodoNotificationService.syncNotifications(for: items)
            }
            .onChange(of: items) { _, updatedItems in
                TodoPersistence.saveItems(updatedItems)
                Task {
                    await TodoNotificationService.syncNotifications(for: updatedItems)
                }
            }
        }
    }

    private func deleteDisplayedItems(at offsets: IndexSet) {
        let idsToDelete = offsets.compactMap { index in
            displayedItemIDs.indices.contains(index) ? displayedItemIDs[index] : nil
        }
        items.removeAll { idsToDelete.contains($0.id) }
    }

    private func deleteItem(withID id: UUID) {
        items.removeAll { $0.id == id }
    }

    private func binding(for id: UUID) -> Binding<TodoItem>? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return $items[index]
    }

    private func resetFilters() {
        statusFilter = .all
        priorityFilter = .all
        sortOption = .focus
        onlyWithDueDate = false
    }

    private func focusSort(lhs: TodoItem, rhs: TodoItem) -> Bool {
        if lhs.priority.rank != rhs.priority.rank {
            return lhs.priority.rank > rhs.priority.rank
        }

        switch (lhs.dueDate, rhs.dueDate) {
        case let (left?, right?):
            return left < right
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        case (nil, nil):
            return lhs.title < rhs.title
        }
    }

    private func dueDateSort(lhs: TodoItem, rhs: TodoItem) -> Bool {
        switch (lhs.dueDate, rhs.dueDate) {
        case let (left?, right?):
            if left != right {
                return left < right
            }
            return lhs.priority.rank > rhs.priority.rank
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        case (nil, nil):
            return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }

    private func prioritySort(lhs: TodoItem, rhs: TodoItem) -> Bool {
        if lhs.priority.rank != rhs.priority.rank {
            return lhs.priority.rank > rhs.priority.rank
        }
        return dueDateSort(lhs: lhs, rhs: rhs)
    }
}

#Preview {
    ContentView()
}
