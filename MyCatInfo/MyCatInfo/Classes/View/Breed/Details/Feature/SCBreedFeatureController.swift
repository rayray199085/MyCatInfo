//
//  SCBreedFeatureController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 4/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import Charts

class SCBreedFeatureController: UIViewController {
    private var currentDataSet: BarChartDataSet?
    @IBOutlet weak var barChart: HorizontalBarChartView!
    
    var features = ["Natural", "Vocalisation", "Suppressed Tail", "Stranger Friendly", "Social Needs", "Short Legs", "Shedding Level", "Rex", "Rare", "Lap", "Intelligence", "Indoor", "Hypoallergenic", "Health Issues", "Hairless", "Grooming", "Experimental", "Energy Level", "Dog Friendly", "Child Friendly", "Affection Level", "Adaptability"]
    
    var comparisonViewModel: SCBreedViewModel?{
        didSet{
            let groupSpace = 0.1
            let barSpace = 0.0
            let barWidth = 0.45
            let groupCount = comparisonViewModel?.features?.count ?? 0
            
            let dataSet = getDataSet(viewModel: comparisonViewModel)
            dataSet.colors = [InfoCommon.comparisonBarColor]
            guard let currentDataSet = currentDataSet else{
                return
            }
            let chartData = BarChartData(dataSets: [currentDataSet, dataSet])
            chartData.barWidth = barWidth
            chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
            
            barChart.xAxis.axisMinimum = 0.0
            barChart.xAxis.axisMaximum = 0.0 + chartData
                .groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
            barChart.xAxis.centerAxisLabelsEnabled = true
            barChart.animate(xAxisDuration: 1, easingOption: .easeInSine)
            
            barChart.data = chartData
        }
    }
    
    var viewModel: SCBreedViewModel?{
        didSet{
            setupChartView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelCount = features.count
        barChart.xAxis.labelTextColor = .darkGray
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: features)
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
       
        barChart.rightAxis.axisMinimum = 0
        barChart.leftAxis.axisMinimum = 0
        
        barChart.isUserInteractionEnabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.leftAxis.labelTextColor = .darkGray
        
        barChart.drawBarShadowEnabled = true
//        barChart.drawValueAboveBarEnabled = false
        barChart.scaleYEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.dragEnabled = false
        barChart.dragDecelerationEnabled = false
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapOnView))
        recognizer.numberOfTapsRequired = 2
        recognizer.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func didDoubleTapOnView(recognizer: UITapGestureRecognizer){
        // reset group chart data settings
        barChart.xAxis.resetCustomAxisMin()
        barChart.xAxis.resetCustomAxisMax()
        barChart.xAxis.centerAxisLabelsEnabled = false
        setupChartView()
    }
}
private extension SCBreedFeatureController{
    func setupChartView(){
        currentDataSet = getDataSet(viewModel: viewModel)
        currentDataSet!.colors = [InfoCommon.barColor]
        barChart.data = BarChartData(dataSets: [currentDataSet!])
        barChart.animate(xAxisDuration: 1, easingOption: .easeInSine)
    }
    
    func getDataSet(viewModel: SCBreedViewModel?)->BarChartDataSet{
        var dataEntries = [BarChartDataEntry]()
        for (index,value) in (viewModel?.features ?? []).enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: Double(value))
            dataEntries.append(entry)
        }
        let dataSet = BarChartDataSet(entries: dataEntries, label: viewModel?.breedName)
        return dataSet
    }
}

