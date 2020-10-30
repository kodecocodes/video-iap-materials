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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var dataStore: DataStore?
  let iapHelper = IAPHelper(prodIds: Set(
    [
      GreenGrocerPurchase.AdRemoval,
      GreenGrocerPurchase.NewShoppingLists_One,
      GreenGrocerPurchase.NewShoppingLists_Five,
      GreenGrocerPurchase.NewShoppingLists_Ten
    ].map { $0.productId }
    ))

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    dataStore = loadDataStore("GreenGrocerSeed")
    
    var dso = window?.rootViewController as? DataStoreOwner
    dso?.dataStore = dataStore
    
    var iapContainer = window?.rootViewController as? IAPContainer
    iapContainer?.iapHelper = iapHelper
    
    // Style the app
    applyAppAppearance()
    

    return true
  }
}

extension AppDelegate {
  private func loadDataStore(seedPlistName: String) -> DataStore? {
    if DataStore.defaultDataStorePresentOnDisk {
      return DataStore()
    } else {
      // Locate seed data
      let seedURL = NSBundle.mainBundle().URLForResource(seedPlistName, withExtension: "plist")!
      let ds = DataStore(plistURL: seedURL)
      // Save seed data to the documents directory
      ds.save()
      return ds
    }
  }
}


