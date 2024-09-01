import SwiftUI
import UserNotifications

@main
struct ScheduleTextApp: App {
    var body: some Scene {
        WindowGroup {
            MessageSchedulerView()
        }
    }
}

struct MessageSchedulerView: View {
    @State private var phoneNumber = ""
    @State private var message = ""
    @State private var scheduledDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .padding()
            
            TextEditor(text: $message)
                .border(Color.gray, width: 1)
                .padding()
                .frame(height: 150)
            
            DatePicker("Schedule Time", selection: $scheduledDate)
                .padding()
            
            Button("Schedule Message") {
                scheduleMessage()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    func scheduleMessage() {
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Message"
        content.body = "Send a message to \(phoneNumber): \(message)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: scheduledDate.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting permission: \(error)")
            }
        }
    }
}

