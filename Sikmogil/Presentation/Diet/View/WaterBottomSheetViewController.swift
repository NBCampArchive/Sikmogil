//
//  File.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 물마시기 추가 바텀시트 페이지

import UIKit
import SnapKit
import Combine
import FloatingPanel

class WaterBottomSheetViewController: UIViewController {
    
    let dietViewModel = DietViewModel()
    
    // MARK: - UI components
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "마신 물을 기록해보세요!"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
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
        
        waterRecordTextField.delegate = self
        
        //(디버깅용) 식단 출력
        dietViewModel.getDietLogDate(for: DateHelper.shared.formatDateToYearMonthDay(Date())) {
            result in
            switch result {
            case .success(let data):
                print("식단 출력 성공: \(data)")
            case .failure(let error):
                print("식단 출력 실패: \(error)")
            }
        }
        
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
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        waterRecordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(75)
            $0.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(waterRecordTextField.snp.bottom).offset(65)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(49)
        }
    }
    
    // MARK: - Action
    @objc func keyboardWillShowOnce(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let fpc = parent as? FloatingPanelController {
            fpc.move(to: .full, animated: true)
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .half, animated: true)
        }
    }
    
    @objc func doneButtonTapped() {
        waterRecordTextField.resignFirstResponder()//키보드 종료
        // 텍스트 필드의 값을 가져와서 정수로 변환
        guard let text = waterRecordTextField.text?.replacingOccurrences(of: " ml", with: ""),
              let waterAmount = Int(text)
        else {
            return
        }
        
        // 싱글톤 인스턴스를 통해 데이터 업데이트
        WaterViewModel.shared.addWaterAmount(waterAmount)
        
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .hidden, animated: true)
            fpc.hide(animated: true){
                self.tabBarController?.tabBar.isHidden = false
                fpc.view.removeFromSuperview()
                fpc.removeFromParent()
            }
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
        
        // 새로운 텍스트가 4자리를 넘지 않도록 제한
        let newNumbers = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard newNumbers.count <= 4 else { return false }
        
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
