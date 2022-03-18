import UIKit

protocol HeaderViewDelegate: class {
  func headerView(_ headerView: HeaderView, didPressLeftButton leftButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressRightButton rightButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var rightButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.RightButton.text,
      attributes: LightboxConfig.RightButton.textAttributes)

    var button = UIButton(type: .system)
    
    if let image = LightboxConfig.RightButton.image {
      button = UIButton(type: .custom)
      button.setBackgroundImage(image, for: .normal)
    }

    button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.RightButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(rightButtonDidPress(_:)),
      for: .touchUpInside)
    
    if let tintColor = LightboxConfig.RightButton.tintColor {
      button.tintColor = tintColor
    }

    button.isHidden = !LightboxConfig.RightButton.enabled
    button.accessibilityIdentifier = LightboxConfig.RightButton.accessibilityIdentifier
    
    return button
  }()

  open fileprivate(set) lazy var leftButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.LeftButton.text,
      attributes: LightboxConfig.LeftButton.textAttributes)

    var button = UIButton(type: .system)
    
    if let image = LightboxConfig.LeftButton.image {
      button = UIButton(type: .custom)
      button.setBackgroundImage(image, for: .normal)
    }
    
    button.setAttributedTitle(title, for: .normal)
    
    if let size = LightboxConfig.LeftButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(leftButtonDidPress(_:)),
      for: .touchUpInside)
    
    if let tintColor = LightboxConfig.LeftButton.tintColor {
      button.tintColor = tintColor
    }

    button.isHidden = !LightboxConfig.LeftButton.enabled
    button.accessibilityIdentifier = LightboxConfig.LeftButton.accessibilityIdentifier
    
    return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [rightButton, leftButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func leftButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressLeftButton: button)
  }

  @objc func rightButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressRightButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    rightButton.frame.origin = CGPoint(
      x: bounds.width - rightButton.frame.width - 17,
      y: topPadding
    )

    leftButton.frame.origin = CGPoint(
      x: 17,
      y: topPadding
    )
  }
}
