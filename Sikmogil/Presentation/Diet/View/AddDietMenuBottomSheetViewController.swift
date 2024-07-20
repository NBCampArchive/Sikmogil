//
//  AddDietMenuBottomSheetViewController.swift
//  Sikmogil
//
//  Created by 희라 on 7/17/24.
//

import UIKit
import SnapKit
import Combine
import FloatingPanel

class AddDietMenuBottomSheetViewController: UIViewController {
    
    var addMealAction: ((FoodItem) -> Void)?
    
    // MARK: - UI components
    
    let AddDietMenuBottomSheetTitleLabel = UILabel().then {
        $0.text = "메뉴추가"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 24)
        $0.textAlignment = .left
    }
    let mealNameTitleLabel = UILabel().then {
        $0.text = "메뉴 이름"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
        $0.textAlignment = .center
    }
    let mealNameTextField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.placeholder = "메뉴 이름을 입력해주세요."
    }
    let mealNameWarningLabel = UILabel().then {
        $0.text = "메뉴 이름을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    let mealKcalTitleLabel = UILabel().then {
        $0.text = "메뉴 칼로리"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
        $0.textAlignment = .center
    }
    let mealKcalTextField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
        $0.placeholder = "메뉴 칼로리를 입력해주세요."
        $0.keyboardType = .numberPad  // 숫자 입력 패드로 설정
    }
    let mealKcalWarningLabel = UILabel().then {
        $0.text = "메뉴 칼로리를 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    let doneButton = UIButton().then{
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        mealNameTextField.delegate = self
        mealKcalTextField.delegate = self
        
        // 키보드 이벤트 관찰
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(AddDietMenuBottomSheetTitleLabel,mealNameTitleLabel,mealNameTextField,mealKcalTitleLabel,mealKcalTextField,doneButton,mealNameWarningLabel,mealKcalWarningLabel
        )
    }
    
    private func setupConstraints() {
        AddDietMenuBottomSheetTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        mealNameTitleLabel.snp.makeConstraints{
            $0.top.equalTo(AddDietMenuBottomSheetTitleLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(16)
        }
        mealNameTextField.snp.makeConstraints{
            $0.top.equalTo(mealNameTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        mealNameWarningLabel.snp.makeConstraints {
            $0.bottom.equalTo(mealNameTitleLabel)
            $0.leading.equalTo(mealNameTitleLabel.snp.trailing).offset(8)
        }
        mealKcalTitleLabel.snp.makeConstraints{
            $0.top.equalTo(mealNameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        mealKcalTextField.snp.makeConstraints{
            $0.top.equalTo(mealKcalTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        mealKcalWarningLabel.snp.makeConstraints {
            $0.bottom.equalTo(mealKcalTitleLabel)
            $0.leading.equalTo(mealKcalTitleLabel.snp.trailing).offset(8)
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(mealKcalTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(49)
        }
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
    
    // MARK: - Action
    @objc func doneButtonTapped() {
        mealNameTextField.resignFirstResponder()
        mealKcalTextField.resignFirstResponder()
        
        // 텍스트 필드의 값을 가져옴
        guard let mealName = mealNameTextField.text, !mealName.isEmpty else {
            mealNameWarningLabel.isHidden = false
            updateTextFieldBorders(isValid: false, textField: mealNameTextField)
            return
        }
        guard let mealKcalText = mealKcalTextField.text, !mealKcalText.isEmpty else {
            mealKcalWarningLabel.isHidden = false
            updateTextFieldBorders(isValid: false, textField: mealKcalTextField)
            return
        }
        
        // FoodItem 생성
        let foodItem = FoodItem(foodNmKr: mealName, amtNum1: mealKcalText)
        
        // 클로저를 통해 값을 전달
        addMealAction?(foodItem)
        
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .hidden, animated: true)
            fpc.hide(animated: true) {
                self.tabBarController?.tabBar.isHidden = false
                fpc.view.removeFromSuperview()
                fpc.removeFromParent()
                
                // AddDietMenuViewController에 화면 이동을 처리하는 알림을 보냄
                NotificationCenter.default.post(name: .didAddMeal, object: nil)
            }
        }
    }
    private func updateTextFieldBorders(isValid: Bool, textField: UITextField) {
        if isValid {
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.appDarkGray.cgColor
            textField.layer.borderWidth = 1
        } else {
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension AddDietMenuBottomSheetViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 편집이 시작되면 경고문구 숨기기
        switch textField {
        case mealNameTextField:
            mealNameWarningLabel.isHidden = true
            updateTextFieldBorders(isValid: true, textField: textField)
        case mealKcalTextField:
            mealKcalWarningLabel.isHidden = true
            updateTextFieldBorders(isValid: true, textField: textField)
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case mealNameTextField: // 글자와 숫자만 입력 가능하고, 특수문자와 공백은 입력 불가능하며, 최대 10글자까지 입력 가능
            let allowedCharacters = CharacterSet.alphanumerics
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 10
            
        case mealKcalTextField: // 숫자만 입력 가능하고, 글자, 특수문자, 공백은 입력 불가능하며, 최대 5글자까지 입력 가능
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 5
            
        default:
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mealNameTextField {
            mealKcalTextField.becomeFirstResponder()
        } else if textField == mealKcalTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
