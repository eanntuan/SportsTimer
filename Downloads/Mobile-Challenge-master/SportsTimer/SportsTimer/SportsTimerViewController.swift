//
//  SportsTimerViewController.swift
//  SportsTimer
//
//  Created by Eann Tuan on 4/5/21.
//

import Foundation
import UIKit

class SportsTimerViewController: UIViewController {
  
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var msLabel: UILabel!
  @IBOutlet weak var changeGroupsLabel: UILabel!
  @IBOutlet weak var pauseDrillLabel: UILabel!
  
  @IBOutlet weak var pausedBannerView: UIView!
  @IBOutlet weak var upcomingActivitiesStackView: UIStackView!
  @IBOutlet weak var currentActivitiesStackView: UIStackView!
  @IBOutlet weak var pauseImageView: UIImageView!
  @IBOutlet weak var playImageView: UIImageView!
  @IBOutlet weak var stopImageView: UIImageView!
  @IBOutlet weak var pauseView: UIView!
  
  @IBOutlet weak var resumeView: UIView!
  @IBOutlet weak var startStopView: UIView!
  @IBOutlet weak var endPracticeLabel: UILabel!
  
  var currentActivities: [Activity] = []
  var upcomingActivities: [Activity] = []
  var currentActivity: Activity?
  
  var timer: Timer?
  var isRunning: Bool = false
  var counter = 0
  var isLastActivity = false
  var orderId: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getActivities()
    configureUI()
    
    let displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
    displayLink.add(to: .current, forMode: .common)
  }
  
  func configureUI() {
    getActivities()
    if let activity = currentActivity {
      configureTimerLabel(activity.durationMS)
    }
    
    updateState()
    
    // Dynamically create the stack view of activity name and instructor name
    updateActivitiesUI(for: currentActivities, type: .current)
    updateActivitiesUI(for: upcomingActivities, type: .upcoming)
    
    startStopView.layer.cornerRadius = self.startStopView.bounds.height/2
    startStopView.layer.borderColor = AppColors.darkPurple.cgColor
    startStopView.layer.borderWidth = 5
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPressed(tapGestureRecognizer:)))
    playImageView.isUserInteractionEnabled = true
    playImageView.addGestureRecognizer(tapGestureRecognizer)
    
    let stopTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopPressed(tapGestureRecognizer:)))
    stopImageView.isUserInteractionEnabled = true
    stopImageView.addGestureRecognizer(stopTapGestureRecognizer)
    
    let pauseTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pausePressed(tapGestureRecognizer:)))
    startStopView.isUserInteractionEnabled = true
    startStopView.addGestureRecognizer(pauseTapGestureRecognizer)
  }
  
  func updateActivitiesUI(for activities: [Activity], type: ActivityType) {
    
    for activity in activities {
      let activityInfo = ActivityInfo(activity: activity)
      
      let stack = UIStackView()
      stack.axis = .vertical
      let nameLabel = UILabel()
      nameLabel.text = activityInfo.name
      nameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
      
      let instructorLabel = UILabel()
      instructorLabel.text = activityInfo.instructorName
      instructorLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
      instructorLabel.textColor = UIColor.darkGray
      [nameLabel, instructorLabel].forEach{ stack.addArrangedSubview($0) }
      
      switch type {
      case .current:
        currentActivitiesStackView.addArrangedSubview(stack)
      case .upcoming:
        upcomingActivitiesStackView.addArrangedSubview(stack)
      }
    }
  }
  
  func configureTimerLabel(_ timeMs: Int) {
    if timeMs > 99 {
      let seconds = timeMs/100
      let ms = timeMs - (seconds*100)
      secondsLabel.text = String(format: "%02d", seconds)
      msLabel.text = String(format: "%02d", ms)
    } else {
      secondsLabel.text = "00"
      msLabel.text = String(format: "%02d", timeMs)
    }
  }
  
  func updateState() {
    pauseView.isHidden = !isRunning
    resumeView.isHidden = isRunning
    pausedBannerView.isHidden = isRunning
    isLastActivity ? displayEndPractice() : nil
  }

  func displayEndPractice() {
    pauseDrillLabel.isHidden = true
    endPracticeLabel.isHidden = false
    pauseImageView.isHidden = true
  }
  
  func getActivities() {
    currentActivities = ActivitiesManager.shared.orderDict[orderId] ?? [Activity()]
    currentActivity = currentActivities.first
    if let activity = currentActivity {
      counter = activity.durationMS
    }
    
    if ActivitiesManager.shared.orderDict.keys.count > orderId {
      upcomingActivities = ActivitiesManager.shared.orderDict[orderId+1] ?? [Activity()]
    } else {
      isLastActivity = true
    }
  }
  
  func clearActivities() {
    for v in currentActivitiesStackView.subviews{
       v.removeFromSuperview()
    }
    for v in upcomingActivitiesStackView.subviews{
       v.removeFromSuperview()
    }
  }
  
  func goToNextActivity() {
    // Go to next activity within the same orderId
    if currentActivities.count > 1 {
      currentActivities.remove(at: 0)
      currentActivity = currentActivities.first
      if let activity = currentActivity {
        counter = activity.durationMS
        configureTimerLabel(counter)
      }
      startTimer()
    } else {
      // Move to next orderId's activity(ies)
      orderId += 1
      clearActivities()
      getActivities()
      updateActivitiesUI(for: currentActivities, type: .current)
      updateActivitiesUI(for: upcomingActivities, type: .upcoming)
      if let activity = currentActivity {
        counter = activity.durationMS
        configureTimerLabel(counter)
      }
    }
    
    if currentActivitiesStackView.subviews.count > 1 && currentActivities.count > 1 {
      changeGroupsLabel.isHidden = false
    } else {
      changeGroupsLabel.isHidden = true
    }
    
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    isRunning = true
    updateState()
  }
  
  func resetTimer() {
    guard let activity = currentActivity else { return }
    timer?.invalidate()
    isRunning = false
    counter = activity.durationMS
    configureTimerLabel(activity.durationMS)
  }
  
  @objc func stopPressed(tapGestureRecognizer: UITapGestureRecognizer) {
    goToNextActivity()
    resetTimer()
    startTimer()
  }
  
  @objc func playPressed(tapGestureRecognizer: UITapGestureRecognizer) {
    if isRunning { return }
    startTimer()
  }
  
  @objc func updateTimer() {
    guard timer != nil else { return }
    if counter != 0 {
      counter = counter - 1
    } else if upcomingActivities.first?.id == -1 {
      displayEndPractice()
    } else {
      goToNextActivity()
    }
    configureTimerLabel(counter)
  }
  
  @objc func pausePressed(tapGestureRecognizer: UITapGestureRecognizer) {
    timer?.invalidate()
    timer = nil
    isRunning = false
    if upcomingActivities.first?.id == -1 {
      displayEndPracticeAlert()
    } else {
      updateState()
    }
  }
  
  func displayEndPracticeAlert() {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: "Congrats!",
                                                message: "Make sure to tell the kids good job and to clean up. :)",
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Let's eat lunch!", style: .default)
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }
  }
}
