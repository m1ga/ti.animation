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
  
  @objc(setProgress:)
  func setProgress(params: Any?) {
    let progress = params as? Float ?? 0.0
    animationView().setProgress(progress: progress)
    
    replaceValue(progress, forKey: "progress", notification: false)
  }
  
  @objc(progress)
  func progress() -> Float {
    return animationView().progress()
  }
  
  @objc(setSpeed:)
  func setSpeed(params: Any?) {
    let speed = params as? Float ?? 0.0
    animationView().setSpeed(speed: speed)
    
    replaceValue(speed, forKey: "speed", notification: false)
  }
  
  @objc(speed)
  func speed() -> Float {
    return animationView().speed()
  }
  
  @objc(setLoop:)
  func setLoop(params: Any?) {
    let loop = params as? Bool ?? false
    animationView().setLoop(loop: loop)
    
    replaceValue(loop, forKey: "loop", notification: false)
  }
  
  @objc(loop)
  func loop() -> Bool {
    return animationView().loop()
  }
  
  @objc(setCache:)
  func setCache(params: Any?) {
    let cache = params as? Bool ?? false
    animationView().setCacheEnabled(cacheEnabled: cache)
  }
  
  @objc(cache)
  func cache() -> Bool {
    return animationView().cacheEnabled()
  }
  
  @objc(isPlaying)
  func isPlaying() -> Bool {
    return animationView().isPlaying()
  }
  
  @objc(duration)
  func duration() -> Float {
    return animationView().duration()
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
  
  // MARK: - Convert
  // TODO: Add APIs
  
  // MARK: - Dynamic Properties
  // TODO: Add APIs

}
