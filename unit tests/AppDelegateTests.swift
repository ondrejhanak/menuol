//
//  AppDelegateTests.swift
//  unit tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import XCTest
@testable import menuol

final class AppDelegateTests: XCTestCase {

	func testDelegate() {
		let application = UIApplication.shared
		let delegate = AppDelegate()
		let result = delegate.application(application, didFinishLaunchingWithOptions: nil)
		XCTAssertTrue(result)
		XCTAssertNotNil(delegate.window?.rootViewController)
	}

}
