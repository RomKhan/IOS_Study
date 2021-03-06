import UIKit
import CoreData
import EventKit

/// Менаджер будильников
/// Хранит данные о моделях, управляет базой данных.
/// Также несет функцию посредника между alarmview и model.
class AlarmMenadger {
    private var alarmModels: [AlarmEntity] = []
    private var allAlarmViews: [AlarmView] = []
    private var context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    var controllers: [AlarmViewControllerProtocol]?
    /// Список функций, которые будут вызываться, чтобы обновить все view, которые относяться к одному будильнику.
    var functions: [Int: [(Int, (_ hours: Int32, _ minutes: Int32, _ name: String?, _ isActive: Bool)->())]] = [:]
    var scene: SceneDelegate?
    
    /// Стандартный конструктор добавляет обсервер, который сохраняет бд, когда приложение становится не активным.
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextSave),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    /// Сохранение бд.
    @objc func contextSave() {
        do {
            try context.save()
        }
        catch {
            print("Error to save data base!")
        }
    }
    
    
    /// Загрузка данных из бд.
    func loadFromDataBase() {
        do {
            alarmModels = try context.fetch(AlarmEntity.fetchRequest()) as [AlarmEntity]
            alarmModels.sort(by: {(x: AlarmEntity, y: AlarmEntity) -> Bool in
                if (x.hours * 60 + x.minutes < y.hours * 60 + y.minutes) {
                    return true
                }
                return false
            })
        }
        catch {
            alarmModels = []
        }
    }
    
    /// Добавление уведомления о будильнике.
    func addAlertNotification(index: Int) {
        let content = UNMutableNotificationContent()
        content.title = alarmModels[index].name ?? "No name"
        content.body = "Будильник, который Вы заводили"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("iphone_alarm_6.mp3"))

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from:"\(alarmModels[index].hours):\(alarmModels[index].minutes)")!
        
        let triger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)
        let reqest = UNNotificationRequest(identifier: "\(index)", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(reqest) { (error) in return }
    }
    
    /// Метод удаление будильника.
    func alarmRemove(index: Int) {
        context.delete(alarmModels[index])
        alarmModels.remove(at: index)
        
        // Сначала смещаем словарь функций на 1 вправо(от index) по ключу и удаляем последний ключ.
        for k in 0..<functions.count - 1 {
            if k >= index {
                functions[k] = functions[k+1]
            }
        }
        functions.removeValue(forKey: functions.count - 1)

        allAlarmViews.remove(at: index)
        // Меняем индекс всех view, которые расположены правее index.
        for view in allAlarmViews {
            if view.id >= index {
                view.id -= 1
            }
        }
        
        // Вызываем методы удаления у всех контроллеров.
        guard let viewControllers = controllers else {return}
        for viewController in viewControllers {
            viewController.alarmRemove(index: index)
        }
    }
    
    /// Метода добавления будильника вместе с обновлением контроллеров.
    func alarmAddAndReloadContollers(_ hours: Int, _ minutes: Int, _ name: String, _ isActive: Bool) {
        addAlarm(hours: hours, minutes: minutes, name: name, isActive: isActive)
        alarmModels.sort(by: {(x: AlarmEntity, y: AlarmEntity) -> Bool in
            if (x.hours * 60 + x.minutes < y.hours * 60 + y.minutes) {
                return true
            }
            return false
        })
        
        guard let viewControllers = controllers else {return}
        
        for viewController in viewControllers {
            viewController.update()
        }
    }
    
    
    /// Обычный метод добавления будильников.
    func addAlarm(hours: Int, minutes: Int, name: String, isActive: Bool) {
        let alarm = AlarmEntity(context: context)
        alarm.hours = Int32(hours)
        alarm.minutes = Int32(minutes)
        alarm.isActive = isActive
        alarm.name = name
        alarmModels.append(alarm)
        addAlertNotification(index: alarmModels.count - 1)
    }
    
    /// Метод обновления будильника.
    /// Вызывает функции обновления у всех view, соответвующих переданному индексу.
    func alarmUpdate(index: Int) {
        for function in functions[index]! {
            function.1(alarmModels[index].hours,
                       alarmModels[index].minutes,
                       alarmModels[index].name,
                       alarmModels[index].isActive)
        }
    }
    
    /// Событие изменения будильника, вызываемое view
    @objc private func alarmIsChanged(_ sender: Any?) {
        let view = sender as? AlarmView
        if let alarmView = view {
            alarmStatusChanged(id: alarmView.id)
        }
    }
    
    /// Изменение статуса будильника.
    /// Здесь происходит отписка от событие и смена статуса модели.
    func alarmStatusChanged(id: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(id)"])
        alarmModels[id].isActive = !alarmModels[id].isActive
        alarmUpdate(index: id)
    }
    
    /// Полное изменение будильника.
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
    
    /// Привязывание нового view к модели по индексу.
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
    
    /// Перетаргетирование существующего view к новой модели будильника.
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
    
    /// Открытие меню настройки будильника.
    func alarmConfigureWindowOpen(index: Int) {
        scene?.addViewControllerShow(mode: true, alarmIndex: index)
    }
    
    /// Генерация рандомного количества будильников.
    /// На даноом моменте нигде не используется, использовалось в предыдущих версиях программы.
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
    
    func getAlarmByIndex(_ index: Int) -> AlarmEntity {
        return alarmModels[index];
    }
}
