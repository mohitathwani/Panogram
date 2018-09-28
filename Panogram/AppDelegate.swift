//
//  AppDelegate.swift
//  Panogram
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().titleTextAttributes =
      [NSAttributedStringKey.foregroundColor: UIColor(hex: 0x191919),
       NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold",
                                          size: 20)!]
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}
