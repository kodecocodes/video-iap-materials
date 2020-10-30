/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import StoreKit
import IAPReceiptVerifier

class ViewController: UIViewController {
  @IBOutlet weak var bundleIdentifier: UILabel!
  @IBOutlet weak var bundleVersion: UILabel!
  @IBOutlet weak var expirationDate: UILabel!
  @IBOutlet weak var verificationStatus: UILabel!
  @IBOutlet weak var buyButton: UIButton!
  @IBOutlet weak var iapTableView: UITableView!
  @IBOutlet weak var receiptCreationDate: UILabel!
  @IBOutlet weak var originalAppVersion: UILabel!
  
  // Receipt
  var receipt: Receipt?
  var verifier: IAPReceiptVerifier?
  
  // Store
  public static let storeItem1 = "<STORE-ITEM>"
  public static let storeItem2 = "<STORE-ITEM>"
  private static let productIdentifiers: Set<ProductIdentifier> = [ViewController.storeItem1, ViewController.storeItem2]
  public static let store = IAPHelper(productIds: ViewController.productIdentifiers)
  var products: [SKProduct] = []
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .medium
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set table delegate
    iapTableView.dataSource = self

    // Set up store if payments allowed
    if IAPHelper.canMakePayments() {
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(purchaseMade(notification:)),
                                             name: Notification.Name("IAPHelperPurchaseNotification"),
                                             object: nil)

      ViewController.store.requestProducts { (success, products) in
        if success {
          self.products = products!
          DispatchQueue.main.async {
            self.buyButton.isEnabled = true
          }
        }
      }
    }
    
    // If a receipt is present validate it, otherwise request to refresh it
    if Receipt.isReceiptPresent() {
      validateReceipt()
    } else {
      refreshReceipt()
    }
  }
  
  func refreshReceipt() {
    verificationStatus.text = "Requesting refresh of receipt."
    verificationStatus.textColor = .green
    print("Requesting refresh of receipt.")
    let refreshRequest = SKReceiptRefreshRequest()
    refreshRequest.delegate = self
    refreshRequest.start()
  }
  
  func formatDateForUI(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
  
  func validateReceipt() {
    verificationStatus.text = "Validating Receipt..."
    verificationStatus.textColor = .green
    
    let url = URL(string: "https://in-app-purchase-validator.herokuapp.com/verify")!
    let publicKey = "MIIBCgKCAQEAsCSlr7017NTSGP2A2qoa0Gbd4oYvxGcTS0jfVJoUcxALD+1Rdj5gnzPDkr7DyD8UeXTgGt5s3sV9A1BLmAas1L7nL5UOUykJcKPdesd22toRXIeMas2sRYaseUJ5JsXqTDYkvzkGeX1i0QOQar6DgtJDk/zimslF93g+dzRSI9UAHx1od7YRnnLXU9+CG6NVElqvVHFPUFu7zWqIUbCCVmf/BG9WjdGyHoaK4d5GPrGeQL+j2VRv6U/qmMQ2pv8wph5pZPV6ve9vC8THdrgQ01cPutsfOQaMT/QOMvO4AnqnejVhNd8zYQL1AmCYiSC2CI+faI7JTyJvW2K5D8nBFQIDAQAB"
    verifier = IAPReceiptVerifier(url: url, base64EncodedPublicKey: publicKey)
    if let verifier = verifier {
      verifier.verify {
        myReceipt in
        guard let receipt = myReceipt else {
          return
        }
        print(receipt)
      }
    }
    
    receipt = Receipt()
    if let receiptStatus = receipt?.receiptStatus {
      verificationStatus.text = receiptStatus.rawValue
      guard receiptStatus == .validationSuccess else {
        // If verification didn't succeed, then show status in red and clear other fields
        verificationStatus.textColor = .red
        bundleIdentifier.text = ""
        bundleVersion.text = ""
        expirationDate.text = ""
        originalAppVersion.text = ""
        receiptCreationDate.text = ""
        return
      }
      
      // If verification succeed, we show information contained in the receipt
      verificationStatus.textColor = .green
      bundleIdentifier.text = "Bundle Identifier: \(receipt!.bundleIdString!)"
      bundleVersion.text = "Bundle Version: \(receipt!.bundleVersionString!)"
      
      if let originalVersion = receipt?.originalAppVersion {
        originalAppVersion.text = "Original Version: \(originalVersion)"
      } else {
        originalAppVersion.text = "Not Provided"
      }
      
      if let receiptExpirationDate = receipt?.expirationDate {
        expirationDate.text = "Expiration Date: \(formatDateForUI(receiptExpirationDate))"
      } else {
        expirationDate.text = "Not Provided."
      }
      
      if let receiptCreation = receipt?.receiptCreationDate {
        receiptCreationDate.text = "Receipt Creation Date: \(formatDateForUI(receiptCreation))"
      } else {
        receiptCreationDate.text = "Not Provided."
      }
      
      iapTableView.reloadData()
    }
  }
  
  // MARK: - Buttons
  @IBAction func buyButtonTouched(_ sender: Any) {
    let alert = UIAlertController(title: "Select Purchcase",
                                  message: "Choose the item you wish to purchase",
                                  preferredStyle: .actionSheet)

    for product in products {
      alert.addAction(UIAlertAction(title: product.localizedTitle, style: .default) { _ in
        ViewController.store.buyProduct(product)
      })
    }

    alert.addAction(UIAlertAction(title: "Restore Purchases", style: .default) { _ in
      ViewController.store.restorePurchases()
    })

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(alert, animated: true)
  }
  
  @IBAction func restoreButtonTouched(_ sender: Any) {
    ViewController.store.restorePurchases()
  }
  
  @IBAction func refreshReceiptTouched(_ sender: Any) {
    refreshReceipt()
  }

  // MARK: - Notification Handler
  @objc func purchaseMade(notification: NSNotification) {
  }
}

// MARK: - SKRequestDelegate extension
extension ViewController: SKRequestDelegate {
  func requestDidFinish(_ request: SKRequest) {
    if Receipt.isReceiptPresent() {
      print("Verifying newly refreshed receipt.")
      validateReceipt()
    }
  }
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    verificationStatus.text = error.localizedDescription
    verificationStatus.textColor = .red
  }
}

// MARK: - UITableViewDataSource extension
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "In App Purchases in Receipt"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let iapItems = receipt?.inAppReceipts {
      return iapItems.count
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IAPCell", for: indexPath) as! IAPTableViewCell
    guard let iapItem = receipt?.inAppReceipts[indexPath.row] else {
      cell.productIdentifier.text = "Unknown"
      cell.purchaseDate.text = ""
      return cell
    }
    
    cell.productIdentifier.text = iapItem.productIdentifier ?? "Unknown"
    if let date = iapItem.purchaseDate {
      cell.purchaseDate.text = dateFormatter.string(from: date)
    } else {
      cell.purchaseDate.text = ""
    }
    return cell
  }
}
