import UIKit
import CoreData

class AlarmMenadger {
    private var alarmModels: [AlarmModel] = []
    var controllers: [AlarmViewControllerProtocol]?
    var functions: [Int: [(Int, (_ hours: Int, _ minutes: Int, _ name: String, _ isActive: Bool)->())]] = [:]
    var scene: SceneDelegate?
    
    func alarmStatusChanged(id: Int) {
        alarmModels[id].isActive = !alarmModels[id].isActive
        alarmUpdate(index: id)
    }
    
    func alarmUpdate(index: Int) {
        for function in functions[index]! {
            function.1(alarmModels[index].hours,
                       alarmModels[index].minutes,
                       alarmModels[index].name,
                       alarmModels[index].isActive)
        }
    }
    
    func addAlarm(hours: Int, minutes: Int, name: String, isActive: Bool) {
        let alarm = AlarmModel(hours: hours, minutes: minutes, name: name, isActive: isActive)
        alarmModels.append(alarm)
    }
    
    func getAlarmByIndex(_ index: Int) -> AlarmModel {
        return alarmModels[index];
    }
    
    func linkViewWithAlarm(view: AlarmView, index: Int = -1) {
        var correctIndex = index
        if index == -1 {
            correctIndex = alarmModels.count - 1
        }
        
        view.setupAlarmView(alarmModels[correctIndex].hours,
                       alarmModels[correctIndex].minutes,
                       alarmModels[correctIndex].name,
                       alarmModels[correctIndex].isActive,
                       correctIndex)
        view.changeFunction = alarmStatusChanged
        view.editfunction = alarmConfigureWindowOpen
        view.updateFunctionId = functions[correctIndex]?.count ?? 0
        if (functions.keys.contains(correctIndex)) {
            functions[correctIndex]?.append((view.updateFunctionId, view.alarmViewUpdate))
        }
        else {
            functions[correctIndex] = [(view.updateFunctionId, view.alarmViewUpdate)]
        }
    }
    
    func alarmConfigureWindowOpen(index: Int) {
        scene?.addViewControllerShow(mode: true, alarmIndex: index)
    }
    
    func alarmChange(index: Int, data: DateComponents) {
        alarmModels[index].hours =  data.hour!
        alarmModels[index].minutes =  data.minute!
        
        alarmUpdate(index: index)
    }

    func viewRetarget(view: AlarmView, index: Int) {
        let indexOfFunction = functions[view.id]?.firstIndex{$0.0 == view.updateFunctionId}
        if let i = indexOfFunction {
            functions[view.id]?.remove(at: i)
        }
        view.alarmViewUpdate(alarmModels[index].hours,
                             alarmModels[index].minutes,
                             alarmModels[index].name,
                             alarmModels[index].isActive)
        view.id = index
        
        view.updateFunctionId = functions[index]!.count
        if (functions.keys.contains(index)) {
            functions[index]?.append((view.updateFunctionId, view.alarmViewUpdate))
        }
        else {
            functions[index] = [(view.updateFunctionId, view.alarmViewUpdate)]
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
                                          name: "Alarm",
                                          isActive: Bool.random()))
        }
    }
    
    func getAlarmsCount() -> Int {
        return alarmModels.count
    }
    
    func alarmAdd(_ hours: Int, _ minutes: Int, _ name: String, _ isActive: Bool) {
        let newAlarm = AlarmModel(hours: hours, minutes: minutes, name: name, isActive: isActive)
        alarmModels.append(newAlarm)
        
        guard let viewControllers = controllers else {return}
        
        for viewController in viewControllers {
            viewController.alarmAdd()
        }
    }
}
