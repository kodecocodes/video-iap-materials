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

class CreateShoppingListViewController: UIViewController, DataStoreOwner {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var tableView: UITableView!
  
  var selectedProducts = Set<Product>()
  
  var dataStore : DataStore? {
    didSet {
      tableView?.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    configureTableView(tableView)
  }
}

extension CreateShoppingListViewController {
  private func configureTableView(tableView: UITableView) {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
  }
}

extension CreateShoppingListViewController {
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "completeShoppingListCreation",
      let shoppingList = createNewShoppingList() {
        dataStore?.addShoppingList(shoppingList)
    }
  }
  
  private func createNewShoppingList() -> ShoppingList? {
    guard let name = nameTextField?.text,
      let date = datePicker?.date where !name.isEmpty else {
        return nil
    }
    return ShoppingList(name: name, date: date, products: Array(selectedProducts))
  }
}


extension CreateShoppingListViewController : UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataStore?.products.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath)
    if let cell = cell as? SelectableProductTableViewCell,
      let product = dataStore?.products[indexPath.row] {
        cell.product = product
        cell.setSelected(selectedProducts.contains(product), animated: false)
    }
    return cell
  }
}

extension CreateShoppingListViewController : UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let product = dataStore?.products[indexPath.row] {
      selectedProducts.insert(product)
    }
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    if let product = dataStore?.products[indexPath.row] {
      selectedProducts.remove(product)
    }
  }
}


