//
//  File.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 물마시기 추가 바텀시트 페이지

import UIKit
import SnapKit
import Then
import FloatingPanel

class WaterBottomSheetViewController: UIViewController {
    
    // MARK: - UI components
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "마신 물을 기록해보세요!"
        $0.textColor = .appBlack
        $0.font = Suite.medium.of(size: 16)
        $0.textAlignment = .center
    }
    let waterRecordTextField = UITextField().then {
        $0.text = "000 ml"
        $0.textColor = .appDarkGray
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
    }
    let doneButton = UIButton().then{
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        waterRecordTextField.delegate = self
        
        // 키보드 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOnce), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(contentView)
        contentView.addSubviews(titleLabel,waterRecordTextField,doneButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        waterRecordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(55)
            $0.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(waterRecordTextField.snp.bottom).offset(66)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(361)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Action
    @objc func keyboardWillShowOnce(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let fpc = parent as? FloatingPanelController {
            let keyboardHeight = keyboardFrame.height
            let initialHeight = self.view.bounds.height - 460
            fpc.surfaceLocation = CGPoint(x: self.view.bounds.midX, y: initialHeight)
            fpc.surfaceView.containerMargins.bottom = keyboardHeight
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        if let fpc = parent as? FloatingPanelController {
            let initialHeight = self.view.bounds.height + 100
            fpc.surfaceLocation = CGPoint(x: self.view.bounds.midX, y: initialHeight)
            fpc.surfaceView.containerMargins.bottom = 0
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension WaterBottomSheetViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 편집이 시작되면 텍스트를 초기화
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 숫자만 입력되도록 제한
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // 현재 텍스트와 범위 가져오기
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // 텍스트 업데이트
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 새로운 텍스트가 3자리를 넘지 않도록 제한
        let newNumbers = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard newNumbers.count <= 3 else { return false }
        
        // 새로운 형식의 텍스트 설정
        let formattedText = "\(newNumbers) ml"
        textField.text = formattedText
        
        // 커서를 ml 앞에 위치시키기
        if let newPosition = textField.position(from: textField.endOfDocument, offset: -3) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        return false
    }
}
