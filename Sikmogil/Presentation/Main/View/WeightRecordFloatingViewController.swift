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
        $0.font = Suite.regular.of(size: 22)
        $0.textAlignment = .center
    }
    
    private let weightTextField = UITextField().then {
        $0.placeholder = "00.0"
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .right
        $0.keyboardType = .decimalPad
    }
    
    private let gramLabel = UILabel().then {
        $0.text = "KG"
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .left
        $0.textColor = .appDarkGray
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
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
            $0.height.equalTo(60)
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
