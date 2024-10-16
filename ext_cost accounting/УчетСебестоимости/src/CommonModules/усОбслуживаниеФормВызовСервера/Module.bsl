#Область СлужебныйПрограммныйИнтерфейс

Функция усНоваяТаблицаПартий(ВыборкаПартийПоНоменклатуре) Экспорт
	
	ВыборкаПоПартиям = ВыборкаПартийПоНоменклатуре.Выбрать();
	
	ТаблицаПартий = Новый ТаблицаЗначений();
	ТаблицаПартий.Колонки.Добавить("Партия", Метаданные.ОпределяемыеТипы.ДокументПартии.Тип);
	ТаблицаПартий.Колонки.Добавить("Количество", Метаданные.ОпределяемыеТипы.ДенежнаяСуммаНеотрицательная.Тип);
	ТаблицаПартий.Колонки.Добавить("Стоимость", Метаданные.ОпределяемыеТипы.ДенежнаяСуммаНеотрицательная.Тип);
	
	Пока ВыборкаПоПартиям.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаПартий.Добавить(), ВыборкаПоПартиям); 
		
		//СтрокаПартии = Новый Структура("Партия,КоличествоОстаток,СтоимостьОстаток");
		//	ЗаполнитьЗначенияСвойств(СтрокаПартии, ВыборкаПоПартиям);
		//	
		//	Если ЗначениеЗаполнено(ВыборкаПоПартиям.Партия) Тогда
		//		ПредставлениеПартии = Формат(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаПоПартиям.Партия, "Дата"), "ДЛФ=D;");
		//	Иначе
		//		ПредставлениеПартии = "----------";
		//	КонецЕсли;
		//	
		//	Если ВыборкаПоПартиям.КоличествоОстаток <> 0 И ВыборкаПоПартиям.СтоимостьОстаток <> 0 Тогда
		//		ПредставлениеСебестоимости = Формат(ВыборкаПоПартиям.СтоимостьОстаток / ВыборкаПоПартиям.КоличествоОстаток, "ЧДЦ=2; ЧГ=;");
		//	Иначе
		//		ПредставлениеСебестоимости = "0.00"
		//	КонецЕсли;
		//	
		//	СтрокаПартии.Партия = СтрШаблон("%1 : %2", ПредставлениеПартии, ПредставлениеСебестоимости);
		//	СведенияПоПартиям.Добавить(СтрокаПартии);
		//КонецЦикла;
		//
		//Результат.Вставить(ВыборкаПоНоменклатуре.Номенклатура, СведенияПоПартиям);
		
	КонецЦикла;
	
	Возврат ТаблицаПартий;
	
КонецФункции

Функция ОстаткиПартийПоНоменклатуре(Регистратор, Знач Дата, Знач Склад, Знач СписокНоменклатуры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса_ОстаткиПартийПоНоменклатуре();
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	Запрос.УстановитьПараметр("Граница", КонецДня(Дата));  
	Запрос.УстановитьПараметр("ДатаРегистратора", Дата);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	Результат = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат Результат;
КонецФункции

Функция усЭтоФормаДляОтображенияСтоимости(ИмяФормы) Экспорт
	Возврат ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента";
КонецФункции

Функция усОбновитьСебестоимостьМаржу(Знач ОбъектФормы) Экспорт
	ДанныеСебестоимостиПоСтрокам = Новый Массив;
	СписокНоменклатуры = ОбъектФормы.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	ВыборкаПартийПоНоменклатуре = ОстаткиПартийПоНоменклатуре(ОбъектФормы.Ссылка, ОбъектФормы.Дата, ОбъектФормы.Склад, СписокНоменклатуры);
	Для Каждого СтрокаТовары Из ОбъектФормы.Товары Цикл
		ВыборкаПартийПоНоменклатуре.Сбросить();
		Если ВыборкаПартийПоНоменклатуре.НайтиСледующий(СтрокаТовары.Номенклатура, "Номенклатура") Тогда
			ДанныеСебестоимости = Новый Структура("усУчетнаяЦена,усМаржа,усПроцентМаржи");
			ДанныеСебестоимости.Вставить("СуммаСНДС", СтрокаТовары.СуммаСНДС);
			ДанныеСебестоимости.Вставить("Количество", СтрокаТовары.Количество);
			ДанныеСебестоимости.Вставить("ИдентификаторСтрокиСебестоимость", СтрокаТовары.ПолучитьИдентификатор());

			ТаблицаПартий = усНоваяТаблицаПартий(ВыборкаПартийПоНоменклатуре);
			усЗаполнитьСтоимостьМаржу(ДанныеСебестоимости, ТаблицаПартий);
			ДанныеСебестоимостиПоСтрокам.Добавить(ДанныеСебестоимости);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеСебестоимостиПоСтрокам;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура усЗаполнитьСтоимостьМаржу(СтрокаТовары, ТаблицаПартий)
	
	КоличествоРаспределяемое = СтрокаТовары.Количество;
	
	КоличествоПодобранное = 0;
	СтоимостьПодобранная = 0;
	Для Каждого СтрокаТаблицыПартий Из ТаблицаПартий Цикл
		Если СтрокаТаблицыПартий.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		Если КоличествоРаспределяемое = 0 Тогда
			Прервать;
		КонецЕсли;
		
		КоличествоСписанное = Мин(КоличествоРаспределяемое, СтрокаТаблицыПартий.Количество);
		
		СтоимостьСписанная = ?(КоличествоСписанное = СтрокаТаблицыПартий.Количество,
			СтрокаТаблицыПартий.Стоимость,
			СтрокаТаблицыПартий.Стоимость / СтрокаТаблицыПартий.Количество * КоличествоСписанное);
		
		КоличествоПодобранное = КоличествоПодобранное + КоличествоСписанное;
		СтоимостьПодобранная = СтоимостьПодобранная + СтоимостьСписанная;
		
		КоличествоРаспределяемое = КоличествоРаспределяемое - КоличествоСписанное;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КоличествоПодобранное) Тогда
		СтрокаТовары.усУчетнаяЦена = СтоимостьПодобранная / КоличествоПодобранное;	
	Иначе
		СтрокаТовары.усУчетнаяЦена = 0;
	КонецЕсли;
	
	Если КоличествоРаспределяемое = 0 
			И КоличествоСписанное <> 0 Тогда
		СтрокаТовары.усМаржа = СтрокаТовары.СуммаСНДС - СтоимостьПодобранная;
		Если СтрокаТовары.СуммаСНДС <> 0 Тогда
			СтрокаТовары.усПроцентМаржи = 100 - СтоимостьПодобранная / СтрокаТовары.СуммаСНДС * 100; 
		КонецЕсли;
	Иначе
		СтрокаТовары.усМаржа = 0; 
		СтрокаТовары.усПроцентМаржи = 0;
	КонецЕсли;
	
КонецПроцедуры

#Область ТекстыЗапросов

Функция ТекстЗапроса_ОстаткиПартийПоНоменклатуре()

	Возврат "ВЫБРАТЬ
	        |	Номенклатура.Ссылка КАК Номенклатура,
	        |	&Склад КАК Склад
	        |ПОМЕСТИТЬ ВТ_Товары
	        |ИЗ
	        |	Справочник.Номенклатура КАК Номенклатура
	        |ГДЕ
	        |	Номенклатура.Ссылка В(&СписокНоменклатуры)
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	КлючиАналитикиУчетаНоменклатуры.Ссылка КАК АналитикаУчетаНоменклатуры,
	        |	ВТ_Товары.Номенклатура КАК Номенклатура
	        |ПОМЕСТИТЬ ВТ_АналитикаНоменклатуры
	        |ИЗ
	        |	ВТ_Товары КАК ВТ_Товары
	        |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	        |		ПО ВТ_Товары.Номенклатура = КлючиАналитикиУчетаНоменклатуры.Номенклатура
	        |			И ВТ_Товары.Склад = КлючиАналитикиУчетаНоменклатуры.МестоХранения
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	КлючиАналитикиУчетаНоменклатуры.Ссылка,
	        |	ВТ_Товары.Номенклатура
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	усОстаткиПоПартиямОстатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	        |	усОстаткиПоПартиямОстатки.Партия КАК Партия,
	        |	усОстаткиПоПартиямОстатки.КоличествоОстаток КАК Количество,
	        |	усОстаткиПоПартиямОстатки.СтоимостьОстаток КАК Стоимость,
	        |	1 КАК Приоритет
	        |ИЗ
	        |	РегистрНакопления.усОстаткиПоПартиям.Остатки(
	        |			&Граница,
	        |			АналитикаУчетаНоменклатуры В
	        |				(ВЫБРАТЬ
	        |					ВТ_АналитикаНоменклатуры.АналитикаУчетаНоменклатуры
	        |				ИЗ
	        |					ВТ_АналитикаНоменклатуры КАК ВТ_АналитикаНоменклатуры)) КАК усОстаткиПоПартиямОстатки
	        |ГДЕ
	        |	усОстаткиПоПартиямОстатки.КоличествоОстаток > 0
	        |
	        |ОБЪЕДИНИТЬ ВСЕ
	        |
	        |ВЫБРАТЬ
	        |	усОстаткиПоПартиямОстаткиИОбороты.АналитикаУчетаНоменклатуры.Номенклатура,
	        |	усОстаткиПоПартиямОстаткиИОбороты.Партия,
	        |	СУММА(усОстаткиПоПартиямОстаткиИОбороты.КоличествоРасход),
	        |	СУММА(усОстаткиПоПартиямОстаткиИОбороты.СтоимостьРасход),
	        |	0
	        |ИЗ
	        |	РегистрНакопления.усОстаткиПоПартиям.ОстаткиИОбороты(
	        |			&ДатаРегистратора,
	        |			&ДатаРегистратора,
	        |			Регистратор,
	        |			Движения,
	        |			АналитикаУчетаНоменклатуры В
	        |				(ВЫБРАТЬ
	        |					ВТ_АналитикаНоменклатуры.АналитикаУчетаНоменклатуры
	        |				ИЗ
	        |					ВТ_АналитикаНоменклатуры КАК ВТ_АналитикаНоменклатуры)) КАК усОстаткиПоПартиямОстаткиИОбороты
	        |ГДЕ
	        |	усОстаткиПоПартиямОстаткиИОбороты.Регистратор = &Регистратор
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	усОстаткиПоПартиямОстаткиИОбороты.АналитикаУчетаНоменклатуры.Номенклатура,
	        |	усОстаткиПоПартиямОстаткиИОбороты.Партия
	        |
	        |УПОРЯДОЧИТЬ ПО
	        |	Приоритет,
	        |	Партия
	        |ИТОГИ ПО
	        |	Номенклатура";	

КонецФункции

#КонецОбласти

#КонецОбласти