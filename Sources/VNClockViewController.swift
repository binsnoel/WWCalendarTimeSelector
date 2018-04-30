//
//  VNClockViewController.swift
//  VNClock
//
//  Created by Vince Edgar Noel on 27/04/2018.
//  Copyright © 2018 binsnoel. All rights reserved.
//

import UIKit

@objc public final class VNCalendarTimeSelectorStyle: NSObject {
  fileprivate(set) public var showDateMonth: Bool = true
  fileprivate(set) public var showMonth: Bool = false
  fileprivate(set) public var showYear: Bool = true
  fileprivate(set) public var showTime: Bool = true
  fileprivate var isSingular = false
  
  public func showDateMonth(_ show: Bool) {
    showDateMonth = show
    showMonth = show ? false : showMonth
    if show && isSingular {
      showMonth = false
      showYear = false
      showTime = false
    }
  }
  
  public func showMonth(_ show: Bool) {
    showMonth = show
    showDateMonth = show ? false : showDateMonth
    if show && isSingular {
      showDateMonth = false
      showYear = false
      showTime = false
    }
  }
  
  public func showYear(_ show: Bool) {
    showYear = show
    if show && isSingular {
      showDateMonth = false
      showMonth = false
      showTime = false
    }
  }
  
  public func showTime(_ show: Bool) {
    showTime = show
    if show && isSingular {
      showDateMonth = false
      showMonth = false
      showYear = false
    }
  }
  
  fileprivate func countComponents() -> Int {
    return (showDateMonth ? 1 : 0) +
      (showMonth ? 1 : 0) +
      (showYear ? 1 : 0) +
      (showTime ? 1 : 0)
  }
  
  fileprivate convenience init(isSingular: Bool) {
    self.init()
    self.isSingular = isSingular
    showDateMonth = false
    showMonth = false
    showYear = false
    showTime = true
  }
}

open class VNClockViewController: UIViewController, VNClockProtocol {
  @IBOutlet weak var selTimeView: UIView!
  @IBOutlet weak var clockView: VNClock!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var amButton: UIButton!
  @IBOutlet weak var pmButton: UIButton!
  
  fileprivate var selTimeStateHour = true
  fileprivate let selAnimationDuration: TimeInterval = 0.4
  fileprivate var selCurrrent: VNCalendarTimeSelectorStyle = VNCalendarTimeSelectorStyle(isSingular: true)
  fileprivate var isFirstLoad = false
  
  open var optionSelectorPanelScaleTime: CGFloat = 2.75
  open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
  open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
  open var optionClockFontColorAMPM = UIColor.darkGray
  open var optionClockFontColorAMPMHighlight = UIColor.darkGray
  open var optionClockBackgroundColorAMPMHighlight = UIColor.groupTableViewBackground
  open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
  open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
  open var optionClockFontColorHour = UIColor.black
  open var optionClockFontColorHourHighlight = UIColor.white
  open var optionClockBackgroundColorHourHighlight = UIColor.lightGray
  open var optionClockBackgroundColorHourHighlightNeedle = UIColor.lightGray
  open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
  open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
  open var optionClockFontColorMinute = UIColor.black
  open var optionClockFontColorMinuteHighlight = UIColor.white
  open var optionClockBackgroundColorMinuteHighlight = UIColor.lightGray
  open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.lightGray
  open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
  open var optionClockBackgroundColorCenter = UIColor.darkGray
  open var optionTimeStep: VNCalendarTimeSelectorTimeStep = .oneMinute
  open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
  open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontTime = UIFont.boldSystemFont(ofSize: 35)
  open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
  open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
  open var optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorDateHighlight = UIColor.white
  open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorYearHighlight = UIColor.white
  open var optionSelectorPanelFontColorTime = UIColor.darkGray
  open var optionSelectorPanelFontColorTimeHighlight = UIColor.darkGray
  open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
  open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
  open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
  
  open static func instantiate() -> VNClockViewController {
    let podBundle = Bundle(for: self.classForCoder())
    let bundleURL = podBundle.url(forResource: "WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
    var bundle: Bundle?
    if let bundleURL = bundleURL {
      bundle = Bundle(url: bundleURL)
    }
    return UIStoryboard(name: "VNClock", bundle: bundle).instantiateInitialViewController() as! VNClockViewController
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    //NotificationCenter.default.addObserver(self, selector: #selector(VNCalendarTimeSelector.didRotateOrNot), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    clockView.delegate = self
    clockView.minuteStep = optionTimeStep
    clockView.backgroundColorClockFace = optionClockBackgroundColorFace
    clockView.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
    clockView.fontAMPM = optionClockFontAMPM
    clockView.fontAMPMHighlight = optionClockFontAMPMHighlight
    clockView.fontColorAMPM = optionClockFontColorAMPM
    clockView.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
    clockView.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
    clockView.fontHour = optionClockFontHour
    clockView.fontHourHighlight = optionClockFontHourHighlight
    clockView.fontColorHour = optionClockFontColorHour
    clockView.fontColorHourHighlight = optionClockFontColorHourHighlight
    clockView.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
    clockView.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
    clockView.fontMinute = optionClockFontMinute
    clockView.fontMinuteHighlight = optionClockFontMinuteHighlight
    clockView.fontColorMinute = optionClockFontColorMinute
    clockView.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
    clockView.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
    clockView.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
    
    updateDate()
    
    isFirstLoad = true
    view.layoutIfNeeded()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if isFirstLoad {
      isFirstLoad = false // Temp fix for i6s+ bug?
      clockView.setNeedsDisplay()
      //self.didRotateOrNot(animated: false)
      showTime(true, animated: false)
      VNClockSwitchAMPM(isAM: true, isPM: false)
    }
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isFirstLoad = false
  }
  
  @IBAction func amClicked(_ sender: Any) {
    VNClockSwitchAMPM(isAM: true, isPM: false)
  }
  @IBAction func pmClicked(_ sender: Any) {
    VNClockSwitchAMPM(isAM: false, isPM: true)
  }
  @IBAction func showTimeClicked(_ sender: Any) {
    showTime(true)
  }
  
  func showTime(_ userTap: Bool, animated: Bool = true) {
    if userTap {
      if selCurrrent.showTime {
        selTimeStateHour = !selTimeStateHour
      }
      else {
        selTimeStateHour = true
      }
    }
    
    if optionTimeStep == .sixtyMinutes {
      selTimeStateHour = true
    }
    
    changeSelTime(animated: animated)
    
    if userTap {
      clockView.showingHour = selTimeStateHour
    }
    clockView.setNeedsDisplay()
    
    if animated {
      UIView.transition(
        with: clockView,
        duration: selAnimationDuration / 2,
        options: [UIViewAnimationOptions.transitionCrossDissolve],
        animations: {
          self.clockView.layer.displayIfNeeded()
      },
        completion: nil
      )
    } else {
      self.clockView.layer.displayIfNeeded()
    }
    
    let animations = {
      self.clockView.alpha = 1
    }
    if animated {
      UIView.animate(
        withDuration: selAnimationDuration,
        delay: 0,
        options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
        animations: animations,
        completion: nil
      )
    } else {
      animations()
    }
  }
  
  fileprivate func changeSelTime(animated: Bool = true) {
    
    
    //timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
    let animations = {
      //self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
      self.view.layoutIfNeeded()
    }
    let completion = { (_: Bool) in
      if self.selCurrrent.showTime {
      }
    }
    if animated {
      UIView.animate(
        withDuration: selAnimationDuration,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
        animations: animations,
        completion: completion
      )
    } else {
      animations()
      completion(true)
    }
    selCurrrent.showTime(true)
    updateDate()
  }
  internal func VNClockGetTime() -> Date {
    return optionCurrentDate
  }
  
  internal func VNClockSwitchAMPM(isAM: Bool, isPM: Bool) {
    var newHour = optionCurrentDate.hour
    if isAM && newHour >= 12 {
      newHour = newHour - 12
    }
    if isPM && newHour < 12 {
      newHour = newHour + 12
    }
    
    optionCurrentDate = optionCurrentDate.change(hour: newHour)
    updateDate()
    //
    if isAM {
      amButton.backgroundColor = optionClockBackgroundColorAMPMHighlight
      pmButton.backgroundColor = UIColor.clear
    } else {
      amButton.backgroundColor = UIColor.clear
      pmButton.backgroundColor = optionClockBackgroundColorAMPMHighlight
    }
    //
    clockView.setNeedsDisplay()
    UIView.transition(
      with: clockView,
      duration: selAnimationDuration / 2,
      options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
      animations: {
        self.clockView.layer.displayIfNeeded()
    },
      completion: nil
    )
  }
  
  //VNClock delegates
  internal func VNClockSetHourMilitary(_ hour: Int) {
    optionCurrentDate = optionCurrentDate.change(hour: hour)
    updateDate()
    clockView.setNeedsDisplay()
  }
  
  internal func VNClockSetMinute(_ minute: Int) {
    optionCurrentDate = optionCurrentDate.change(minute: minute)
    updateDate()
    clockView.setNeedsDisplay()
  }
  
  fileprivate func updateDate() {
    
    let timeText = optionCurrentDate.stringFromFormat("h':'mm").lowercased()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center
    let attrText = NSMutableAttributedString(string: timeText, attributes: [NSFontAttributeName: optionSelectorPanelFontTime, NSForegroundColorAttributeName: optionSelectorPanelFontColorTime, NSParagraphStyleAttributeName: paragraph])
    
    if selCurrrent.showTime {
      
      let colonIndex = timeText.characters.distance(from: timeText.startIndex, to: timeText.range(of: ":")!.lowerBound)
      let hourRange = NSRange(location: 0, length: colonIndex)
      let minuteRange = NSRange(location: colonIndex + 1, length: 2)
      
      if selTimeStateHour {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: hourRange)
      }
      else {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: minuteRange)
      }
    }
    timeLabel.attributedText = attrText
    print(timeLabel)
  }
}


@objc public enum VNCalendarTimeSelectorTimeStep: Int {
  /// 1 Minute interval, but clock will display intervals of 5 minutes.
  case oneMinute = 1
  /// 5 Minutes interval.
  case fiveMinutes = 5
  /// 10 Minutes interval.
  case tenMinutes = 10
  /// 15 Minutes interval.
  case fifteenMinutes = 15
  /// 30 Minutes interval.
  case thirtyMinutes = 30
  /// Disables the selection of minutes.
  case sixtyMinutes = 60
}

internal protocol VNClockProtocol: NSObjectProtocol {
  func VNClockGetTime() -> Date
  func VNClockSwitchAMPM(isAM: Bool, isPM: Bool)
  func VNClockSetHourMilitary(_ hour: Int)
  func VNClockSetMinute(_ minute: Int)
}

class VNClock: UIView {
  
  open weak var delegate: VNClockProtocol!
  internal var backgroundColorClockFace: UIColor!
  internal var backgroundColorClockFaceCenter: UIColor!
  internal var fontAMPM: UIFont!
  internal var fontAMPMHighlight: UIFont!
  internal var fontColorAMPM: UIColor!
  internal var fontColorAMPMHighlight: UIColor!
  internal var backgroundColorAMPMHighlight: UIColor!
  internal var fontHour: UIFont!
  internal var fontHourHighlight: UIFont!
  internal var fontColorHour: UIColor!
  internal var fontColorHourHighlight: UIColor!
  internal var backgroundColorHourHighlight: UIColor!
  internal var backgroundColorHourHighlightNeedle: UIColor!
  internal var fontMinute: UIFont!
  internal var fontMinuteHighlight: UIFont!
  internal var fontColorMinute: UIColor!
  internal var fontColorMinuteHighlight: UIColor!
  internal var backgroundColorMinuteHighlight: UIColor!
  internal var backgroundColorMinuteHighlightNeedle: UIColor!
  
  internal var showingHour = true
  internal var minuteStep: VNCalendarTimeSelectorTimeStep! {
    didSet {
      minutes = []
      let iter = 60 / minuteStep.rawValue
      for i in 0..<iter {
        minutes.append(i * minuteStep.rawValue)
      }
    }
  }
  
  fileprivate let border: CGFloat = 8
  fileprivate let ampmSize: CGFloat = 0
  fileprivate var faceSize: CGFloat = 0
  fileprivate var faceX: CGFloat = 0
  fileprivate let faceY: CGFloat = 8
  fileprivate let amX: CGFloat = 8
  fileprivate var pmX: CGFloat = 0
  fileprivate var ampmY: CGFloat = 0
  fileprivate let numberCircleBorder: CGFloat = 12
  fileprivate let centerPieceSize = 4
  fileprivate let hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
  fileprivate var minutes: [Int] = []
  
  internal override func draw(_ rect: CGRect) {
    
    // update frames
    faceSize = min(rect.width - border * 2, rect.height - border * 2 - ampmSize / 3 * 2)
    faceX = (rect.width - faceSize) / 2
    pmX = rect.width - border - ampmSize
    ampmY = 100 //rect.height - border - ampmSize
    
    let time = delegate.VNClockGetTime()
    let ctx = UIGraphicsGetCurrentContext()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center
    
    ctx?.setFillColor(backgroundColorClockFace.cgColor)
    ctx?.fillEllipse(in: CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
    
    
    /*
     ctx?.setFillColor(backgroundColorAMPMHighlight.cgColor)
     if time.hour < 12 { //AM selected
     ctx?.fill(CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
     var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
     var ampmHeight = fontAMPMHighlight.lineHeight
     str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     
     str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
     ampmHeight = fontAMPM.lineHeight
     str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     }
     else { //PM selected
     ctx?.fill(CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
     var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
     var ampmHeight = fontAMPM.lineHeight
     str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     
     str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
     ampmHeight = fontAMPMHighlight.lineHeight
     str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     }
     */
    if showingHour {
      let textAttr : [String : Any] = [NSFontAttributeName: fontHour, NSForegroundColorAttributeName: fontColorHour, NSParagraphStyleAttributeName: paragraph]
      let textAttrHighlight : [String : Any] = [NSFontAttributeName: fontHourHighlight, NSForegroundColorAttributeName: fontColorHourHighlight, NSParagraphStyleAttributeName: paragraph]
      
      let templateSize = NSAttributedString(string: "12", attributes: textAttr).size()
      let templateSizeHighlight = NSAttributedString(string: "12", attributes: textAttrHighlight).size()
      let maxSize = max(templateSize.width, templateSize.height)
      let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
      let highlightCircleSize = maxSizeHighlight + numberCircleBorder
      let radius = faceSize / 2 - maxSize
      let radiusHighlight = faceSize / 2 - maxSizeHighlight
      
      ctx?.saveGState()
      ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
      
      let degreeIncrement = 360 / CGFloat(hours.count)
      let currentHour = get12Hour(time)
      
      for (index, element) in hours.enumerated() {
        let angle = getClockRad(CGFloat(index) * degreeIncrement)
        
        if element == currentHour {
          // needle
          ctx?.saveGState()
          ctx?.setStrokeColor(backgroundColorHourHighlightNeedle.cgColor)
          ctx?.setLineWidth(2)
          ctx?.move(to: CGPoint(x: 0, y: 0))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleSize / 2) * sin(angle))))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.strokePath()
          ctx?.restoreGState()
          
          // highlight
          ctx?.saveGState()
          ctx?.setFillColor(backgroundColorHourHighlight.cgColor)
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.fillEllipse(in: CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
          ctx?.restoreGState()
          
          // numbers
          let hour = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
          ctx?.saveGState()
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
          hour.draw(at: CGPoint.zero)
          ctx?.restoreGState()
        }
        else {
          // numbers
          let hour = NSAttributedString(string: "\(element)", attributes: textAttr)
          ctx?.saveGState()
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
          hour.draw(at: CGPoint.zero)
          ctx?.restoreGState()
        }
      }
    }
    else {
      let textAttr : [String : Any] = [NSFontAttributeName: fontMinute, NSForegroundColorAttributeName: fontColorMinute, NSParagraphStyleAttributeName: paragraph]
      let textAttrHighlight : [String : Any] = [NSFontAttributeName: fontMinuteHighlight, NSForegroundColorAttributeName: fontColorMinuteHighlight, NSParagraphStyleAttributeName: paragraph]
      let templateSize = NSAttributedString(string: "60", attributes: textAttr).size()
      let templateSizeHighlight = NSAttributedString(string: "60", attributes: textAttrHighlight).size()
      let maxSize = max(templateSize.width, templateSize.height)
      let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
      let minSize: CGFloat = 0
      let highlightCircleMaxSize = maxSizeHighlight + numberCircleBorder
      let highlightCircleMinSize = minSize + numberCircleBorder
      let radius = faceSize / 2 - maxSize
      let radiusHighlight = faceSize / 2 - maxSizeHighlight
      
      ctx?.saveGState()
      ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
      
      let degreeIncrement = 360 / CGFloat(minutes.count)
      let currentMinute = get60Minute(time)
      
      for (index, element) in minutes.enumerated() {
        let angle = getClockRad(CGFloat(index) * degreeIncrement)
        
        if element == currentMinute {
          // needle
          ctx?.saveGState()
          ctx?.setStrokeColor(backgroundColorMinuteHighlightNeedle.cgColor)
          ctx?.setLineWidth(2)
          ctx?.move(to: CGPoint(x: 0, y: 0))
          ctx?.scaleBy(x: -1, y: 1)
          if minuteStep.rawValue < 5 && element % 5 != 0 {
            ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMinSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMinSize / 2) * sin(angle))))
          }
          else {
            ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMaxSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMaxSize / 2) * sin(angle))))
          }
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.strokePath()
          ctx?.restoreGState()
          
          // highlight
          ctx?.saveGState()
          ctx?.setFillColor(backgroundColorMinuteHighlight.cgColor)
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          if minuteStep.rawValue < 5 && element % 5 != 0 {
            ctx?.fillEllipse(in: CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
          }
          else {
            ctx?.fillEllipse(in: CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
          }
          ctx?.restoreGState()
          
          // numbers
          if minuteStep.rawValue < 5 {
            if element % 5 == 0 {
              let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
              ctx?.saveGState()
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
              min.draw(at: CGPoint.zero)
              ctx?.restoreGState()
            }
          }
          else {
            let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
            ctx?.saveGState()
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
            min.draw(at: CGPoint.zero)
            ctx?.restoreGState()
          }
        }
        else {
          // numbers
          if minuteStep.rawValue < 5 {
            if element % 5 == 0 {
              let min = NSAttributedString(string: "\(element)", attributes: textAttr)
              ctx?.saveGState()
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
              min.draw(at: CGPoint.zero)
              ctx?.restoreGState()
            }
          }
          else {
            let min = NSAttributedString(string: "\(element)", attributes: textAttr)
            ctx?.saveGState()
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
            min.draw(at: CGPoint.zero)
            ctx?.restoreGState()
          }
        }
      }
    }
    
    // center piece
    ctx?.setFillColor(backgroundColorClockFaceCenter.cgColor)
    ctx?.fillEllipse(in: CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
    ctx?.restoreGState()
  }
  
  fileprivate func get60Minute(_ date: Date) -> Int {
    return date.minute
  }
  
  fileprivate func get12Hour(_ date: Date) -> Int {
    let hr = date.hour
    return hr == 0 || hr == 12 ? 12 : hr < 12 ? hr : hr - 12
  }
  
  fileprivate func getClockRad(_ degrees: CGFloat) -> CGFloat {
    let radOffset = 90.VNdegreesToRadians // add this number to get 12 at top, 3 at right
    return degrees.VNdegreesToRadians + radOffset
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
      let pt = touch.location(in: self)
      
      // see if tap on AM or PM, making the boundary bigger
      /*
       let amRect = CGRect(x: 0, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
       let pmRect = CGRect(x: bounds.width - ampmSize - border, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
       
       if amRect.contains(pt) {
       delegate.VNClockSwitchAMPM(isAM: true, isPM: false)
       }
       else if pmRect.contains(pt) {
       delegate.VNClockSwitchAMPM(isAM: false, isPM: true)
       }
       else {*/
      touchClock(pt: pt)
      //}
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
      let pt = touch.location(in: self)
      touchClock(pt: pt)
    }
  }
  
  fileprivate func touchClock(pt: CGPoint) {
    let touchPoint = CGPoint(x: pt.x - faceX - faceSize / 2, y: pt.y - faceY - faceSize / 2) // this means centerpoint will be 0, 0
    
    if showingHour {
      let degreeIncrement = 360 / CGFloat(hours.count)
      
      var angle = 180 - atan2(touchPoint.x, touchPoint.y).VNradiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
      if angle < 0 {
        angle = 0
      }
      angle = angle - degreeIncrement / 2
      var index = Int(floor(angle / degreeIncrement)) + 1
      
      if index < 0 || index > (hours.count - 1) {
        index = 0
      }
      
      let hour = hours[index]
      let time = delegate.VNClockGetTime()
      if hour == 12 {
        delegate.VNClockSetHourMilitary(time.hour < 12 ? 0 : 12)
      }
      else {
        delegate.VNClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
      }
    }
    else {
      let degreeIncrement = 360 / CGFloat(minutes.count)
      
      var angle = 180 - atan2(touchPoint.x, touchPoint.y).VNradiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
      if angle < 0 {
        angle = 0
      }
      angle = angle - degreeIncrement / 2
      var index = Int(floor(angle / degreeIncrement)) + 1
      
      if index < 0 || index > (minutes.count - 1) {
        index = 0
      }
      
      let minute = minutes[index]
      delegate.VNClockSetMinute(minute)
    }
  }
}


extension CGFloat {
  var VNdoubleValue:      Double  { return Double(self) }
  var VNdegreesToRadians: CGFloat { return CGFloat(VNdoubleValue * Double.pi / 180) }
  var VNradiansToDegrees: CGFloat { return CGFloat(VNdoubleValue * 180 / Double.pi) }
}

extension Int {
  var VNdoubleValue:      Double  { return Double(self) }
  var VNdegreesToRadians: CGFloat { return CGFloat(VNdoubleValue * Double.pi / 180) }
  var VNradiansToDegrees: CGFloat { return CGFloat(VNdoubleValue * 180 / Double.pi) }
}
