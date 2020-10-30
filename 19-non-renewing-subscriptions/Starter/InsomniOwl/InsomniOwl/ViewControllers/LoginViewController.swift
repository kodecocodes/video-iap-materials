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

class LoginViewController: UIViewController {

  // MARK: - Properties
  let showDetailSegueIdentifier = "loginSuccessful"

  // MARK: - IBOutlets
  @IBOutlet weak var txtUser: UITextField!
  @IBOutlet weak var txtPassword: UITextField!
  @IBOutlet weak var btnLogin: UIButton!
  @IBOutlet weak var btnSignUp: UIButton!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.performSegue(withIdentifier: self.showDetailSegueIdentifier, sender: self)
    setupNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    txtUser.text = ""
    txtPassword.text = ""
  }
  
  func validateUserEntry() -> Bool {
    
    var valid = true
    var message = ""
    if txtUser.text == "" {
      valid = false
      message = "Please enter a username."
    } else if txtPassword.text == "" {
      valid = false
      message = "Please enter a password."
    }
    
    if !valid {
      let alert = UIAlertController(title: "Invalid Login", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      return false
    }
    
    return true
  }

  func setupNavigationBar() {
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.tintColor = .white
  }

  // MARK: - IBActions
  @IBAction func btnLogInPressed(_ sender: UIButton) {
    guard validateUserEntry() else { return }

    btnLogin.isEnabled = false
    btnSignUp.isEnabled = false
    self.performSegue(withIdentifier: self.showDetailSegueIdentifier, sender: self)
  }
  
  @IBAction func btnSignUpPressed(_ sender: UIButton) {
    guard validateUserEntry() else { return }

  }
}
