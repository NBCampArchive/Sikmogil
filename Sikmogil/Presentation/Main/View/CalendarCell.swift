//
//  CalendarCell.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/14/24.
//

import UIKit
import SnapKit
import Then
import FSCalendar

class CalendarCell: FSCalendarCell {
    private let circleView1 = UIView()
    private let circleView2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.insertSubview(circleView1, at: 0)
        contentView.insertSubview(circleView2, at: 1)
        
        circleView1.backgroundColor = .clear
        circleView2.backgroundColor = .clear
        
        circleView1.layer.cornerRadius = 5
        circleView2.layer.cornerRadius = 5
        
        circleView1.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-5)
            $0.width.height.equalTo(10)
        }
        
        circleView2.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-5)
            $0.width.height.equalTo(10)
        }
    }
    
    func configure(with colors: [UIColor]) {
        circleView1.backgroundColor = colors.first ?? .clear
        circleView2.backgroundColor = colors.count > 1 ? colors[1] : .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleView1.backgroundColor = .clear
        circleView2.backgroundColor = .clear
    }
}
