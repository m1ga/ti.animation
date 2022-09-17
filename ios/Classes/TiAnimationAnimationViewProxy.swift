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
  
  override func _init(withProperties properties: [AnyHashable : Any]!) {
    super._init(withProperties: properties)
    
    autoStart = TiUtils.boolValue("autoStart", properties: properties)
    loop = TiUtils.boolValue("loop", properties: properties)
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
      let startFrame = params.first as? Float ?? 0.0
      let endFrame = params[1] as? Float ?? 0.0
      let callback = params[2] as? KrollCallback
      
      animationView().play(startFrame, toFrame: endFrame, completionHandler: callback)
    } else {
      NSLog("[ERROR] Unhandled number of arguments!")
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
  
  @objc var progress: Any? {
    set {
      let progress = newValue as? Float ?? 0.0
      animationView().setProgress(progress: progress)
      
      replaceValue(progress, forKey: "progress", notification: false)
    }
    get {
      return animationView().progress()
    }
  }
  
  @objc var speed: Any? {
    set {
      let speed = newValue as? Float ?? 0.0
      animationView().setSpeed(speed: speed)
      
      replaceValue(speed, forKey: "speed", notification: false)

    }
    get {
      return animationView().speed()
    }
  }

  @objc lazy var loop: Bool = {
    return animationView().loop()
  }()

  @objc var cache: Any {
    set {
      let cache = newValue as? Bool ?? false
      animationView().setCacheEnabled(cacheEnabled: cache)
    }
    get {
      return animationView().cacheEnabled()
    }
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
