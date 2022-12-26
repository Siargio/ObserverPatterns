//Observer(наблюдатель)

import Foundation

//Тип, которому должны соответсвовать все наблюдатели
protocol Observer {
    func getNew(video: String)
}

//Тип, которому соответствует наблюдаемый субьект
protocol Subject {

    func add(observer: Observer)
    func remove(observer: Observer)
    func notification(video: String)
}

//Класс субьекта

class Bloger: Subject {

    var observers = NSMutableSet()

    var video: String = "" {
        didSet {
            notification(video: video)
        }
    }

    func add(observer: Observer) {
        observers.add(observer)
    }

    func remove(observer: Observer) {
        observers.remove(observer)
    }

    func notification(video: String) {
        for observer in observers {
            (observer as! Observer).getNew(video: video)
        }
    }
}

//Классы наблюдателей

class Subscriber: NSObject, Observer {
    var nickName: String

    init(nickName: String) {
        self.nickName = nickName
    }

    func getNew(video: String) {
        print("Пользователь \(nickName) получил новое виде \(video)")
    }
}

class Google: NSObject, Observer {
    func getNew(video: String) {
        print("Видео \(video) обрабатывается")
    }
}

let olga = Subscriber(nickName: "Olga!")
let anna = Subscriber(nickName: "Anna")
let google = Google()

let blogerVlad = Bloger()
blogerVlad.add(observer: olga)
blogerVlad.add(observer: anna)
blogerVlad.add(observer: google)

blogerVlad.video = "Паттерн Обсервер"

blogerVlad.remove(observer: anna)

blogerVlad.video = "Скоро на канале"
