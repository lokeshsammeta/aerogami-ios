//
//  ApplicationLoader.swift
//  TravelApplication
//
//  Created by Povilas Staskus on 9/26/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

// swiftlint:disable force_cast
// swiftlint:disable force_try

import UIKit
import Swinject

class ApplicationLoader {
    public let assembler: Assembler
    public var window: UIWindow?
    
    init() {
        self.assembler = AssemblerFactory().create()
    }
    
    // Start the application loading sequence
    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        loadRootViewController()
    }
    
    private func loadRootViewController() {
        let rootViewController = assembler.resolver.resolve(ViewController.self)
        window = assembler.resolver.resolve(UIKit.UIWindow.self)!
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}