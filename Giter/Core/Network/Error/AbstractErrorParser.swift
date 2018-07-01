import Foundation

//---Протокол для обработки ошибок
protocol AbstractErrorParser {
    /// Приводит ошибки к единому формату, внутренних ошибок приложения
    ///
    /// - Parameter result: исходная ошибка
    /// - Returns: внутренняя ошибка приложения
    func parse(result: Error) -> Error
    /// Анализирует http-ответ на наличие ошибок
    ///
    /// - Parameters:
    ///   - response: ответ сервера
    ///   - data: данные в теле ответа сервера
    ///   - error: ошибка сети или сервера при получении ответа
    /// - Returns: внутренняя ошибка приложения
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
}
