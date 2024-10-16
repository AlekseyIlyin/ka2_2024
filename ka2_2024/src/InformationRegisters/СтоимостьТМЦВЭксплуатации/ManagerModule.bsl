
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.СтоимостьТМЦВЭксплуатации.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.12.68";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1b7e2942-8187-457b-94d9-79201e91fb51");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СтоимостьТМЦВЭксплуатации.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Стоимость ТМЦ в эксплуатации"":
	|- заполняет новый регистр по данным документов.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.СтоимостьТМЦВЭксплуатации.ПолноеИмя());
	//++ Локализация
	Читаемые.Добавить(Метаданные.Документы.ВводОстатков.ПолноеИмя());
	//-- Локализация
	Читаемые.Добавить(Метаданные.Документы.ВводОстатковТМЦВЭксплуатации.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ВнутреннееПотребление.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.СтоимостьТМЦВЭксплуатации.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.СтоимостьТМЦВЭксплуатации.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Регистрирует данные для обработчика обновления ОбработатьДанныеДляПереходаНаНовуюВерсию
// 
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрСведений.СтоимостьТМЦВЭксплуатации";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор
	|
	|ИЗ
	|	Документ.ВводОстатковТМЦВЭксплуатации КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|
	|	И НЕ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СтоимостьТМЦВЭксплуатации КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = ДанныеДокумента.Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор
	|
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)
	|
	|	И НЕ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СтоимостьТМЦВЭксплуатации КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = ДанныеДокумента.Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор
	|
	|ИЗ
	|	Документ.ВнутреннееПотребление КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)
	|
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СтоимостьТМЦВЭксплуатации КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = ДанныеДокумента.Ссылка
	|			И НЕ ДанныеРегистра.РасчетСебестоимости)
	|
	//++ Локализация
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор
	|
	|ИЗ
	|	Документ.ВводОстатков КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Проведен
	|	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковТМЦВЭксплуатации)
	|
	|	И НЕ ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СтоимостьТМЦВЭксплуатации КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = ДанныеДокумента.Ссылка)
	//-- Локализация
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "РегистрСведений.СтоимостьТМЦВЭксплуатации";
	ИмяОбъекта = "СтоимостьТМЦВЭксплуатации";
	
	ДополнительныеПараметрыОтметкиОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметкиОбработки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметкиОбработки.ПолноеИмяРегистра = ПолноеИмяОбъекта;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для Каждого Выборка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СтоимостьТМЦВЭксплуатации.НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(Выборка.Регистратор));
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Регистратор);
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.СтоимостьТМЦВЭксплуатации.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Регистратор, "Проведен") = Истина Тогда
				
				ТипДокумента = ТипЗнч(Выборка.Регистратор);
				
				Если ТипДокумента = Тип("ДокументСсылка.ВводОстатков")
					ИЛИ ТипДокумента = Тип("ДокументСсылка.ВводОстатковТМЦВЭксплуатации") Тогда
					
					ТаблицаРегистра = Неопределено;
					
					МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Регистратор);
					ТаблицыДляДвижений = МенеджерДокумента.ДанныеДокументаДляПроведения(Выборка.Регистратор, ИмяОбъекта);
					ТаблицыДляДвижений.Свойство("Таблица" + ИмяОбъекта, ТаблицаРегистра);
					
					Если ТаблицаРегистра <> Неопределено Тогда
						НаборЗаписей.Загрузить(ТаблицаРегистра);
					КонецЕсли;
					
				ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВнутреннееПотребление") Тогда
					
					// Получение стоимости аналогично формированию проводок
					ТекстЗапроса = 
					"ВЫБРАТЬ
					|	Таблица.Ссылка.Дата               КАК Период,
					|	Таблица.Ссылка.Организация        КАК Организация,
					|	Таблица.Номенклатура              КАК Номенклатура,
					|	Таблица.Характеристика            КАК Характеристика,
					|	Таблица.Серия                     КАК Серия,
					|	Таблица.ИнвентарныйНомер          КАК ИнвентарныйНомер,
					|	Таблица.Партия                    КАК Партия,
					|	Таблица.ИдентификаторСтроки       КАК ИдентификаторСтроки,
					|
					|	ИСТИНА КАК РасчетСебестоимости,
					|	
					|	СУММА(ЕСТЬNULL(Стоимости.Количество, 0)) КАК Количество,
					|
					|	СУММА(ЕСТЬNULL(Стоимости.СтоимостьРегл, 0) 
					|			+ ЕСТЬNULL(Стоимости.ДопРасходыРегл, 0) 
					|			+ ЕСТЬNULL(Стоимости.ТрудозатратыРегл, 0) 
					|			+ ЕСТЬNULL(Стоимости.ПостатейныеПостоянныеРегл, 0)
					|			+ ЕСТЬNULL(Стоимости.ПостатейныеПеременныеРегл, 0) 
					|			+ ВЫБОР 
					|				КОГДА ЕСТЬNULL(Стоимости.РазделУчета, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
					|					ТОГДА ЕСТЬNULL(Стоимости.СтоимостьЗабалансоваяРегл, 0) 
					|				ИНАЧЕ 0 КОНЕЦ) КАК СтоимостьРегл,
					|
					|	СУММА(ЕСТЬNULL(Стоимости.СтоимостьУпр, 0)
					|			+ ЕСТЬNULL(Стоимости.ДопРасходыУпр, 0) 
					|			+ ЕСТЬNULL(Стоимости.ТрудозатратыУпр, 0)
					|			+ ЕСТЬNULL(Стоимости.ПостатейныеПостоянныеУпр, 0) 
					|			+ ЕСТЬNULL(Стоимости.ПостатейныеПеременныеУпр, 0)) КАК СтоимостьУпр
					|
					|ИЗ
					|	Документ.ВнутреннееПотребление.Товары КАК Таблица
					|	
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК Стоимости
					|		ПО Таблица.Ссылка = Стоимости.Регистратор
					|			И Таблица.ИдентификаторСтроки = Стоимости.ИдентификаторСтроки
					|
					|ГДЕ
					|	Таблица.Ссылка = &Регистратор
					|	И Таблица.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)
					|	И Таблица.Ссылка.Проведен
					|
					|СГРУППИРОВАТЬ ПО
					|	Таблица.Ссылка.Дата,
					|	Таблица.Ссылка.Организация,
					|	Таблица.Номенклатура,
					|	Таблица.Характеристика,
					|	Таблица.Серия,
					|	Таблица.ИнвентарныйНомер,
					|	Таблица.Партия,
					|	Таблица.ИдентификаторСтроки
					|";
					
					Запрос = Новый Запрос(ТекстЗапроса);
					Запрос.УстановитьПараметр("Регистратор", Выборка.Регистратор);
					
					ТаблицаРегистра = Запрос.Выполнить().Выгрузить();
					Если ТаблицаРегистра.Количество() <> 0 Тогда
						НаборЗаписей.Загрузить(ТаблицаРегистра);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если НаборЗаписей.Модифицированность() Тогда
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			Иначе
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(
					Выборка.Регистратор, 
					ДополнительныеПараметрыОтметкиОбработки, 
					Параметры.Очередь);
					
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Регистратор);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
