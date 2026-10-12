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

  var _animationView: LottieAnimationView!

  /// Set while an animation is loaded asynchronously (e.g. from a remote URL) so
  /// `autoStart` can kick in once the animation is available.
  private var pendingAutoStart = false

  /// Incremented for every load request so a slow async load cannot override a newer one.
  private var loadGeneration = 0

  private func animationView() -> LottieAnimationView {
    if _animationView == nil {
      let animationProxy = proxy as? TiAnimationAnimationViewProxy
      let autoStart = animationProxy?.autoStart ?? false
      let speed = animationProxy?.speed
      let loop = animationProxy?.loop ?? false
      let contentMode = proxy.value(forKey: "contentMode")

      // Always create the native view first, even if no (valid) source was passed yet.
      // The animation itself is assigned afterwards, so a missing or invalid "file" /
      // "jsonString" logs an error instead of crashing the app.
      let animationView = LottieAnimationView(animation: nil)
      _animationView = animationView

      // Enable click-events
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didClickView))
      animationView.addGestureRecognizer(tapGestureRecognizer)

      // Handle content mode (iOS: "contentMode" as UIViewContentMode, cross-platform: "scaleMode" string)
      animationView.contentMode = .scaleAspectFit
      if contentMode != nil {
        let validContentModes: [UIView.ContentMode] = [.scaleAspectFit, .scaleAspectFill]
        if let nativeContentMode = UIView.ContentMode(rawValue: Int(TiUtils.intValue(contentMode))),
           validContentModes.contains(nativeContentMode) {
          animationView.contentMode = nativeContentMode
        }
      }
      if let scaleMode = TiUtils.stringValue(proxy.value(forKey: "scaleMode")) {
        setScaleMode(scaleMode)
      }

      if let speed = speed {
        animationView.animationSpeed = CGFloat(speed)
      }

      // Creation only: Loop mode
      animationView.loopMode = loop ? .loop : .playOnce

      animationView.frame = bounds
      addSubview(animationView)

      // Creation only: Auto start
      pendingAutoStart = autoStart

      // Load the initial source ("file" wins over "jsonString")
      if let file = TiUtils.stringValue(proxy.value(forKey: "file")), !file.isEmpty {
        load(file: file)
      } else if let jsonString = TiUtils.stringValue(proxy.value(forKey: "jsonString")), !jsonString.isEmpty {
        load(jsonString: jsonString)
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
      proxy.fireEvent("complete", with: ["animatonFinished": animationFinished])
    }

    guard let callback = callback else {
      return
    }

    let propertiesDict = ["finished": animationFinished]
    callback.call([propertiesDict], thisObject: proxy)
  }

  // MARK: - Loading

  /// Loads an animation from a bundled file (app/assets), an absolute or file:// path,
  /// or a remote http(s) URL. Supports both Lottie JSON and dotLottie (".lottie") files.
  func load(file: String) {
    let view = animationView()
    loadGeneration += 1
    let generation = loadGeneration

    let lowercased = file.lowercased()
    let isDotLottie = lowercased.hasSuffix(".lottie")

    // Case A: Remote URL
    if lowercased.hasPrefix("http://") || lowercased.hasPrefix("https://") {
      guard let url = URL(string: file) else {
        NSLog("[ERROR] The specified URL \"\(file)\" is invalid")
        return
      }

      if isDotLottie {
        DotLottieFile.loadedFrom(url: url) { [weak self] result in
          DispatchQueue.main.async {
            guard let self = self, self.loadGeneration == generation else { return }
            switch result {
            case .success(let dotLottieFile):
              view.loadAnimation(from: dotLottieFile)
              self.animationDidLoad()
            case .failure(let error):
              NSLog("[ERROR] Could not load dotLottie file from \"\(file)\": \(error.localizedDescription)")
            }
          }
        }
      } else {
        LottieAnimation.loadedFrom(url: url, closure: { [weak self] animation in
          DispatchQueue.main.async {
            guard let self = self, self.loadGeneration == generation else { return }
            guard let animation = animation else {
              NSLog("[ERROR] Could not load animation from \"\(file)\"")
              return
            }
            view.animation = animation
            self.animationDidLoad()
          }
        })
      }
      return
    }

    // Case B: Local file (bundled, absolute path or file:// URL)
    guard let path = resolveLocalPath(for: file) else {
      NSLog("[ERROR] The specified file \"\(file)\" could not be found")
      return
    }

    if path.lowercased().hasSuffix(".lottie") {
      switch DotLottieFile.SynchronouslyBlockingCurrentThread.loadedFrom(filepath: path) {
      case .success(let dotLottieFile):
        view.loadAnimation(from: dotLottieFile)
        animationDidLoad()
      case .failure(let error):
        NSLog("[ERROR] Could not load dotLottie file \"\(file)\": \(error.localizedDescription)")
      }
    } else {
      guard let animation = LottieAnimation.filepath(path) else {
        NSLog("[ERROR] The specified file \"\(file)\" is not a valid Lottie animation")
        return
      }
      view.animation = animation
      animationDidLoad()
    }
  }

  /// Loads an animation from a raw Lottie JSON string.
  func load(jsonString: String) {
    let view = animationView()
    loadGeneration += 1

    guard let data = jsonString.data(using: .utf8) else {
      NSLog("[ERROR] The specified jsonString could not be read")
      return
    }

    do {
      view.animation = try LottieAnimation.from(data: data)
      animationDidLoad()
    } catch {
      NSLog("[ERROR] The specified jsonString is not a valid Lottie animation: \(error.localizedDescription)")
    }
  }

  private func animationDidLoad() {
    guard let animationView = _animationView else { return }
    let animationProxy = proxy as? TiAnimationAnimationViewProxy

    // dotLottie files carry their own loop / speed configuration which Lottie applies
    // while loading, so re-apply the values requested by the developer afterwards.
    if let animationProxy = animationProxy {
      animationView.loopMode = animationProxy.loop ? .loop : .playOnce
      if let speed = animationProxy.speed {
        animationView.animationSpeed = CGFloat(speed)
      }
    }

    // Re-apply the initial progress (if any)
    if let progress = animationProxy?.progress {
      animationView.currentProgress = CGFloat(progress)
    }

    if pendingAutoStart {
      pendingAutoStart = false
      play(with: nil)
    }
  }

  /// Resolves "file.json", "/file.json", "file", "folder/file.lottie", absolute paths and file:// URLs
  /// to an absolute path on disk. Returns nil if nothing exists.
  private func resolveLocalPath(for file: String) -> String? {
    let fileManager = FileManager.default

    // file:// URL
    if file.lowercased().hasPrefix("file://"), let url = URL(string: file) {
      return fileManager.fileExists(atPath: url.path) ? url.path : nil
    }

    // Absolute path (e.g. from Ti.Filesystem)
    if file.hasPrefix("/"), fileManager.fileExists(atPath: file) {
      return file
    }

    // Bundled resource (app/assets or Resources)
    var relativePath = file
    while relativePath.hasPrefix("/") {
      relativePath.removeFirst()
    }

    let nsPath = relativePath as NSString
    let pathExtension = nsPath.pathExtension
    let resourceName = pathExtension.isEmpty ? relativePath : nsPath.deletingPathExtension
    let candidateExtensions = pathExtension.isEmpty ? ["json", "lottie"] : [pathExtension]

    for ext in candidateExtensions {
      if let url = Bundle.main.url(forResource: resourceName, withExtension: ext),
         fileManager.fileExists(atPath: url.path) {
        return url.path
      }
    }

    // Last resort: relative to the resource directory
    if let resourcePath = Bundle.main.resourcePath {
      for ext in candidateExtensions {
        let candidate = (resourcePath as NSString).appendingPathComponent("\(resourceName).\(ext)")
        if fileManager.fileExists(atPath: candidate) {
          return candidate
        }
      }
    }

    return nil
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
                         toProgress: AnimationProgressTime(toProgress)) { animationFinished in
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
    return Float(animationView().animation?.duration ?? 0)
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

  /// Cross-platform scale mode, same values as Android: "center", "centerCrop", "stretch", "centerInside" (default)
  func setScaleMode(_ scaleMode: String) {
    switch scaleMode {
    case "center":
      animationView().contentMode = .center
    case "centerCrop":
      animationView().contentMode = .scaleAspectFill
    case "stretch":
      animationView().contentMode = .scaleToFill
    default:
      animationView().contentMode = .scaleAspectFit
    }
  }

  func setCacheEnabled(cacheEnabled: Bool) {
    NSLog("[ERROR] The \"cache\" property has been removed from the native library")
  }

  func cacheEnabled() -> Bool {
    NSLog("[ERROR] The \"cache\" property has been removed from the native library")

    return false
  }
}
