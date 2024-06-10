//
//  ExerciseResultViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit

class ExerciseResultViewController: UIViewController {

    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        return view
    }()
    
    private let checkImage: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = .check
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.text = "운동을 끝마쳤습니다!"
        label.font = Suite.semiBold.of(size: 20)
        label.textColor = .appBlack
        return label
    }()
    
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let circularProgressBar = CircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = Suite.semiBold.of(size: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        let fullText = "예상 소모 칼로리는\n0kcal 예요"
        let font = Suite.semiBold.of(size: 20)
        let changeText = "0kcal"
        let color = UIColor.appGreen
        label.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
        return label
    }()
   
    private let resultView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let runningImage: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = .running
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let periodLable: UILabel = {
        let label = UILabel()
        label.text = "0:00 am - 0:00 am"
        label.font = Suite.regular.of(size: 16)
        label.textColor = .appDarkGray
        return label
    }()
    
    private let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .appDarkGray
        return view
    }()
    
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let kcalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = Suite.regular.of(size: 16)
        label.textColor = .appDarkGray
        return label
    }()

    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "kcal"
        label.font = Suite.regular.of(size: 16)
        label.textColor = .appDarkGray
        return label
    }()
    
    private let timeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0h.00min"
        label.font = Suite.medium.of(size: 18)
        label.textColor = .appBlack
        return label
    }()

    private let kcalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0Kcal"
        label.font = Suite.medium.of(size: 18)
        label.textColor = .appBlack
        return label
    }()
   
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 20)
        button.tintColor = .white
        button.backgroundColor = .appBlack
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        circularProgressBar.progress = 0.6
        
        view.addSubviews(scrollView, addButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(cardView, progressView, resultView)
        cardStackView.addArrangedSubviews(checkImage, completionLabel)
        cardView.addSubview(cardStackView)
        progressView.addSubviews(circularProgressBar, progressLabel)
        resultView.addSubviews(runningImage, periodLable, verticalLine, timeStackView, kcalStackView)
        timeStackView.addArrangedSubviews(timeLabel, timeValueLabel)
        kcalStackView.addArrangedSubviews(kcalLabel, kcalValueLabel)
    }
    
    private func setupConstraints() {
        // TODO: 스크롤뷰 레이아웃 조정
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        
        cardStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(50)
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(40)
        }
        
        runningImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(32)
        }
        
        periodLable.snp.makeConstraints {
            $0.centerY.equalTo(runningImage)
            $0.leading.equalTo(runningImage.snp.trailing).offset(4)
        }
        
        verticalLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(76)
            $0.centerX.equalTo(runningImage)
            $0.top.equalTo(runningImage.snp.bottom).offset(20)
            $0.bottom.equalTo(resultView).inset(20)
        }
        
        timeStackView.snp.makeConstraints {
            $0.leading.equalTo(verticalLine).offset(20)
            $0.centerY.equalTo(verticalLine)
        }

        kcalStackView.snp.makeConstraints {
            $0.trailing.equalTo(resultView).inset(16)
            $0.centerY.equalTo(verticalLine)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(resultView.snp.bottom).offset(100)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(26)
            $0.height.equalTo(60)
        }
    }
}
