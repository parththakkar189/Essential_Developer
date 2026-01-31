# SmartAccessibilityWrapperView in SwiftUI

This document provides a guide on implementing a reusable `SmartAccessibilityWrapperView` in SwiftUI for managing accessibility focus in large and complex views, like dashboards. It ensures VoiceOver resumes focus after interacting with sections, modals, or other views, and provides additional accessibility enhancements.

---

## 1. Code for `SmartAccessibilityWrapperView`
This reusable SwiftUI component tracks the last focused item, restores focus during view transitions, and simplifies accessibility management.

```swift
import SwiftUI

/// A wrapper view that enables accessibility, tracks the last focused item, and resumes accessibility focus.
public struct SmartAccessibilityWrapperView<Content: View, Item: Hashable & Codable>: View {
    @ViewBuilder let content: (_ focusState: AccessibilityFocusState<Item?>.Binding) -> Content
    private let storageKey: String

    @SceneStorage("SmartAccessibilityWrapperView.lastFocusedItem") var lastFocusedItemData: Data?
    @AccessibilityFocusState private var focusedItem: Item?

    public init(
        storageKey: String = "SmartAccessibilityWrapperView.lastFocusedItem",
        @ViewBuilder content: @escaping (_ focusState: AccessibilityFocusState<Item?>.Binding) -> Content
    ) {
        self.content = content
        self.storageKey = storageKey
    }

    private var lastFocusedItem: Item? {
        get {
            guard let data = lastFocusedItemData else { return nil }
            return try? JSONDecoder().decode(Item.self, from: data)
        }
        set {
            if let newValue = newValue, let data = try? JSONEncoder().encode(newValue) {
                lastFocusedItemData = data
            } else {
                lastFocusedItemData = nil
            }
        }
    }

    public var body: some View {
        content($focusedItem)
            .onChange(of: focusedItem) { newValue in
                if let item = newValue {
                    lastFocusedItem = item
                }
            }
            .onAppear {
                if let last = lastFocusedItem {
                    focusedItem = last
                }
            }
            .accessibilityElement(children: .contain)
    }
}
```

---

## 2. Using the Wrapper with a Dashboard

The `SmartAccessibilityWrapperView` can be used to manage focus restoration across various dashboard sections.

### Example
Here is how you can implement it in a `DashboardView`:

```swift
struct DashboardView: View {
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        SmartAccessibilityWrapperView { focusState in
            ScrollView {
                VStack(spacing: 20) {
                    // Section 1: Portfolio
                    DashboardSection(
                        title: "Portfolio",
                        buttonAction: {
                            focusState.wrappedValue = "Portfolio"
                            isBottomSheetPresented = true
                        },
                        accessibilityIdentifier: "Portfolio"
                    )

                    // Section 2: Goals
                    DashboardSection(
                        title: "Goals",
                        buttonAction: {
                            focusState.wrappedValue = "Goals"
                            isBottomSheetPresented = true
                        },
                        accessibilityIdentifier: "Goals"
                    )

                    // Section 3: Transactions
                    DashboardSection(
                        title: "Transactions",
                        buttonAction: {
                            focusState.wrappedValue = "Transactions"
                            isBottomSheetPresented = true
                        },
                        accessibilityIdentifier: "Transactions"
                    )
                }
            }
            .sheet(isPresented: $isBottomSheetPresented, onDismiss: {
                // Restore focus upon dismissing the bottom sheet
                if let lastFocused = focusState.wrappedValue {
                    UIAccessibility.post(notification: .layoutChanged, argument: lastFocused)
                }
            }) {
                BottomSheetView()
            }
        }
    }
}
```

---

## 3. Components for Dashboard Sections and Modal

### Dashboard Section Component
You can make each dashboard section modular and reusable:

```swift
struct DashboardSection: View {
    let title: String
    let buttonAction: () -> Void
    let accessibilityIdentifier: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .accessibilityIdentifier(accessibilityIdentifier)
                Spacer()
                Button(action: buttonAction) {
                    Image(systemName: "chevron.down.circle")
                        .accessibilityLabel("Open \(title) details")
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
    }
}
```

### Bottom Sheet Component
Ensure the bottom sheet properly supports accessibility:

```swift
struct BottomSheetView: View {
    var body: some View {
        VStack {
            Text("This is a bottom sheet")
                .font(.title)
                .padding()

            Spacer()

            Button("Close") {
                // Close the sheet programmatically (not shown in this snippet)
            }
            .accessibilityLabel("Close Bottom Sheet")
        }
        .padding()
        .presentationDetents([.medium, .large]) // Define sheet heights
    }
}
```

---

## Features of the Wrapper

1. **Focus Restoration**: Restores focus on the previously focused view after dismissing modals or transitioning.
2. **State Preservation**: Retains the last focused state (e.g., `Portfolio`, `Goals`) even if the app goes to the background.
3. **Modular and Reusable**: Wraps any `View` content and simplifies accessibility code with `AccessibilityFocusState`.
4. **VoiceOver Enhancement**: Ensures consistent navigation in VoiceOver or assistive technologies, improving usability for vision-impaired users.

---

## Conclusion
This `SmartAccessibilityWrapperView` is a modular utility to manage accessibility in SwiftUI dashboards. It encapsulates focus state handling, ensuring accessibility compliance for interactive sections, transitions, and modals.

Feel free to extend this solution further to address additional accessibility needs or dashboard-specific features. Let me know if you have more questions or requirements!