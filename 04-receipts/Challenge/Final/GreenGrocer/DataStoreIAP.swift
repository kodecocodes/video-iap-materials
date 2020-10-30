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

import Foundation

private let ShoppingListCreditCountKey = "ShoppingListCreditCount"

extension DataStore {
  private(set) var shoppingListCredits: Int {
    get {
      return readNumberShoppingListCredits()
    }
    set(newValue) {
      writeNumberShoppingListCredits(newValue)
    }
  }
  
  func purchaseNewShoppingLists(productID: String) {
    guard let product = GreenGrocerPurchase(productId: productID) else { return }
    var numberOfShoppingListsToAdd: Int
    switch product {
    case .NewShoppingLists_One:
      numberOfShoppingListsToAdd = 1
    case .NewShoppingLists_Five:
      numberOfShoppingListsToAdd = 5
    case .NewShoppingLists_Ten:
      numberOfShoppingListsToAdd = 10
    default:
      numberOfShoppingListsToAdd = 0
    }
    
    shoppingListCredits += numberOfShoppingListsToAdd
  }
  
  func spendShoppingListCredit() {
    shoppingListCredits -= 1
  }
  
  private func readNumberShoppingListCredits() -> Int {
    return NSUserDefaults.standardUserDefaults().integerForKey(ShoppingListCreditCountKey)
  }
  
  private func writeNumberShoppingListCredits(number: Int) {
    NSUserDefaults.standardUserDefaults().setInteger(number, forKey: ShoppingListCreditCountKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
}
