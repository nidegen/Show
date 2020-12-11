//
//  TestApp.swift
//  Test
//
//  Created by Nicolas Degen on 11.11.20.
//

import SwiftUI

@main
struct TestApp: App {
  @Environment(\.scenePhase) private var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) { (newScenePhase) in
      switch newScenePhase {
      case .active:
        print("scene is now active!")
      case .inactive:
        print("scene is now inactive!")
      case .background:
        print("scene is now in the background!")
      @unknown default:
        print("Apple must have added something new!")
      }
    }
  }
}
