
import UIKit

class RecordViewController: UIViewController {
  
  // MARK: UI
  
  private let rewardLabel: UILabel = {
    let label = UILabel()
    label.text = "칭찬해주세요 ↑"
    label.textColor = .black
    label.backgroundColor = .white
    label.font = .systemFont(ofSize: 12, weight: .heavy)
    return label
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 24
    view.backgroundColor = #colorLiteral(red: 0.4474043121, green: 0.7858899112, blue: 0.7191998518, alpha: 1)
    return view
  }()
  
  private let petImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let dateImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "time"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.text = "산책 날짜"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    return label
  }()
  private let dateDisplayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .black
    return label
  }()
  
  private let startImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "time"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  private let startLabel: UILabel = {
    let label = UILabel()
    label.text = "산책 시작 시간"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    return label
  }()
  private let startDisplayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .black
    return label
  }()
  
  private let totalImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "time")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  private let totalLabel: UILabel = {
    let label = UILabel()
    label.text = "총 산책 시간"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    return label
  }()
  private let totalDisplayLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .black
    return label
  }()
  
  // MARK: Property
  
  private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()
  
  var walkInfo: Walk?
  var pet: Pet?

  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super .viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    rewardAni()
  }
  private func rewardAni() {
    let divide: Double = 6
    let duration: Double = Double(1) / divide
    UIView.animateKeyframes(
      withDuration: 3,
      delay: 0,
      options: [.calculationModeLinear, .repeat],
      animations: {
        for index in 0..<Int(divide) {
          UIView.addKeyframe(withRelativeStartTime: duration * Double(index),
                             relativeDuration: duration) {
                              if index.isMultiple(of: 2) { self.rewardLabel.center.y += 16 }
                              else { self.rewardLabel.center.y -= 16 }
          }
        }
      }
    )
  }
  
  // MARK: Initialize
  
  func setupUI() {
    view.backgroundColor = .white
    petImage.image = UIImage(named: pet!.breed)
    
    let walkDate = self.walkInfo!.date.components(separatedBy: " ")
    dateDisplayLabel.text = walkDate.first!
    startDisplayLabel.text = walkDate.last!
    
    let duration = Int(self.walkInfo!.duration)!
    totalDisplayLabel.text = "\(duration / 60)분 \(duration % 60)초"
    
    setupNavigationBar()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    let dissMissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style:  .done, target: self, action: #selector(dissMissButtonAction))
    navigationItem.rightBarButtonItem = dissMissButton
    navigationItem.rightBarButtonItem?.tintColor = .darkGray
    navigationController?.clearBar()
  }
  
  private struct UI {
    static let paddingX: CGFloat = 16
    static let paddingY: CGFloat = 24
    static let spacing: CGFloat = 16
    static let imageSize: CGFloat = 32
  }
  private func setupConstraints() {
    
    // Subviews from Root View
    
    [self.rewardLabel, self.contentView].forEach { self.view.addSubview($0) }
    
    let guide = self.view.safeAreaLayoutGuide
    self.rewardLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.rewardLabel.topAnchor.constraint(equalTo: guide.topAnchor),
      self.rewardLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX),
    ])
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.contentView.topAnchor.constraint(equalTo: self.rewardLabel.bottomAnchor, constant: UI.paddingY),
      self.contentView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: UI.paddingX),
      self.contentView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -UI.paddingX),
      self.contentView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -UI.paddingY),
    ])
    
    // Subviews from Content View
    
    [self.petImage,
     self.dateImage, self.dateLabel, self.dateDisplayLabel,
     self.startImage, self.startLabel, self.startDisplayLabel,
     self.totalImage, self.totalLabel, self.totalDisplayLabel].forEach { self.contentView.addSubview($0) }
    
    self.petImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.petImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: UI.paddingY + UI.spacing),
      self.petImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      self.petImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
    ])
    
    // Walk Info Display //
    
    self.dateImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.dateImage.topAnchor.constraint(equalTo: self.petImage.bottomAnchor, constant: UI.spacing * 2),
      self.dateImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: UI.paddingX),
      self.dateImage.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.dateImage.heightAnchor.constraint(equalToConstant: UI.imageSize),
    ])
    
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.dateLabel.centerYAnchor.constraint(equalTo: self.dateImage.centerYAnchor),
      self.dateLabel.leadingAnchor.constraint(equalTo: self.dateImage.trailingAnchor, constant: UI.spacing / 2),
    ])
    
    self.dateDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.dateDisplayLabel.centerYAnchor.constraint(equalTo: self.dateImage.centerYAnchor),
      self.dateDisplayLabel.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      self.dateDisplayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -UI.paddingX),
    ])
    
    self.startImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.startImage.topAnchor.constraint(equalTo: self.dateImage.bottomAnchor, constant: UI.spacing * 2),
      self.startImage.leadingAnchor.constraint(equalTo: self.dateImage.leadingAnchor),
      self.startImage.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.startImage.heightAnchor.constraint(equalToConstant: UI.imageSize),
    ])
    
    self.startLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.startLabel.centerYAnchor.constraint(equalTo: self.startImage.centerYAnchor),
      self.startLabel.leadingAnchor.constraint(equalTo: self.startImage.trailingAnchor, constant: UI.spacing / 2),
    ])
    
    self.startDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.startDisplayLabel.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      self.startDisplayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -UI.paddingX),
      self.startDisplayLabel.centerYAnchor.constraint(equalTo: self.startImage.centerYAnchor),
    ])
    
    self.totalImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.totalImage.topAnchor.constraint(equalTo: self.self.startImage.bottomAnchor, constant: UI.spacing * 2),
      self.totalImage.leadingAnchor.constraint(equalTo: self.dateImage.leadingAnchor),
      self.totalImage.widthAnchor.constraint(equalToConstant: UI.imageSize),
      self.totalImage.heightAnchor.constraint(equalToConstant: UI.imageSize),
    ])
    
    self.totalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.totalLabel.centerYAnchor.constraint(equalTo: self.totalImage.centerYAnchor),
      self.totalLabel.leadingAnchor.constraint(equalTo: self.totalImage.trailingAnchor, constant: 8),
    ])
    
    self.totalDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.totalDisplayLabel.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor),
      self.totalDisplayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -UI.paddingX),
      self.totalDisplayLabel.centerYAnchor.constraint(equalTo: self.totalImage.centerYAnchor),
    ])
    
  }
  
  @objc func dissMissButtonAction() {
    presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
}
