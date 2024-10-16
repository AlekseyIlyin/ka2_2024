#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//  КомандыОтчетов - ТаблицаЗначений - описание в ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
// 	СтрокаТаблицыЗначений - добавленная команда 
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ДеревоСебестоимостиПродукции) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Идентификатор               = Метаданные.Отчеты.ДеревоСебестоимостиПродукции.ПолноеИмя();
		КомандаОтчет.Менеджер                    = "Отчет.ДеревоСебестоимостиПродукции";
		КомандаОтчет.Представление               = НСтр("ru = 'Дерево себестоимости продукции'");
		КомандаОтчет.МножественныйВыбор          = Ложь;
		КомандаОтчет.Важность                    = "Обычное";
		КомандаОтчет.ФункциональныеОпции         = "ИспользоватьУправлениеПроизводством2_2";
		КомандаОтчет.РежимЗаписи                 = "Проводить";
		
		КомандаОтчет.КлючВарианта                = "ДеревоСебестоимостиПродукцииКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДеревоСебестоимости") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФормуДеревоСебестоимости(ПараметрыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ДеревоСебестоимости",
			НСтр("ru = 'Дерево себестоимости'"),
			ТабличныйДокумент);
		
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуДеревоСебестоимости(ПараметрыПечати)
	
	РезультатФормирования = ПолучитьИзВременногоХранилища(ПараметрыПечати.АдресДереваВХранилище);
	
	УдалитьИзВременногоХранилища(ПараметрыПечати.АдресДереваВХранилище);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДеревоСебестоимости";
	
	Макет = Отчеты.ДеревоСебестоимостиПродукции.ПолучитьМакет("ДеревоСебестоимости");
	
	ПараметрыОтчета = ПараметрыПечати.ПараметрыОтчета;
	
	ДетализироватьСтоимостьДоСоставляющих = ПараметрыОтчета.ДетализироватьСтоимостьДоСоставляющих;
	
	Если ДетализироватьСтоимостьДоСоставляющих Тогда
		СуффиксИмениОбласти = "";
	Иначе
		СуффиксИмениОбласти = "|ДанныеБезРасшифровки";
	КонецЕсли;
	ПериодОтчета = ПараметрыОтчета.Период; //СтандартныйПериод
	
	ОбластьМакета = Макет.ПолучитьОбласть(СтрШаблон("Заголовок%1", СуффиксИмениОбласти));
	ОбластьМакета.Параметры.ТекстЗаголовка = СтрШаблон(
		НСтр("ru = 'Дерево себестоимости за период с %1 по %2'"),
		Формат(ПериодОтчета.ДатаНачала, "ДЛФ=Д"),
		Формат(ПериодОтчета.ДатаОкончания, "ДЛФ=Д"));
		
	ТабДокумент.Вывести(ОбластьМакета);
	
	ПредставлениеДанныхПоСебестоимости = Новый Соответствие;
	ПредставлениеДанныхПоСебестоимости.Вставить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
	ПредставлениеДанныхПоСебестоимости.Вставить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
	ПредставлениеДанныхПоСебестоимости.Вставить(3, НСтр("ru = 'В валюте упр. учета'"));
	ПредставлениеДанныхПоСебестоимости.Вставить(4, НСтр("ru = 'В валюте регл. учета'"));
		
	ОбластьМакета = Макет.ПолучитьОбласть(СтрШаблон("Отбор%1", СуффиксИмениОбласти));
	ОбластьМакета.Параметры.ПредставлениеОтбора = СтрШаблон(
		НСтр("ru = 'Данные по себестоимости: %1'"), 
		ПредставлениеДанныхПоСебестоимости.Получить(ПараметрыОтчета.ДанныеПоСебестоимости));
			
	ТабДокумент.Вывести(ОбластьМакета);
			
	Отбор = ПолучитьИзВременногоХранилища(ПараметрыПечати.АдресОтбораВХранилище); //ОтборКомпоновкиДанных
	
	Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
		
		Если ЭлементОтбора.Использование Тогда
		
			ОбластьМакета = Макет.ПолучитьОбласть(СтрШаблон("Отбор%1", СуффиксИмениОбласти));
			ОбластьМакета.Параметры.ПредставлениеОтбора = СтрШаблон(
				"%1 %2 %3",
				ЭлементОтбора.ЛевоеЗначение,
				ЭлементОтбора.ВидСравнения,
				ЭлементОтбора.ПравоеЗначение);
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть(СтрШаблон("ШапкаТаблицы%1", СуффиксИмениОбласти));
	ТабДокумент.Вывести(ОбластьМакета);
	
	Уровень = 1;
	ТабДокумент.НачатьАвтогруппировкуСтрок();
	
	Для Каждого Строка Из РезультатФормирования.ДеревоСебестоимости.Строки Цикл
		
		ВывестиСтрокуДереваСебестоимости(ТабДокумент, Макет, Строка, Уровень, ДетализироватьСтоимостьДоСоставляющих);
		
	КонецЦикла;
	
	ТабДокумент.ЗакончитьАвтогруппировкуСтрок();
	
	ОбластьМакета = Макет.ПолучитьОбласть(СтрШаблон("Подвал%1", СуффиксИмениОбласти));
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Если ДетализироватьСтоимостьДоСоставляющих Тогда
		ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Иначе
		ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	КонецЕсли;
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура ВывестиСтрокуДереваСебестоимости(ТабДокумент, Макет, СтрокаДерева, Знач Уровень, ДетализироватьСтоимостьДоСоставляющих)
	
	Если ДетализироватьСтоимостьДоСоставляющих Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("Строка|ДанныеБезРасшифровки");
	КонецЕсли;
	
	ОбластьМакета.Параметры.Заполнить(СтрокаДерева);
	ОбластьМакета.Параметры.НоменклатураПредставление = СформироватьПредставлениеНоменклатуры(
		СтрокаДерева, 
		"Номенклатура,Характеристика,Серия,Назначение,Валюта");
	ОбластьСтрока = ТабДокумент.Вывести(ОбластьМакета, Уровень);
	ТабДокумент.Область(ОбластьСтрока.Верх, 2).Отступ = Уровень - 1;
	
	Если СтрокаДерева.Строки.Количество() > 0 Тогда
		
		Для Каждого Строка Из СтрокаДерева.Строки Цикл
			
			ВывестиСтрокуДереваСебестоимости(ТабДокумент, Макет, Строка, Уровень + 1, ДетализироватьСтоимостьДоСоставляющих);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПредставлениеНоменклатуры(СтрокаДерева, ФорматПредставления)
	
	ПоляПредставления = СтрРазделить(ФорматПредставления, ",");
	ЧастиПредставления = Новый Массив;
	
	Для Каждого Поле Из ПоляПредставления Цикл
		Если ЗначениеЗаполнено(СтрокаДерева[Поле]) Тогда
			ЧастиПредставления.Добавить(СтрокаДерева[Поле]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(ЧастиПредставления, ", ");
	
КонецФункции

#КонецОбласти
		
#КонецЕсли