//
//  MainViewModel.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/5/24.
//

import Foundation
import Combine
import DGCharts

class MainViewModel: ObservableObject {
    
//    //MARK: - Input
//    struct Input {
//        let updateWeightData: AnyPublisher<(String, String), Never>
//        let loadWeightData: AnyPublisher<(String, String), Never>
//    }
//
//    //MARK: - Output
//    struct Output {
//        let targetModel: AnyPublisher<TargetModel?, Never>
//        let errorMessage: AnyPublisher<String?, Never>
//        let postSuccess: AnyPublisher<Bool, Never>
//    }
    
    //MARK: - Properties
//    private let updateWeightDataSubject = PassthroughSubject<(String, String), Never>()
//    private let loadWeightDataSubject = PassthroughSubject<(String, String), Never>()
    
    @Published var targetModel: TargetModel?
    @Published var errorMessage: String?
    @Published var postSuccess: Bool = false
    @Published var progress: Float = 0.0
    @Published var remainingDays: Int = 0
    @Published var chartDateEntries: [BarChartDataEntry] = []
    @Published var dataUpdated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let calendarService = CalendarAPIManager.shared
    
//    //MARK: - Init
//    init() {
//        bindInputs()
//    }
//
//    //MARK: - Binding
//    private func bindInputs() {
//        updateWeightDataSubject
//            .sink { weightDate, weight in
//                self.updateWeightData(weightDate: weightDate, weight: weight)
//            }
//            .store(in: &cancellables)
//    }
    //MARK: - Get Target Data
    func loadWeightData() {
        calendarService.getWeightData()
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { targetModel in
                print("Received TargetModel: \(targetModel)")
                self.targetModel = targetModel
                self.calculateProgress()
                self.calculateRemainingDays()
                self.updateChartDataEntry()
            }
            .store(in: &cancellables)
    }

    //MARK: - Update Target Data
    func updateWeightData(weightDate: String ,weight: String) {
        print("updateWeightData")
        calendarService.updateWeightData(weightDate: weightDate ,weight: weight)
            .receive(on: DispatchQueue.main)
            .print("Combien debug")
            .sink { completion in
                switch completion {
                case .finished:
                    self.postSuccess = true
                    self.loadWeightData()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                print("Successfully updated weight data")
            }
            .store(in: &cancellables)
    }
    
    //MARK: - 진행도 계산기
    private func calculateProgress() {
        guard let targetModel = targetModel else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let startDate = dateFormatter.date(from: targetModel.createDate),
              let endDate = dateFormatter.date(from: targetModel.targetDate) else {
            return
        }
        
        let now = Date()
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsedDuration = now.timeIntervalSince(startDate)
        
        let progress = elapsedDuration / totalDuration
        print(progress)
        self.progress = Float(progress) // Float로 변환하여 설정
    }
    
    //MARK: - 남은 일수 계산기
    private func calculateRemainingDays() {
        guard let targetModel = targetModel else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let endDate = dateFormatter.date(from: targetModel.targetDate) else {
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: now, to: endDate)
        
        if let remainingDays = components.day {
            self.remainingDays = remainingDays
        }
    }
    
    //MARK: - 차트 데이터 업데이트
    private func updateChartDataEntry() {
        guard let targetModel = targetModel else { return }
        
//        let entries = targetModel.weekWeights.enumerated().map { index, weekWeight in
//            return BarChartDataEntry(x: Double(index), y: weekWeight.weight)
//        }
        var entries: [BarChartDataEntry] = []
        var labels: [String] = []
        
        for index in 0..<7 {
            if targetModel.weekWeights.isEmpty {
                entries.append(BarChartDataEntry(x: Double(index), y: Double(targetModel.weight) ?? 0.0))
            }
            else if index < targetModel.weekWeights.count {
                let weekWeight = targetModel.weekWeights[index]
                entries.append(BarChartDataEntry(x: Double(8 - index), y: weekWeight.weight))
            } else {
                entries.append(BarChartDataEntry(x: Double(index), y: 0))
            }
        }
        
        self.chartDateEntries = entries
    }
}
