import UIKit
import CoreData
import EventKit

class AlarmMenadger {
    private var alarmModels: [AlarmEntity] = []
    private var allAlarmViews: [AlarmView] = []
    var idOfDeletedAlarms: [Int] = []
    private var context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    var controllers: [AlarmViewControllerProtocol]?
    var functions: [Int: [(Int, (_ hours: Int32, _ minutes: Int32, _ name: String?, _ isActive: Bool)->())]] = [:]
    var scene: SceneDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextSave),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc func contextSave() {
        do {
            try context.save()
        }
        catch {
            print("Error to save data base!")
        }
    }
    
    func addAlertNotification(index: Int) {
        let content = UNMutableNotificationContent()
        content.title = alarmModels[index].name ?? "No name"
        content.body = "Будильник, который Вы заводили"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("iphone_alarm_6.mp3"))

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:"\(alarmModels[index].hours):\(alarmModels[index].minutes)")!
        
        let triger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)
        let reqest = UNNotificationRequest(identifier: "\(index)", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(reqest) { [weak self] (error) in self?.alarmModels[index].isActive = false }
    }
    
    func loadFromDataBase() {
        do {
            alarmModels = try context.fetch(AlarmEntity.fetchRequest()) as [AlarmEntity]
        }
        catch {
            alarmModels = []
        }
    }
    
    func alarmStatusChanged(id: Int) {
        
    UNUserNotificationCenter.current().getPendingNotificationRequests { (alarms) in
        for i in 0..<alarms.count {
            print(alarms[i].identifier)
        }
        print(alarms.count)
            return
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(id)"])
        alarmModels[id].isActive = !alarmModels[id].isActive
        alarmUpdate(index: id)
    }
    
    func alarmRemove(index: Int) {
        idOfDeletedAlarms.append(index)
        context.delete(alarmModels[index])
        
//        context.delete(alarmModels[index])
        alarmModels.remove(at: index)
        
        for k in 0..<functions.count - 1 {
            if k >= index {
                functions[k] = functions[k+1]
            }
        }
        functions.removeValue(forKey: functions.count - 1)

        allAlarmViews.remove(at: index)
        for view in allAlarmViews {
            if view.id >= index {
                view.id -= 1
            }
        }
        
        guard let viewControllers = controllers else {return}
        for viewController in viewControllers {
            viewController.alarmRemove(index: index)
        }
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
        let alarm = AlarmEntity(context: context)
        alarm.hours = Int32(hours)
        alarm.minutes = Int32(minutes)
        alarm.isActive = isActive
        alarm.name = name
        alarmModels.append(alarm)
        addAlertNotification(index: alarmModels.count - 1)
    }
    
    func getAlarmByIndex(_ index: Int) -> AlarmEntity {
        return alarmModels[index];
    }
    
    func linkViewWithAlarm(view: AlarmView, index: Int = -1) {
        var correctIndex = index
        if index == -1 || index >= getAlarmsCount() {
            correctIndex = alarmModels.count - 1
        }
        
        view.setupAlarmView(alarmModels[correctIndex].hours,
                       alarmModels[correctIndex].minutes,
                       alarmModels[correctIndex].name,
                       alarmModels[correctIndex].isActive,
                       correctIndex)
        view.changeFunction = alarmStatusChanged
        view.editfunction = alarmConfigureWindowOpen
        view.deleteFunction = alarmRemove
        view.updateFunctionId = functions[correctIndex]?.count ?? 0
        if (functions.keys.contains(correctIndex)) {
            functions[correctIndex]?.append((view.updateFunctionId, view.alarmViewUpdate))
        }
        else {
            functions[correctIndex] = [(view.updateFunctionId, view.alarmViewUpdate)]
        }
        allAlarmViews.append(view)
    }
    
    func alarmConfigureWindowOpen(index: Int) {
        scene?.addViewControllerShow(mode: true, alarmIndex: index)
    }
    
    func alarmChange(index: Int, data: DateComponents, name: String = "Alarm") {
        alarmModels[index].hours =  Int32(data.hour!)
        alarmModels[index].minutes =  Int32(data.minute!)
        if (name != "Alarm") {
            alarmModels[index].name = name
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(index)"])
        addAlertNotification(index: index)
        alarmUpdate(index: index)
    }

    func viewRetarget(view: AlarmView, index: Int) {
        let indexOfFunction = functions[view.id]?.firstIndex{$0.0 == view.updateFunctionId}
        if let i = indexOfFunction {
            functions[view.id]?.remove(at: i)
        }
        if index >= getAlarmsCount() {
            return
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
            let alarm = AlarmEntity(context: context)
            alarm.hours = Int32.random(in: 0...24)
            alarm.minutes = Int32.random(in: 0...59)
            alarm.isActive = Bool.random()
            alarm.name = "Alarm"
            alarmModels.append(alarm)
        }
    }
    
    func getAlarmsCount() -> Int {
        return alarmModels.count
    }
    
    func alarmAdd(_ hours: Int, _ minutes: Int, _ name: String, _ isActive: Bool) {
        addAlarm(hours: hours, minutes: minutes, name: name, isActive: isActive)
        
        guard let viewControllers = controllers else {return}
        
        for viewController in viewControllers {
            viewController.alarmAdd()
        }
    }
}
