//
//  AllListsVC.swift
//  Checklists
//
//  Created by Emin Roblack on 10/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class AllListsVC: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  var dataModel: DataModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Enable large titles
    navigationController?.navigationBar.prefersLargeTitles = true
    // Load data
  }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = makeCell(for: tableView)
    
    let checklist = dataModel.lists[indexPath.row]
    cell.textLabel?.text = checklist.name
    cell.accessoryType = .detailDisclosureButton
    
    return cell
  }
  
  func makeCell(for: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
      return cell
    } else {
      return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    dataModel.indexOfSelectedChecklist = indexPath.row
    
    let checklist = dataModel.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as? Checklist
    } else if segue.identifier == "AddChecklist" {
      
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
      
    }
  }
  
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    dataModel.lists.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard?.instantiateViewController(withIdentifier: "ListsDetailViewController") as! ListDetailViewController
    
    controller.delegate = self
    
    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    
    navigationController?.pushViewController(controller, animated: true)
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    
    navigationController?.delegate = self
    let index = dataModel.indexOfSelectedChecklist
    
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
  }

  // Navigation Delegates
  func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool) {
    
    // Was the back button tapped?
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
  
  
}
