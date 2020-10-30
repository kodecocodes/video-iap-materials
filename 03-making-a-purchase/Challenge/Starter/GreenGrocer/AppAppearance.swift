/*
 * Copyright (c) 2015 Razeware LLC
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

extension UIColor {
  static var ggGreen : UIColor {
    return UIColor(red: 127/255.0, green: 148/255.0, blue: 49/255.0, alpha: 1.0)
  }
  
  static var ggDarkGreen : UIColor {
    return UIColor(red: 48/255.0, green: 56/255.0, blue: 19/255.0, alpha: 1.0)
  }
}


func applyAppAppearance() {
  styleNavBar()
  styleTabBar()
  styleTabBarItem()
  styleTintColor()
}


private func styleNavBar() {
  let appearanceProxy = UINavigationBar.appearance()
  appearanceProxy.barTintColor = UIColor.ggDarkGreen
  let font = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)
  
  appearanceProxy.titleTextAttributes = [
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName            : font
  ]
}

private func styleTabBar() {
  let appearanceProxy = UITabBar.appearance()
  appearanceProxy.barTintColor = UIColor.ggDarkGreen
}

private func styleTintColor() {
  let appearanceProxy = UIView.appearance()
  appearanceProxy.tintColor = UIColor.ggGreen
}

private func styleTabBarItem() {
  let appearanceProxy = UITabBarItem.appearance()
  appearanceProxy.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Selected)
  appearanceProxy.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.ggGreen], forState: .Normal)
}
