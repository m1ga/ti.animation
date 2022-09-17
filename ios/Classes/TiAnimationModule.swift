//
//  TiAnimationModule.swift
//  ti.animation
//
//  Created by Hans Knöchel
//  Copyright (c) 2022 Hans Knöchel. All rights reserved.
//

import UIKit
import TitaniumKit
import Lottie

@objc(TiAnimationModule)
class TiAnimationModule: TiModule {

  public let testProperty: String = "Hello World"
  
  func moduleGUID() -> String {
    return "a6f82400-49cf-4b2a-8d32-53a1600b1077"
  }
  
  override func moduleId() -> String! {
    return "ti.animation"
  }
  
  @objc var newRenderingEngineEnabled: Any {
    set {
      LottieConfiguration.shared.renderingEngine = newValue as? Bool ?? false ? .coreAnimation : .mainThread
    }
    get {
      return LottieConfiguration.shared.renderingEngine == .coreAnimation
    }
  }
}
