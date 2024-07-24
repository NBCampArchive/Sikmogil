//
//  CustomExerciseInputViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 7/17/24.
//

import UIKit
import SnapKit
import Combine
import FloatingPanel

class CustomExerciseInputViewController: UIViewController, UINavigationControllerDelegate {
    
    private let titleLabel = UILabel().then {
        $0.text = "운동 직접 입력"
        $0.font = Suite.semiBold.of(size: 20)
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "운동 이름"
        $0.font = Suite.medium.of(size: 14)
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = "운동 이름을 입력해주세요."
        $0.font = Suite.medium.of(size: 18)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
    }

    private let timeLabel = UILabel().then {
        $0.text = "운동 시간"
        $0.font = Suite.medium.of(size: 14)
    }
   
    private let timeTextField = UITextField().then {
        $0.placeholder = "0"
        $0.font = Suite.medium.of(size: 18)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.keyboardType = .numberPad
    }
    
    private let timeUnitLabel = UILabel().then {
        $0.text = "분"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .placeholderText
    }

    private let kcalLabel = UILabel().then {
        $0.text = "소모 칼로리"
        $0.font = Suite.medium.of(size: 14)
    }
    
    private let kcalTextField = UITextField().then {
        $0.placeholder = "0"
        $0.font = Suite.medium.of(size: 18)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.keyboardType = .numberPad
    }
    
    private let kcalUnitLabel = UILabel().then {
        $0.text = "kcal"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .placeholderText
    }
    
    lazy var textFieldStackView = UIStackView(arrangedSubviews: [timeTextField, kcalTextField]).then {
        $0.axis = .horizontal
        $0.spacing = 14
        $0.distribution = .fillEqually
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupKeyboardObservers()
        setupGestureRecognizer()
    }
 
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, nameLabel, nameTextField, timeLabel, textFieldStackView, kcalLabel, timeUnitLabel, kcalUnitLabel, doneButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nameTextField.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        kcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(timeLabel)
            $0.leading.equalTo(kcalTextField.snp.leading)
        }
        
        timeUnitLabel.snp.makeConstraints{
            $0.centerY.equalTo(timeTextField)
            $0.trailing.equalTo(timeTextField.snp.trailing).inset(16)
        }
      
        kcalUnitLabel.snp.makeConstraints{
            $0.centerY.equalTo(kcalTextField)
            $0.trailing.equalTo(kcalTextField.snp.trailing).inset(16)
        }
        
        doneButton.snp.makeConstraints{
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Keyboard Observers, Gesture Recognizer
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
     private func setupGestureRecognizer() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
     }
     
    @objc override func dismissKeyboard() {
         view.endEditing(true)
     }
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let fpc = parent as? FloatingPanelController {
            let keyboardHeight = keyboardFrame.height
            fpc.move(to: .full, animated: true)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .half, animated: true)
        }
    }
 }
