//
//  WatchyGPSApp.swift
//  WatchyGPS WatchKit Extension
//
//  Created by Ben Goldberg on 7/13/22.
//

import SwiftUI

@main
struct WatchyGPSApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
