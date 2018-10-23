//
//  DataModel.swift
//  Checklists
//
//  Created by Emin Roblack on 10/22/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  
  
  // MARK: - Save/LOAD
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent(
      "Checklists.plist")
  }
  
  // this method is now called saveChecklists()
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      // You encode lists instead of "items"
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath(),
                     options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array!")
    }
  }
  
  
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        // You decode to an object of [Checklist] type to lists
        lists = try decoder.decode([Checklist].self, from: data)
      } catch {
        print("Error decoding item array!")
      }
    }
  }
  
  func registerDefaults() {
    let dictionary: [String : Any] = [ "ChecklistIndex": -1,
                                       "First Time": true]
    
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  
  // Selected Index
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(
        forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue,
                                forKey: "ChecklistIndex")
    }
  }
  
  // FIRST TIME
  
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
  
  if firstTime {
  let checklist = Checklist(name: "List")
    lists.append(checklist)
    
    indexOfSelectedChecklist = 0
    userDefaults.set(false, forKey: "FirstTime")
    userDefaults.synchronize()
  }
  }
  
  
}
