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
    @Published var chartDateEntries: [ChartDataEntry] = []
    @Published var chartDates: [String] = []
    @Published var dataUpdated: Bool = false
    @Published var weight: String = ""
    
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
            .print("loadWeightData debug")
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
            .print("updateWeightData debug")
            .sink { completion in
                switch completion {
                case .finished:
                    self.postSuccess = true
                    self.weight = weight
                    self.updateChartDataEntry()
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
              let targetDate = dateFormatter.date(from: targetModel.targetDate) else {
            return
        }
        
        let calendar = Calendar.current
        // targetDate의 다음 날을 계산하기 위해 1일을 더함
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: targetDate) else {
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
        
        guard let startDate = dateFormatter.date(from: targetModel.targetDate) else {
            return
        }
        
        let calendar = Calendar.current
        // targetDate의 다음 날을 계산하기 위해 1일을 더함
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            return
        }
        
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: endDate)
        
        if let remainingDays = components.day {
            self.remainingDays = remainingDays
        }
    }
    
    //MARK: - 차트 데이터 업데이트
    private func updateChartDataEntry() {
        guard let targetModel = targetModel else { return }
        
        var entries: [ChartDataEntry] = []
        var dates: [String] = []
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy.MM.dd"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM.dd"
        
        if targetModel.weekWeights.count == 0 {
            let weight = Double(targetModel.weight) ?? 0.0
            entries.append(ChartDataEntry(x: Double(0), y: 0))
            entries.append(ChartDataEntry(x: Double(1), y: weight))
            dates.append("")
            dates.append("시작일")
        }
        else if targetModel.weekWeights.count == 1 {
            let startWeight = Double(targetModel.weight) ?? 0.0
            let weight = targetModel.weekWeights[0].weight ?? 0.0
            entries.append(ChartDataEntry(x: Double(0), y: startWeight))
            entries.append(ChartDataEntry(x: Double(1), y: weight))
            
            dates.append("시작일")
            if let date = inputDateFormatter.date(from: targetModel.weekWeights[0].date) {
                let formattedDate = outputDateFormatter.string(from: date)
                dates.append(formattedDate)
            }
            else {
                dates.append("") // 변환에 실패하면 빈 문자열 추가
            }
        }
        else {
            for index in 0..<targetModel.weekWeights.count {
                let weight = targetModel.weekWeights[index].weight ?? 0.0
                entries.append(ChartDataEntry(x: Double(index), y: weight))
                if let date = inputDateFormatter.date(from: targetModel.weekWeights[index].date) {
                    let formattedDate = outputDateFormatter.string(from: date)
                    dates.append(formattedDate)
                } else {
                    dates.append("") // 변환에 실패하면 빈 문자열 추가
                }
            }
        }
        
        self.chartDateEntries = entries
        self.chartDates = dates
    }
}
