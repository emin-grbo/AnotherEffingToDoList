//
//  AddItemVC.swift
//  Checklists
//
//  Created by Emin Roblack on 10/17/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
  
  func addItemViewControllerDidCancel(_ controller: AddItemVC)
  func addItemViewController(_ controller: AddItemVC, didFinishAdding item: ChecklistItem)
  func addItemViewController(_ controller: AddItemVC, didFinishEditing item: ChecklistItem)
  
}

class AddItemVC: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBTN: UIBarButtonItem!
  
  weak var delegate: AddItemViewControllerDelegate?
  
  var itemToEdit: ChecklistItem?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBTN.isEnabled = true
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    textField.becomeFirstResponder()
  }
  
  @IBAction func done(_ sender: Any) {
    
    if let itemToEdit = itemToEdit {
      itemToEdit.text = textField.text!
      delegate?.addItemViewController(self, didFinishEditing: itemToEdit)
    } else {
    
    let newItem = ChecklistItem(text: textField.text!, checked: false)
    delegate?.addItemViewController(self, didFinishAdding: newItem)
    }
    
  }
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in:oldText)!
    let newText = oldText.replacingCharacters(in: stringRange,
                                              with: string)

    doneBTN.isEnabled = !newText.isEmpty

    return true
  }
  
}
