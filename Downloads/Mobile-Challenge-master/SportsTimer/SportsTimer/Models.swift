//
//  ActivitiesModel.swift
//  SportsTimer
//
//  Created by Eann Tuan on 4/5/21.
//

import Foundation

struct Result: Codable {
  var activities: [Activity]
  var instructors: [Instructor]
  var materials: [Material]
}

struct Activity: Codable {
  var id: Int
  var order: Int
  var instructorId: Int
  var materialId: Int
  var durationSeconds: Int
  var durationMS: Int {
    return durationSeconds*100
  }
  
  // Because activity is optional in the SportsTimerViewController, I wanted a way to create an
  // "empty" Activity, and determine that there are no more true activities based on the -1 id.
  // Not sure if this is the best way to do that, but I wanted to avoid any index out of bounds errors
  init() {
    self.id = -1
    self.order = -1
    self.instructorId = -1
    self.materialId = -1
    self.durationSeconds = 0
  }
}

struct Material: Codable {
  var id: Int
  var name: String
}

struct Instructor: Codable {
  var givenName: String
  var id: Int
  var familyName: String
}

struct ActivityInfo {
  var activity: Activity
  var id: Int
  var name: String
  var instructorName: String
  
  init(activity: Activity) {
    self.activity = activity
    self.id = activity.id
    self.name = ActivitiesManager.shared.materialsDict[activity.materialId]?.uppercased() ?? ""
    self.instructorName = ActivitiesManager.shared.instructorsDict[activity.instructorId]?.uppercased() ?? ""
  }
}

enum ActivityType: String {
  case current
  case upcoming
}
