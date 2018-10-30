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
  
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  
  @IBOutlet weak var datePickerCell: UITableViewCell!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  weak var delegate: AddItemViewControllerDelegate?
  
  var itemToEdit: ChecklistItem?
  var dueDate = Date()
  var datePicjerVisible = false
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBTN.isEnabled = true
      shouldRemindSwitch.isOn = item.shouldRemind
      dueDate = item.dueDate
    }
    
    updateDueDateLabel()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    textField.becomeFirstResponder()
  }
  
  @IBAction func done(_ sender: Any) {
    
    if let itemToEdit = itemToEdit {
      itemToEdit.text = textField.text!
      delegate?.addItemViewController(self, didFinishEditing: itemToEdit)
      
      itemToEdit.shouldRemind = shouldRemindSwitch.isOn
      itemToEdit.dueDate = dueDate
      
    } else {
      
      let newItem = ChecklistItem(text: textField.text!, checked: false)
      delegate?.addItemViewController(self, didFinishAdding: newItem)
      
      itemToEdit?.shouldRemind = shouldRemindSwitch.isOn
      itemToEdit?.dueDate = dueDate
      
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
  
  
  
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
  
  func showDatePicker() {
    datePicjerVisible = true
    
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                             numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePicjerVisible {
      return 3
    } else {
      return super.tableView(tableView,
                             numberOfRowsInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                             didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    textField.resignFirstResponder()
    
    if indexPath.section == 1 && indexPath.row == 1 {
      showDatePicker()
    }
  }
  
  
  
}
