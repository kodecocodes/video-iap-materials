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

class PurchaseShoppingListCreditsViewController: UIViewController, IAPContainer, DataStoreOwner {
  
  
  @IBOutlet var offerLabels: [UILabel]!
  @IBOutlet var buyButtons: [UIButton]!
  
  var purchaseCompletedOrCancelled: (() -> ())?
  var iapHelper: IAPHelper? {
    didSet {
      if let iapHelper = iapHelper {
        availableProducts = extractAvailableProducts(iapHelper)
      }
      prepareContent()
    }
  }
  var dataStore: DataStore?
  
  private var availableProducts = [SKProduct]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleIAPPurchase:", name: IAPHelper.IAPHelperPurchaseNotification, object: nil)
    prepareContent()
  }
  
  
  @IBAction func handleBuyPressed(sender: UIButton) {
    guard let productIndex = buyButtons.indexOf(sender) else { return }
    let product = availableProducts[productIndex]
    iapHelper?.buyProduct(product)
  }
  
  
  @IBAction func handleCancelPressed(sender: AnyObject) {
    finishWithPurchaseVC()
  }
  
  func handleIAPPurchase(notification: NSNotification) {
    if let productID = notification.object as? String
      where availableProducts.map({ $0.productIdentifier }).contains(productID) {
        dataStore?.purchaseNewShoppingLists(productID)
    }
    finishWithPurchaseVC()
  }
}


extension PurchaseShoppingListCreditsViewController {
  
  private func extractAvailableProducts(helper: IAPHelper) -> [SKProduct] {
    // Get hold of the ones available to buy
    let shoppingListProductIds = [
      GreenGrocerPurchase.NewShoppingLists_One,
      GreenGrocerPurchase.NewShoppingLists_Five,
      GreenGrocerPurchase.NewShoppingLists_Ten
      ].map { $0.productId }
    
    return helper.availableProducts.filter {
      shoppingListProductIds.contains($0.productIdentifier)
      }.sort { $0.0.price.compare($0.1.price) == .OrderedAscending }
  }
  
  private func prepareContent() {
    // Check we have the correct number of items
    if availableProducts.count != offerLabels?.count
      || availableProducts.count != buyButtons?.count { return }
    
    // Prepare a price formatter
    let priceFormatter = NSNumberFormatter()
    priceFormatter.numberStyle = .CurrencyStyle
    
    for (label, product) in zip(offerLabels, availableProducts) {
      priceFormatter.locale = product.priceLocale
      label.text = product.localizedTitle + "\n" + priceFormatter.stringFromNumber(product.price)!
    }
  }
  
  private func finishWithPurchaseVC() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    purchaseCompletedOrCancelled?()
  }
}


