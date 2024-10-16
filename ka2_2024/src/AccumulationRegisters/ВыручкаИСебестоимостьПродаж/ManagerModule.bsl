#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//++ НЕ УТ

// Определяет показатели регистра.
//
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВыручки", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВыручкиСНДСРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалютеДокумента", "ВалютаДокумента"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВыручкиБезНДС", "ВалютаУпр"));
    МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВыручкиРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаБезНДСВВалютеДокумента", "ВалютаДокумента"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДС", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалютеВзаиморасчетов", "ВалютаВзаиморасчетов"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСВВалютеДокумента", "ВалютаДокумента"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СебестоимостьУпр", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СебестоимостьРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Себестоимость, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СтоимостьБезНДС", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СебестоимостьБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СебестоимостьРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СебестоимостьРегл, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "ДопРасходыУпр", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "ДопРасходыРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаДопРасходов, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "ДопРасходыБезНДС", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаДопРасходовБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаНДСДополнительныхРасходов", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаНДСДопРасходов, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "РезервПодОбесценениеУпр", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "РезервПодОбесценениеРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.РезервПодОбесценение, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "РасходыНаПродажуУпр", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "РасходыНаПродажуРегл", "ВалютаРегл"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаРасходовНаПродажу, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "РасходыНаПродажуБезНДС", "ВалютаУпр"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаРасходовНаПродажуБезНДС, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

//-- НЕ УТ

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ВыручкаИСебестоимостьПродаж.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийВыручкаИСебестоимостьПродаж"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	КлючиАналитикаУчетаПоПартнерам.Организация КАК Организация,
	|	&ИмяРегистра КАК ИмяРегистра,
	|	&Раздел КАК РазделДатыЗапрета
	|ИЗ
	|	&ИмяТаблицыИзменений КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|	ПО
	|		Таблица.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|";
	
	ИмяПараметраИмяРегистра = "ИмяРегистра" + ИмяРегистра;
	ИмяПараметраРаздел = "Раздел" + ИмяРегистра;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяРегистра", "&" + ИмяПараметраИмяРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Раздел", "&" + ИмяПараметраРаздел);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяТаблицыИзменений", ИмяТаблицыИзменений);
	
	Запрос.УстановитьПараметр(ИмяПараметраИмяРегистра, ИмяРегистра);
	Запрос.УстановитьПараметр(ИмяПараметраРаздел, "ФинансовыйКонтур");
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов

КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)
	|	И ЗначениеРазрешено(Т.Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли
