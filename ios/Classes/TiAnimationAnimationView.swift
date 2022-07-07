//
//  TiAnimationAnimationView.swift
//  ti.animation
//
//  Created by Hans Knöchel
//  Copyright (c) 2022 Hans Knöchel. All rights reserved.
//

import TitaniumKit
import Lottie

@objc(TiAnimationAnimationView)
public class TiAnimationAnimationView : TiUIView {

  private var _animationView: AnimationView!
  
  private func animationView() -> AnimationView {
    if _animationView == nil {
      let file = TiUtils.stringValue(proxy.value(forKey: "file"))
      let autoStart = TiUtils.boolValue(proxy.value(forKey: "autoStart"))
      let contentMode: Int? = Int(TiUtils.intValue(proxy.value(forKey: "contentMode")))

      guard var file = file else {
        NSLog("[ERROR] Missing required \"file\" parameter")
        fatalError("")
      }
      
      // Handle both "file.json" and "file"
      if file.hasSuffix(".json") {
        let url = URL(string: file)
        file = url!.deletingPathExtension().absoluteString
      }
      
      _animationView = AnimationView(animation: try! Animation(dictionary: loadAnimationFrom(JSON: file)!))
      _animationView.frame = bounds
      
      // Enable click-events
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didClickView))
      _animationView.addGestureRecognizer(tapGestureRecognizer)
      
      // Handle content mode
      if let contentMode = contentMode {
        let validContentModes: [UIView.ContentMode] = [.scaleAspectFit, .scaleAspectFill]
        if let nativeContentMode = UIView.ContentMode(rawValue: contentMode), validContentModes.contains(nativeContentMode) {
          _animationView.contentMode = nativeContentMode
        }
      } else {
        _animationView.contentMode = .scaleAspectFit
      }
      
      addSubview(_animationView)
      
      if autoStart {
        play(with: nil)
      }
    }

    return _animationView
  }
 
  @objc
  private func didClickView(_ sender: UIGestureRecognizer) {
    if proxy._hasListeners("click") {
      proxy.fireEvent("click")
    }
  }
  
  private func processCompleteEvent(with callback: KrollCallback?, animationFinished: Bool) {
    if proxy._hasListeners("complete") {
      proxy.fireEvent("complete", with: ["animatonFinished": true])
    }
    
    guard let callback = callback else {
      return
    }
    
    let propertiesDict = ["finished": animationFinished]
    callback.call([propertiesDict], thisObject: proxy)
  }
  
  private func loadAnimationFrom(JSON file: String) -> [String: Any]? {
    let filePath = Bundle.main.path(forResource: file, ofType: nil)
    var data = try? Data(contentsOf: URL(string: filePath!)!)
    
    if data == nil {
      NSLog("[ERROR] The specified file \"\(file)\" could not be loaded. Trying absolute path")
      data = try? Data(contentsOf: URL(string: file)!)
      
      if data == nil {
        NSLog("[ERROR] The specified file \"\(file)\" could not be loaded again. Trying absolute path")
        return nil
      } else {
        NSLog("[INFO] Loading file \(file)")
      }     
    }
    
    return try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
  }

  public override func frameSizeChanged(_ frame: CGRect, bounds: CGRect) {
    super.frameSizeChanged(frame, bounds: bounds)
    _animationView.frame = bounds
  }
}

// MARK: Public APIs

extension TiAnimationAnimationView {
  
  func play(with completionHandler: KrollCallback?) {
    animationView().play { animationFinished in
      self.processCompleteEvent(with: completionHandler, animationFinished: animationFinished)
    }
  }
  
  func play(_ fromFrame: Float, toFrame: Float, completionHandler: KrollCallback?) {
    animationView().play(fromFrame: AnimationFrameTime(fromFrame),
                         toFrame: AnimationFrameTime(toFrame)) { animationFinished in
      self.processCompleteEvent(with: completionHandler, animationFinished: animationFinished)
    }
  }
  
  // TODO: Expose to module in next major, because we need to break the 3 parameters into a dictionary to be more flexible
  func play(_ fromProgress: Float, toProgress: Float, completionHandler: KrollCallback?) {
    animationView().play(fromProgress: AnimationProgressTime(fromProgress),
                         toProgress: AnimationProgressTime(fromProgress)) { animationFinished in
      self.processCompleteEvent(with: completionHandler, animationFinished: animationFinished)
    }
  }
  
  func pause() {
    animationView().pause()
  }
  
  func stop() {
    animationView().stop()
  }
  
  func add(view: UIView, toLayer: String) {
    let animationSubview = AnimationSubview(frame: view.frame)
    animationSubview.addSubview(view)
    
    animationView().addSubview(animationSubview, forLayerAt: AnimationKeypath(keypath: toLayer))
  }
  
  func isPlaying() -> Bool {
    animationView().isAnimationPlaying
    
  }
  
  func duration() -> Float {
    NSLog("[ERROR] The \"duration\" property has been removed from the native library")
    return 0.0
  }
  
  func progress() -> Float {
    return Float(animationView().currentProgress)
  }
  
  func speed() -> Float {
    return Float(animationView().animationSpeed)
  }
  
  func loop() -> Bool {
    return animationView().loopMode == .loop
  }
  
  func setProgress(progress: Float) {
    animationView().currentProgress = CGFloat(progress)
  }
  
  func setSpeed(speed: Float) {
    animationView().animationSpeed = CGFloat(speed)
  }
  
  func setLoop(loop: Bool) {
    animationView().loopMode = loop ? .loop : .playOnce
  }
  
  func setCacheEnabled(cacheEnabled: Bool) {
    NSLog("[ERROR] The \"cache\" property has been removed from the native library")
  }
  
  func cacheEnabled() -> Bool {
    NSLog("[ERROR] The \"cache\" property has been removed from the native library")
    
    return false
  }
}
