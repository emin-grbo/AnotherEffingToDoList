//
//  Checklist.swift
//  Checklists
//
//  Created by Emin Roblack on 10/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
  var name = ""
  var items = [ChecklistItem]()
  
  init(name: String) {
    self.name = name
    super.init()
  }
}

