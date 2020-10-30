/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

let expirationDateKey = "ExpirationDate"
let remainingKey = "Remaining"
let lastRandomIndexKey = "LastRandomIndex"

class UserSettings {

  // MARK: - Properties
  static let shared = UserSettings()

  init() {
  }

  public var expirationDate: Date? {
    set {
      UserDefaults.standard.set(newValue, forKey: expirationDateKey)
    }
    get {
      return UserDefaults.standard.object(forKey: expirationDateKey) as? Date
    }
  }

  public var randomRemaining: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: "remaining")
    }
    get {
      return UserDefaults.standard.integer(forKey: "remaining")
    }
  }

  public var lastRandomIndex: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: "lastRandomIndex")
    }
    get {
      return UserDefaults.standard.integer(forKey: "lastRandomIndex")
    }
  }

  public func increaseRandomExpirationDate(by months: Int) {
    let lastDate = expirationDate ?? Date()
    let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
    expirationDate = newDate
  }

  public func increaseRandomRemaining(by times: Int) {
    let lastTimes = (randomRemaining < 0) ? 0 : randomRemaining
    randomRemaining = lastTimes + times
  }
}
