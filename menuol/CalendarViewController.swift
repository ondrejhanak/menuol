//
//  CalendarViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 08/08/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController, FSCalendarDelegate {

	// MARK: - Properties

	private var calendar: FSCalendar!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		self.calendar = FSCalendar(frame: self.view.bounds)
		self.view.addSubview(self.calendar)
	}

	// MARK: – FSCalendarDelegate

	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		self.dismiss(animated: true, completion: nil)
	}

}
