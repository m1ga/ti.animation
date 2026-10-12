//
//  TiAnimationAnimationViewProxy.swift
//  ti.animation
//
//  Created by Hans Knöchel
//  Copyright (c) 2022 Hans Knöchel. All rights reserved.
//

import UIKit
import TitaniumKit

@objc(TiAnimationAnimationViewProxy)
class TiAnimationAnimationViewProxy: TiViewProxy {
  
  var autoStart = false

  var loop = false

  var speed: Float? = 1.0

  var progress: Float? = 0.0

  var cache = false

  override func _init(withProperties properties: [AnyHashable : Any]!) {
    // Read the creation-only flags before the super call: applying the creation
    // properties may already touch the view (e.g. via "setFile:"), and the view reads
    // these values when it is created.
    if let properties = properties {
      autoStart = TiUtils.boolValue("autoStart", properties: properties)
      loop = TiUtils.boolValue("loop", properties: properties)
      cache = TiUtils.boolValue("cache", properties: properties)
      progress = TiUtils.floatValueSwift(properties["progress"])
      speed = TiUtils.floatValueSwift(properties["speed"])
    }

    super._init(withProperties: properties)

    animationView().initializeView()
  }

  private func animationView() -> TiAnimationAnimationView {
    return view as! TiAnimationAnimationView
  }
  
  // MARK: Public APIs
  // MARK: - Methods
  
  @objc(start:)
  func start(params: [Any]?) {
    guard let params = params else {
      animationView().play(with: nil)
      return
    }

    if params.count == 1 {
      let callback = params.first as? KrollCallback
      animationView().play(with: callback)
    } else if params.count >= 2 {
      let startFrame = TiUtils.floatValueSwift(params[0]) ?? 0.0
      let endFrame = TiUtils.floatValueSwift(params[1]) ?? 0.0
      let callback = params.count > 2 ? params[2] as? KrollCallback : nil

      animationView().play(startFrame, toFrame: endFrame, completionHandler: callback)
    } else {
      animationView().play(with: nil)
    }
  }
  
  @objc(resume:)
  func resume(params: [Any]?) {
    start(params: nil)
  }
  
  @objc(stop:)
  func stop(params: [Any]?) {
    animationView().stop()
  }
  
  @objc(pause:)
  func pause(params: [Any]?) {
    animationView().pause()
  }
  
  // MARK: - Properties

  @objc(setFile:)
  func setFile(value: Any) {
    guard let file = TiUtils.stringValue(value), !file.isEmpty else {
      NSLog("[ERROR] Invalid value passed to \"file\"")
      return
    }

    replaceValue(file, forKey: "file", notification: false)

    // During creation the view does not exist yet and picks the value up itself
    if viewInitialized() {
      animationView().load(file: file)
    }
  }

  @objc(setJsonString:)
  func setJsonString(value: Any) {
    guard let jsonString = TiUtils.stringValue(value), !jsonString.isEmpty else {
      NSLog("[ERROR] Invalid value passed to \"jsonString\"")
      return
    }

    replaceValue(jsonString, forKey: "jsonString", notification: false)

    if viewInitialized() {
      animationView().load(jsonString: jsonString)
    }
  }

  @objc(setScaleMode:)
  func setScaleMode(value: Any) {
    guard let scaleMode = TiUtils.stringValue(value) else { return }

    replaceValue(scaleMode, forKey: "scaleMode", notification: false)
    if viewInitialized() {
      animationView().setScaleMode(scaleMode)
    }
  }

  @objc(setLoop:)
  func setLoop(value: Any) {
    let loop = TiUtils.boolValue(value)
    self.loop = loop
    if viewInitialized() {
      animationView().setLoop(loop: loop)
    }

    replaceValue(loop, forKey: "loop", notification: false)
  }

  @objc(setProgress:)
  func setProgress(value: Any) {
    let progress = TiUtils.floatValueSwift(value) ?? 0.0
    self.progress = progress
    if viewInitialized() {
      animationView().setProgress(progress: progress)
    }
    
    replaceValue(progress, forKey: "progress", notification: false)
  }
  
  @objc(setSpeed:)
  func setSpeed(value: Any) {
    let speed = TiUtils.floatValueSwift(value) ?? 1.0
    self.speed = speed
    if viewInitialized() {
      animationView().setSpeed(speed: speed)
    }
    
    replaceValue(speed, forKey: "speed", notification: false)
  }

  @objc(setCache:)
  func setCache(value: Any) {
    let cache = TiUtils.boolValue(value)
    self.cache = cache
    if viewInitialized() {
      animationView().setCacheEnabled(cacheEnabled: cache)
    }
    
    replaceValue(cache, forKey: "cache", notification: false)
  }
  
  @objc var isPlaying: Bool {
    return animationView().isPlaying()
  }
  
  @objc var duration: Float {
    return animationView().duration()
  }
  
  @objc var frame: Float {
    return animationView().frame()
  }
  
  // MARK: - Layers
  @objc(addViewToKeypathLayer:)
  func addViewToKeypathLayer(params: [Any]?) {
    guard let params = params?.first as? [String: Any] else {
      return
    }
    
    let viewProxy = params["view"] as? TiViewProxy
    let keypathLayer = params["layer"] as? String
    
    guard let viewProxy = viewProxy, let keypathLayer = keypathLayer else {
      return
    }
    
    remember(viewProxy)
    animationView().add(view: viewProxy.view, toLayer: keypathLayer)
  }
}

// MARK: Utils

extension TiUtils {
  
  class func floatValueSwift(_ value: Any?) -> Float? {
    if let number = value as? NSNumber {
      return number.floatValue
    } else if let floatValue = value as? Float {
      return floatValue
    } else if let doubleValue = value as? Double {
      return Float(doubleValue)
    } else if let stringValue = value as? String {
      return Float(stringValue)
    }

    return nil
  }
}
