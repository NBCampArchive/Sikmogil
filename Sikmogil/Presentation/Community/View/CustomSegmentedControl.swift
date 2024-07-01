//
//  CustomSegmentedControl.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/18/24.
//

import UIKit
import SnapKit
import Then

class CustomSegmentedControl: UIView {
    
    private var buttons: [UIButton] = []
    private var selectorView = UIView().then{
        $0.backgroundColor = .black
    }
    private var dividerView = UIView().then{
        $0.backgroundColor = .lightGray
    }
    var buttonTitles: [String]
    var selectedIndex: Int = 0
    
    var onSelectSegment: ((Int) -> Void)?
    
    init(frame: CGRect, buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        setupButtons()
        setupDivider()
        setupSelector()
        setupStackView()
    }
    
    private func setupButtons() {
        buttons = [UIButton]()
        for buttonTitle in buttonTitles {
            var config = UIButton.Configuration.plain()
            config.title = buttonTitle
            config.baseBackgroundColor = .clear
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var attributes = $0
                attributes.font = UIFont.systemFont(ofSize: 16)
                attributes.foregroundColor = .lightGray
                return attributes
            }
            let button = UIButton(type: .system).then {
                $0.configuration = config
                $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                $0.setBackgroundImage(UIImage(), for: .normal)
                $0.setBackgroundImage(UIImage(), for: .selected)
                $0.setBackgroundImage(UIImage(), for: .highlighted)
            }
            buttons.append(button)
        }
        buttons[selectedIndex].isSelected = true
        updateButtonSelection()
    }
    
    private func setupDivider() {
        self.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupSelector() {
        self.addSubview(selectorView)
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.leading.equalTo(buttons[0])
            make.width.equalTo(buttons[0])
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for (index, btn) in buttons.enumerated() {
            btn.isSelected = false
            if btn == sender {
                selectedIndex = index
                btn.isSelected = true
                onSelectSegment?(selectedIndex)
                moveSelectorView(to: index)
            }
        }
        updateButtonSelection()
    }
    
    private func moveSelectorView(to index: Int) {
        selectorView.snp.remakeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
            make.leading.equalTo(buttons[index])
            make.width.equalTo(buttons[index])
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setSelectedIndex(index: Int) {
        selectedIndex = index
        for (idx, btn) in buttons.enumerated() {
            btn.isSelected = (idx == index)
        }
        moveSelectorView(to: index)
        updateButtonSelection()
        
        
    }
    
    func updateButtonSelection() {
        for (index, button) in buttons.enumerated() {
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 16, weight: index == self.selectedIndex ? .bold : .regular)
                outgoing.foregroundColor = index == self.selectedIndex ? .black : .lightGray
                return outgoing
            }
            button.configuration = config
        }
    }
}

