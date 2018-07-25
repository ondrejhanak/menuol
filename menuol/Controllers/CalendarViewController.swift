//
//  CalendarViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 08/08/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import FSCalendar
import PureLayout

final class CalendarViewController: UIViewController, FSCalendarDelegate {

	// MARK: - Properties

	public var date = Date()
	public var callback: ((Date) -> Void)?
	private var calendar: FSCalendar!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		self.calendar = FSCalendar(frame: .zero)
		self.calendar.delegate = self
		self.calendar.select(self.date)
		self.view.addSubview(self.calendar)
		self.calendar.autoPinEdgesToSuperviewEdges()
	}

	// MARK: – FSCalendarDelegate

	public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		if let callback = self.callback {
			callback(date)
		}
		self.dismiss(animated: true, completion: nil)
	}

}
