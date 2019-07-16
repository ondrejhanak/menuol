//
//  AppDelegate.swift
//  menuol
//
//  Created by Ondrej Hanak on 22/08/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

// swiftlint:disable prefixed_toplevel_constant

let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
let delegateClass: AnyClass = NSClassFromString("menuol_unit_tests.TestingAppDelegate") ?? AppDelegate.self
let delegateClassString = NSStringFromClass(delegateClass)

_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassString)
