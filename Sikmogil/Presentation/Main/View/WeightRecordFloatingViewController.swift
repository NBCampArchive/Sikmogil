//
//  WeightRecordFloatingViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/5/24.
//

import UIKit
import SnapKit
import Then
import Combine

class WeightRecordFloatingViewController: UIViewController {
    
    var viewModel: MainViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let label = UILabel().then {
        $0.text = "몸무게 기록하기"
        $0.font = Suite.regular.of(size: 20)
        $0.textAlignment = .center
    }
    
    private let weightTextField = UITextField().then {
        $0.placeholder = "00.0"
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .right
        $0.keyboardType = .decimalPad
    }
    
    private let gramLabel = UILabel().then {
        $0.text = "Kg"
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .left
        $0.textColor = .appDarkGray
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        bindViewModel()
        
        hideKeyboardWhenTappedAround()
        
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        print(#function)
        
        weightTextField.delegate = self
    }
    
    private func setupViews() {
        view.addSubviews(label, weightTextField, gramLabel, doneButton)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(44)
            $0.leading.equalToSuperview().offset(130)
            $0.height.equalTo(50)
        }
        
        gramLabel.snp.makeConstraints {
            $0.centerY.equalTo(weightTextField.snp.centerY)
            $0.leading.equalTo(weightTextField.snp.trailing)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(75)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$postSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] postSuccess in
                if postSuccess {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func tapDoneButton() {
        guard let viewModel = viewModel else { return }
        
        guard let weight = weightTextField.text else {
            print("TextFiled is empty")
            return
        }
        
        // viewmodel에 weight 데이터 전달
        viewModel.updateWeightData(weightDate: DateHelper.shared.formatDateToYearMonthDay(Date()), weight: weight)
    }
}

extension WeightRecordFloatingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let prospectiveText = currentText.replacingCharacters(in: range, with: string)

        // 허용된 문자 집합 (숫자 및 소수점)
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        
        // 입력된 문자가 허용된 문자 집합에 속하는지 확인
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // 소수점이 두 번 이상 입력되지 않도록 제한
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let decimalCount = prospectiveText.components(separatedBy: decimalSeparator).count - 1
        if decimalCount > 1 {
            return false
        }
        
        // 자연수 3자리와 소수점 이하 1자리까지 허용
        let maxIntegerDigits = 3
        let maxFractionDigits = 1
        
        let components = prospectiveText.components(separatedBy: decimalSeparator)
        
        if components.count == 1 {
            // 소수점이 없는 경우
            return components[0].count <= maxIntegerDigits
        } else if components.count == 2 {
            // 소수점이 있는 경우
            let integerPart = components[0]
            let fractionPart = components[1]
            return integerPart.count <= maxIntegerDigits && fractionPart.count <= maxFractionDigits
        } else {
            // 소수점이 두 개 이상 있는 경우는 허용하지 않음
            return false
        }
    }
}
