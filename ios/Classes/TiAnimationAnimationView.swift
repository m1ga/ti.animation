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

  var _animationView: AnimationView!
  
  private func animationView() -> AnimationView {
    if _animationView == nil {
      let file = TiUtils.stringValue(proxy.value(forKey: "file"))
      let jsonString = TiUtils.stringValue(proxy.value(forKey: "jsonString"))
      let autoStart = (proxy as! TiAnimationAnimationViewProxy).autoStart
      let speed = TiUtils.floatValueSwift((proxy as! TiAnimationAnimationViewProxy).speed)
      let loop = (proxy as! TiAnimationAnimationViewProxy).loop
      let contentMode: Int? = Int(TiUtils.intValue(proxy.value(forKey: "contentMode")))

      // Case A: Handle JSON file references (either from the packaged app or from the application cache
      if let file = file, file.hasSuffix(".json") {
        guard let dictionary = loadAnimationFrom(JSON: file) else {
          fatalError("Cannot find file!")
        }
        
        _animationView = AnimationView(animation: try! Animation(dictionary: dictionary))
      // Case B: Handle JSON strings
      } else if let jsonString = jsonString {
        let data = jsonString.data(using: .utf8)
        if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
          _animationView = AnimationView(animation: try! Animation(dictionary: jsonData))
        }
      }
            
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
      
      if let speed = speed {
        setSpeed(speed: speed)
      }
      
      _animationView.frame = bounds
      addSubview(_animationView)
      
      // Creation only: Loop mode
      if (loop) {
        _animationView.loopMode = .loop
      }
      
      // Creation only: Auto start
      if autoStart {
        play(with: nil)
      }
    }

    return _animationView
  }
 
  @objc
  private func didClickView(_ sender: UIGestureRecognizer) {
    guard let proxy = proxy else {
      return
    }

    if proxy._hasListeners("click") {
      proxy.fireEvent("click")
    }
  }
  
  private func processCompleteEvent(with callback: KrollCallback?, animationFinished: Bool) {
    guard let proxy = proxy else {
      return
    }

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
    var data: Data? = nil
    var fileString = file
    
    // Handle file document data directory
    if let documentsDirectoryURL = URL(string: file) {
      data = try? Data(contentsOf: documentsDirectoryURL, options: .mappedIfSafe)
    }

    // Handle bundled files
    if data == nil {
      // Handle both "file.json" and "file"
      if fileString.hasSuffix(".json") {
        let url = URL(string: file)
        fileString = url!.deletingPathExtension().absoluteString
      }
      
      let filePath = Bundle.main.url(forResource: fileString, withExtension: "json")
      data = try? Data(contentsOf: filePath!)
      
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
    }
    
    return try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
  }
  
  func initializeView() {
    let _ = animationView()
  }

  public override func frameSizeChanged(_ frame: CGRect, bounds: CGRect) {
    super.frameSizeChanged(frame, bounds: bounds)
    if let animationView = _animationView {
      animationView.frame = bounds
    }
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
  
  func frame() -> Float {
    return Float(animationView().currentFrame)
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
