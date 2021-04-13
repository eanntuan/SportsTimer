//
//  ActivitiesManager.swift
//  SportsTimer
//
//  Created by Eann Tuan on 4/5/21.
//

import Foundation

class ActivitiesManager: NSObject {

  static let shared = ActivitiesManager()
  
  var activities: [Activity] = []
  var instructors: [Instructor] = []
  var materials: [Material] = []
  
  // Dictionary to easily determine if there are multiple activities to be performed at the same time
  var orderDict: [Int: [Activity]] = [:]
  
  // Dictionaries to index info to display for UILabels
  var activitiesDict: [Int: Activity] = [:]
  var materialsDict: [Int: String] = [:]
  var instructorsDict: [Int: String] = [:]
  
  func setup() {
    readLocalFile(forName: "mock") { result in
      if let result = result {
        self.activities = result.activities.sorted(by: { $0.order < $1.order })
        self.instructors = result.instructors
        self.materials = result.materials
        
        for a in self.activities {
          if var val = self.orderDict[a.order] {
            val.append(a)
            self.orderDict[a.order] = val
          } else {
            self.orderDict[a.order ] = [a]
          }
        }
        self.activitiesDict = result.activities.reduce(into: [Int: Activity]()) {
          $0[$1.id] = $1
        }
        self.materialsDict = result.materials.reduce(into: [Int: String]()) {
          $0[$1.id] = $1.name
        }
        self.instructorsDict = result.instructors.reduce(into: [Int: String]()) {
          $0[$1.id] = "\($1.givenName) \($1.familyName.prefix(1))."
        }
      }
    }
  }
  
  private func readLocalFile(forName name: String, completion: @escaping (Result?) -> Void) {
      do {
          if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
              let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            do {
                let data = try JSONDecoder.defaultDecoder.decode(Result.self, from: jsonData as Data)
                completion(data)
            } catch {
                print("\(#function) \(#line) \(error)")
            }
          }
      } catch {
          print(error)
      }
  }
}

extension JSONEncoder {
    static let defaultEncoder = JSONEncoder(dateEncodingStrategy: .iso8601)
    convenience init(dateEncodingStrategy: DateEncodingStrategy) {
        self.init()
        self.keyEncodingStrategy = .convertToSnakeCase
        self.dateEncodingStrategy = dateEncodingStrategy
    }
}

extension JSONDecoder {
    static let defaultDecoder = JSONDecoder(dateDecodingStrategy: .iso8601)
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}
