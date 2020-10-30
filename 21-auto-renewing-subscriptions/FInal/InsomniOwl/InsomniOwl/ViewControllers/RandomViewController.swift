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

import UIKit

class RandomViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var lblExpiration: UILabel!
  @IBOutlet weak var btnRandom: UIButton!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    resetGUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    refresh()
  }

  func resetGUI() {
    lblExpiration.text = "No owls, Expired!"
    imageView.image = nil
    btnRandom.isHidden = true
  }

  func refresh() {
    guard OwlProducts.paidUp() else {
      resetGUI()
      return
    }
    btnRandom.isHidden = false
    var index = 0
    let count = OwlProducts.randomImages.count - 1
    repeat {
      index = Int.random(in: 0...count)
    } while index == UserSettings.shared.lastRandomIndex
    
    imageView.image = OwlProducts.randomImages[index]
    UserSettings.shared.lastRandomIndex = index
    
    if OwlProducts.daysRemaininOnSubscription() > 0 {
      lblExpiration.text = OwlProducts.getExpiryDateString()
    } else {
      lblExpiration.text = "Owls Remaining: \(UserSettings.shared.randomRemaining)"
      UserSettings.shared.randomRemaining = UserSettings.shared.randomRemaining - 1
      if UserSettings.shared.randomRemaining <= 0 {
        OwlProducts.setRandomProduct(with: false)
      }
    }
    
    
  }
}

// MARK: - IBActions
extension RandomViewController {

  @IBAction func btnRandomPressed(_ sender: UIButton) {
    refresh()
  }
}
