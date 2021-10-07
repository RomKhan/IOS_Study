import UIKit

class AlarmMenadger {
    private var alarmModels: [AlarmModel] = []
    var functions: [Int: [(Int, (_ isActive: Bool)->())]] = [:]
    
    func alarmStatusChanged(id: Int) {
        alarmModels[id].isActive = !alarmModels[id].isActive
        for function in functions[id]! {
            function.1(alarmModels[id].isActive)
        }
    }
    
    func addAlarm(hours: Int, minutes: Int, isActive: Bool) {
        let alarm = AlarmModel(hours: hours, minutes: minutes, isActive: isActive)
        alarmModels.append(alarm)
    }
    
    func getAlarmByIndex(_ index: Int) -> AlarmModel {
        return alarmModels[index];
    }
    
    func linkViewWithAlarm(view: AlarmView, index: Int) {
        view.setupAlarmView(alarmModels[index].hours,
                       alarmModels[index].minutes,
                       alarmModels[index].isActive,
                       index)
        view.changeFunction = alarmStatusChanged
        view.updateFunctionId = functions[index]?.count ?? 0
        if (functions.keys.contains(index)) {
            functions[index]?.append((view.updateFunctionId, view.alarmToggleUpdate))
        }
        else {
            functions[index] = [(view.updateFunctionId, view.alarmToggleUpdate)]
        }
    }
    
    func viewRetarget(view: AlarmView, index: Int) {
        var indexOfFunction = functions[index]?.firstIndex{$0.0 == view.updateFunctionId}
        if let i = indexOfFunction {
            functions[view.id]?.remove(at: i)
        }
        view.alarmViewUpdate(hours: alarmModels[index].hours,
                             minutes: alarmModels[index].minutes,
                             isActive: alarmModels[index].isActive)
        view.id = index
        
        view.updateFunctionId = functions[index]!.count
        if (functions.keys.contains(index)) {
            functions[index]?.append((view.updateFunctionId, view.alarmToggleUpdate))
        }
        else {
            functions[index] = [(view.updateFunctionId, view.alarmToggleUpdate)]
        }
    }
    
    @objc private func alarmIsChanged(_ sender: Any?) {
        let view = sender as? AlarmView
        if let alarmView = view {
            alarmStatusChanged(id: alarmView.id)
        }
    }
    
    func generateRandomAlarms() {
        for _ in 0...Int.random(in: 0...100) {
            alarmModels.append(AlarmModel(hours: Int.random(in: 0...24),
                                          minutes: Int.random(in: 0...59),
                                          isActive: Bool.random()))
        }
    }
    
    func getAlarmsCount() -> Int {
        return alarmModels.count
    }
    
}
