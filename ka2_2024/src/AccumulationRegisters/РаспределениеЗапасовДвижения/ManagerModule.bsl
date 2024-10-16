#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция Регистраторы() Экспорт
	
	Массив = Новый Массив(1);
	
	Типы = РегистрыНакопления.РаспределениеЗапасовДвижения.СоздатьНаборЗаписей().Отбор.Регистратор.ТипЗначения.Типы();
	
	ВсеРегистраторы = Новый Массив();
	
	Для Каждого Элемент Из Типы Цикл
		
		Если Элемент = Тип("ДокументСсылка.КорректировкаРегистров") Тогда
			Продолжить;
		КонецЕсли;
		
		ПропуститьДокумент = Ложь;
		Если Элемент = Тип("ДокументСсылка.ВводОстатков") Тогда
			ПропуститьДокумент = Истина;
			//++ Локализация
			ПропуститьДокумент = Ложь;
			//-- Локализация
		КонецЕсли;
		
		Если ПропуститьДокумент Тогда
			Продолжить;
		КонецЕсли;
		
		Массив[0] = Элемент;
		ОписаниеТипов = Новый ОписаниеТипов(Массив);
		Ссылка = ОписаниеТипов.ПривестиЗначение(Неопределено);
		ВсеРегистраторы.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(Ссылка));
		
	КонецЦикла;
	
	Возврат ВсеРегистраторы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.РаспределениеЗапасовДвижения.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.12.136";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("5f98ee9b-5b8d-429e-9d71-ca0d1518d5b5");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.РаспределениеЗапасовДвижения.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет движения по необособленным работам и обновляет график поступления по динамическим этапам производства.
	|Исправляет неверные движения исправительных документов и документа ""Сторно"",
	|а также неверные движения документов закупки по неотфактурованным поставкам работ'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.АктВыполненныхРабот.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.АктОРасхожденияхПослеПеремещения.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказКлиента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаказПоставщику.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.КорректировкаПриобретения.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.КорректировкаРеализации.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ОтчетОРозничныхПродажах.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПередачаТоваровМеждуОрганизациями.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеТоваровОтХранителя.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриобретениеТоваровУслуг.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЧекККМ.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЧекККМВозврат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЧекККМКоррекции.ПолноеИмя());
	//++ НЕ УТ

	//++ Локализация
	Читаемые.Добавить(Метаданные.Документы.ВыпускПродукции.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПеремещениеМатериаловВПроизводстве.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СписаниеЗатратНаВыпуск.ПолноеИмя());
	//-- Локализация

	//-- НЕ УТ


	//++ НЕ УТ
	Читаемые.Добавить(Метаданные.Документы.АктВыполненныхВнутреннихРабот.ПолноеИмя());
	//++ Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ЗаказПереработчику.ПолноеИмя());
	//-- Устарело_Переработка24
	Читаемые.Добавить(Метаданные.Документы.ПроизводствоБезЗаказа.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РаспределениеВозвратныхОтходов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РаспределениеПроизводственныхЗатрат.ПолноеИмя());

	//-- НЕ УТ
	
	Читаемые.Добавить(Метаданные.Документы.СборкаТоваров.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриемкаТоваровНаХранение.ПолноеИмя());
	//++ НЕ УТ
	Читаемые.Добавить(Метаданные.Документы.ДвижениеПродукцииИМатериалов.ПолноеИмя());
	//-- НЕ УТ
	Читаемые.Добавить(Метаданные.Документы.ПрочееОприходованиеТоваров.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя());
	
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РаспределениеЗапасовДвижения.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ТоварыОрганизаций.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаказыКлиентов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ЗаявкаНаВозвратТоваровОтКлиента.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
КонецПроцедуры

// Возвращаемое значение:
//  Массив из Строка
Функция ТипыРегистраторовДляПерепроведенияВОбработчикеОбновления() Экспорт
	
	ТипыРегистраторов = Новый Массив();
	ТипыРегистраторов.Добавить("Документ.АктВыполненныхРабот");
	ТипыРегистраторов.Добавить("Документ.АктОРасхожденияхПослеПеремещения");
	ТипыРегистраторов.Добавить("Документ.ЗаказКлиента");
	ТипыРегистраторов.Добавить("Документ.ЗаказПоставщику");
	ТипыРегистраторов.Добавить("Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	ТипыРегистраторов.Добавить("Документ.КорректировкаПриобретения");
	ТипыРегистраторов.Добавить("Документ.КорректировкаРеализации");
	ТипыРегистраторов.Добавить("Документ.ОтчетОРозничныхПродажах");
	ТипыРегистраторов.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	ТипыРегистраторов.Добавить("Документ.ПоступлениеТоваровОтХранителя");
	ТипыРегистраторов.Добавить("Документ.ПриобретениеТоваровУслуг");
	ТипыРегистраторов.Добавить("Документ.РеализацияТоваровУслуг");
	ТипыРегистраторов.Добавить("Документ.ЧекККМ");
	ТипыРегистраторов.Добавить("Документ.ЧекККМВозврат");
	ТипыРегистраторов.Добавить("Документ.ЧекККМКоррекции");
	//++ НЕ УТ

	//++ Локализация
	ТипыРегистраторов.Добавить("Документ.ВыпускПродукции");
	ТипыРегистраторов.Добавить("Документ.ПеремещениеМатериаловВПроизводстве");
	ТипыРегистраторов.Добавить("Документ.СписаниеЗатратНаВыпуск");
	//-- Локализация

	//-- НЕ УТ


	//++ НЕ УТ
	ТипыРегистраторов.Добавить("Документ.АктВыполненныхВнутреннихРабот");
	//++ Устарело_Переработка24
	ТипыРегистраторов.Добавить("Документ.ЗаказПереработчику");
	//-- Устарело_Переработка24
	ТипыРегистраторов.Добавить("Документ.ПроизводствоБезЗаказа");
	ТипыРегистраторов.Добавить("Документ.РаспределениеВозвратныхОтходов");
	ТипыРегистраторов.Добавить("Документ.РаспределениеПроизводственныхЗатрат");

	//-- НЕ УТ
	ТипыРегистраторов.Добавить("Документ.Сторно");
	
	ТипыРегистраторов.Добавить("Документ.СборкаТоваров");
	ТипыРегистраторов.Добавить("Документ.ПриемкаТоваровНаХранение");
	//++ НЕ УТ
	ТипыРегистраторов.Добавить("Документ.ДвижениеПродукцииИМатериалов");
	//-- НЕ УТ
	ТипыРегистраторов.Добавить("Документ.ПрочееОприходованиеТоваров");
	ТипыРегистраторов.Добавить("Документ.ПеремещениеТоваров");
	
	Возврат ТипыРегистраторов;
	
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.РаспределениеЗапасовДвижения";
	
	ТипыРегистраторов = ТипыРегистраторовДляПерепроведенияВОбработчикеОбновления();
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(ТипыРегистраторов, ",");
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	ИмяРегистра = "РаспределениеЗапасовДвижения";
	Регистры = Новый Структура(ИмяРегистра);
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ПолучитьТекстыЗапроса = Истина;
	
	ДопПараметры.ДополнительныеСвойства = Новый Структура();
	ДопПараметры.ДополнительныеСвойства.Вставить("ОбновлениеРеквизитаЭтоЗаказКакСчетНеВыполнялось");
	
	ЗначенияПараметров = РаспределениеЗапасовДвижения.ЗначенияПараметровДляТекстовЗапросовПроведенияДокументов();
	Для Каждого ПолноеИмяДокумента Из ТипыРегистраторов Цикл
		
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстыЗапроса = Документы[ИмяДокумента].ДанныеДокументаДляПроведения(Неопределено, Регистры, ДопПараметры);
		Тексты = Новый Массив();
		Для Каждого Элемент Из ТекстыЗапроса Цикл
			Если Элемент.Представление = "РаспределениеЗапасовДвижения" Тогда
				Тексты.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
		ТекстЗапроса = СтрСоединить(Тексты, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Ссылка) = &Ссылка", ".Ссылка.Проведен)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Ссылка В (&Ссылка)", ".Ссылка.Проведен");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ".Ссылка) В (&Ссылка)", ".Ссылка.Проведен)");
		
		РезультатАдаптации = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
		
		РезультатАдаптации.ЗначенияПараметров = ЗначенияПараметров;
		РезультатАдаптации.ТекстЗапроса = ТекстЗапроса;
		Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
			РезультатАдаптации, ПолноеИмяРегистра, ПолноеИмяДокумента);
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, "РегистрНакопления.РаспределениеЗапасовДвижения") Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "Документ.ЗаказКлиента")
				Или Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Неопределено, "Документ.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТипыРегистраторов = ТипыРегистраторовДляПерепроведенияВОбработчикеОбновления();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазыУТ.ДополнительныеПараметрыПерезаписиДвиженийИзОчереди();
	ДополнительныеПараметры.ОбновляемыеДанные = Параметры.ОбновляемыеДанные;
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		ТипыРегистраторов, "РегистрНакопления.РаспределениеЗапасовДвижения", Параметры.Очередь, ДополнительныеПараметры);
		
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

Функция ТекстЗапросаИсправленныеДвижения() Экспорт
	
	ТекстГруппировки = "";
	Регистраторы = Регистраторы();
	
	ИмяРегистра = "РаспределениеЗапасовДвижения";
	Регистры = Новый Структура(ИмяРегистра);
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ПолучитьТекстыЗапроса = Истина;
	
	ТекстыИтоговые = Новый Массив();
	Типы = Новый Массив();
	Для Каждого ПолноеИмяДокумента Из Регистраторы Цикл
		
		ОбработатьДокумент = Ложь;
		Если ПолноеИмяДокумента = "Документ.ПриобретениеТоваровУслуг" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОтчетОРозничныхПродажах" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПоступлениеТоваровНаСклад" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОтчетОРозничныхВозвратах" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ЧекККМКоррекции" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.АктОРасхожденияхПослеПриемки" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.РеализацияТоваровУслуг" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПередачаТоваровХранителю" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.АктВыполненныхРабот" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ЗаявкаНаВозвратТоваровОтКлиента" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.АктОРасхожденияхПослеОтгрузки" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПриемкаТоваровНаХранение" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПриходныйОрдерНаТовары" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОрдерНаОтражениеИзлишковТоваров" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОрдерНаОтражениеНедостачТоваров" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОрдерНаОтражениеПересортицыТоваров" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ОрдерНаОтражениеПорчиТоваров" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.КорректировкаПоОрдеруНаТовары" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.КорректировкаИзлишковНедостачПоТоварнымМестам" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПересчетТоваров" Тогда
			ОбработатьДокумент = Истина;
		//++ НЕ УТ
		ИначеЕсли ПолноеИмяДокумента = "Документ.РаспределениеВозвратныхОтходов" Тогда
			ОбработатьДокумент = Истина;
		//++ Устарело_Переработка24
		ИначеЕсли ПолноеИмяДокумента = "Документ.ЗаказПереработчику" Тогда
			ОбработатьДокумент = Истина;
		ИначеЕсли ПолноеИмяДокумента = "Документ.ПередачаСырьяПереработчику" Тогда
			ОбработатьДокумент = Истина;
		//-- Устарело_Переработка24
		//++ Устарело_Производство21
		ИначеЕсли ПолноеИмяДокумента = "Документ.ВыпускПродукции" Тогда
			ОбработатьДокумент = Истина;
		//-- Устарело_Производство21
		ИначеЕсли ПолноеИмяДокумента = "Документ.ДвижениеПродукцииИМатериалов" Тогда
			ОбработатьДокумент = Истина;
		//-- НЕ УТ
		КонецЕсли;
		Если Не ОбработатьДокумент Тогда
			Продолжить;
		КонецЕсли;
		
		Типы.Добавить(СтрШаблон("ТИП(%1)", ПолноеИмяДокумента));
		
		ТекстЗапроса = РаспределениеЗапасовДвижения.ТекстыЗапросовПроведенияДокументов(ПолноеИмяДокумента, "РаспределениеЗапасовДвижения");
		ТекстыИтоговые.Добавить(ТекстЗапроса);
		
	КонецЦикла;
	
	ВложенныйЗапрос = СтрСоединить(ТекстыИтоговые, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрНакопления.РаспределениеЗапасовДвижения КАК Таблица";
	
	Если ТекстыИтоговые.Количество() > 0 И Не Запрос.Выполнить().Пустой() Тогда
		
		ТекстГруппировки =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Набор.Номенклатура                    КАК Номенклатура,
			|	Набор.Характеристика                  КАК Характеристика,
			|	Набор.Склад                           КАК Склад,
			|	Набор.Назначение                      КАК Назначение
			|ПОМЕСТИТЬ ПроблемныеПозиции
			|ИЗ(
			|	ВЫБРАТЬ
			|		Таблица.Регистратор              КАК Регистратор,
			|		Таблица.Период                   КАК Период,
			|		Таблица.Номенклатура             КАК Номенклатура,
			|		Таблица.Характеристика           КАК Характеристика,
			|		Таблица.Склад                    КАК Склад,
			|		Таблица.Назначение               КАК Назначение,
			|		Таблица.ЗаказНаОтгрузку          КАК ЗаказНаОтгрузку,
			|		Таблица.ЖелаемаяДатаОтгрузки     КАК ЖелаемаяДатаОтгрузки,
			|		Таблица.ЗаказНаПоступление       КАК ЗаказНаПоступление,
			|		Таблица.ДатаПоступления          КАК ДатаПоступления,
			|		Таблица.Отгрузить                КАК Отгрузить,
			|		Таблица.Резервировать            КАК Резервировать,
			|		Таблица.РезервироватьПоМереПоступления КАК РезервироватьПоМереПоступления,
			|		Таблица.КОбеспечениюБезРезерва   КАК КОбеспечению,
			|		Таблица.НеОбеспечивать           КАК НеОбеспечивать,
			|		Таблица.Поступило                КАК Поступило,
			|		Таблица.ПоступитКДате            КАК ПоступитКДате,
			|		Таблица.ПоставкаНаСогласовании   КАК ПоставкаНаСогласовании,
			|		Таблица.ЗакрытьГрафикПоступления КАК ЗакрытьГрафикПоступления
			|	ИЗ
			|		&ВложенныйЗапрос КАК Таблица
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Таблица.Регистратор               КАК Регистратор,
			|		Таблица.Период                    КАК Период,
			|		Таблица.Номенклатура              КАК Номенклатура,
			|		Таблица.Характеристика            КАК Характеристика,
			|		Таблица.Склад                     КАК Склад,
			|		Таблица.Назначение                КАК Назначение,
			|		Таблица.ЗаказНаОтгрузку           КАК ЗаказНаОтгрузку,
			|		Таблица.ЖелаемаяДатаОтгрузки      КАК ЖелаемаяДатаОтгрузки,
			|		Таблица.ЗаказНаПоступление        КАК ЗаказНаПоступление,
			|		Таблица.ДатаПоступления           КАК ДатаПоступления,
			|		-Таблица.Отгрузить                КАК Отгрузить,
			|		-Таблица.Резервировать            КАК Резервировать,
			|		-Таблица.РезервироватьПоМереПоступления КАК РезервироватьПоМереПоступления,
			|		-Таблица.КОбеспечениюБезРезерва   КАК КОбеспечению,
			|		-Таблица.НеОбеспечивать           КАК НеОбеспечивать,
			|		-Таблица.Поступило                КАК Поступило,
			|		-Таблица.ПоступитКДате            КАК ПоступитКДате,
			|		-Таблица.ПоставкаНаСогласовании   КАК ПоставкаНаСогласовании,
			|		-Таблица.ЗакрытьГрафикПоступления КАК ЗакрытьГрафикПоступления
			|	ИЗ
			|		РегистрНакопления.РаспределениеЗапасовДвижения КАК Таблица
			|	ГДЕ
			|		НЕ Таблица.Регистратор ССЫЛКА Документ.КорректировкаРегистров
			|			И ТИПЗНАЧЕНИЯ(Таблица.Регистратор) В(&ТипыДляОбнолвенияПереопределяемый)) КАК Набор
			|СГРУППИРОВАТЬ ПО
			|	Набор.Регистратор,
			|	Набор.Период,
			|	Набор.Номенклатура,
			|	Набор.Характеристика,
			|	Набор.Склад,
			|	Набор.Назначение,
			|	Набор.ЗаказНаОтгрузку,
			|	Набор.ЖелаемаяДатаОтгрузки,
			|	Набор.ЗаказНаПоступление,
			|	Набор.ДатаПоступления
			|ИМЕЮЩИЕ
			|	СУММА(Набор.Отгрузить) <> 0
			|		ИЛИ СУММА(Набор.Резервировать) <> 0
			|		ИЛИ СУММА(Набор.РезервироватьПоМереПоступления) <> 0
			|		ИЛИ СУММА(Набор.КОбеспечению) <> 0
			|		ИЛИ СУММА(Набор.НеОбеспечивать) <> 0
			|		ИЛИ СУММА(Набор.Поступило) <> 0
			|		ИЛИ СУММА(Набор.ПоступитКДате) <> 0
			|		ИЛИ СУММА(Набор.ПоставкаНаСогласовании) <> 0
			|		ИЛИ СУММА(Набор.ЗакрытьГрафикПоступления) <> 0
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура, Характеристика, Склад, Назначение";
			
		ТекстГруппировки = СтрЗаменить(ТекстГруппировки, "&ВложенныйЗапрос", СтрШаблон("(%1)", ВложенныйЗапрос));
		ТекстГруппировки = СтрЗаменить(ТекстГруппировки, "&ТипыДляОбнолвенияПереопределяемый", СтрСоединить(Типы, ","));
		
		Тексты = Новый Массив();
		ТекстТоварныеМеста = ТекстТоварныеМеста(Ложь);
			
		Тексты.Добавить(ТекстТоварныеМеста);
		Тексты.Добавить(ТекстГруппировки);
		ТекстГруппировки = СтрСоединить(Тексты, ОбщегоНазначения.РазделительПакетаЗапросов());
		
	КонецЕсли;
	
	Возврат ТекстГруппировки;
	
КонецФункции

// Возвращаемое значение:
//  Строка - текст запроса временной таблицы ТоварныеМеста
Функция ТекстТоварныеМеста(ФормироватьФиктивнуюТаблицуЗаменитьКОбеспечениюНаТребуется) Экспорт
	
	Если ФормироватьФиктивнуюТаблицуЗаменитьКОбеспечениюНаТребуется Тогда
		
		ТекстВременнойТаблицы =
			"ВЫБРАТЬ
			|	НЕОПРЕДЕЛЕНО КАК Ссылка
			|ПОМЕСТИТЬ ЗаменитьКОбеспечениюНаТребуется
			|ГДЕ
			|	ЛОЖЬ";
		
	Иначе
		
		Тексты = Новый Массив();
		Текст = Документы.ЗаказКлиента.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		Текст = Документы.ЗаявкаНаВозвратТоваровОтКлиента.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		Текст = Документы.ЗаказНаВнутреннееПотребление.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		Текст = Документы.ЗаказНаПеремещение.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		Текст = Документы.ЗаказНаСборку.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		//++ НЕ УТ
		Текст = Документы.ЗаказМатериаловВПроизводство.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		Тексты.Добавить(Текст);
		//++ Устарело_Переработка24
		Текст = Документы.ЗаказПереработчику.ТекстЗапросаДокументыДляЗаменыКОбеспечениюНаТребуется();
		//-- Устарело_Переработка24
		Тексты.Добавить(Текст);
		//-- НЕ УТ

		
		ТекстДокументов = СтрСоединить(Тексты, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
		ТекстВременнойТаблицы =
			"ВЫБРАТЬ
			|	Таблица.Ссылка КАК Ссылка
			|ПОМЕСТИТЬ ЗаменитьКОбеспечениюНаТребуется
			|ИЗ
			|	ТекстПереопределяемый КАК Таблица
			|ИНДЕКСИРОВАТЬ ПО
			|	Ссылка";
		ТекстВременнойТаблицы = СтрЗаменить(ТекстВременнойТаблицы, "ТекстПереопределяемый", СтрШаблон("(%1)", ТекстДокументов));
	
	КонецЕсли;
	
	Текст =
		"ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	НЕОПРЕДЕЛЕНО КАК НоменклатураОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ХарактеристикаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК НазначениеОприходование,
		|	НЕОПРЕДЕЛЕНО КАК СерияОприходование,
		|	НЕОПРЕДЕЛЕНО КАК УпаковкаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ВидОперации
		|ПОМЕСТИТЬ ТоварныеМеста
		|ИЗ
		|	Документ.ПриходныйОрдерНаТовары.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И НЕ ТабЧасть.ЭтоУпаковочныйЛист
		|		И ТабЧасть.Количество <> 0
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|		И ТабЧасть.Ссылка.Статус = Значение(Перечисление.СтатусыПриходныхОрдеров.Принят)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	НЕОПРЕДЕЛЕНО КАК НоменклатураОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ХарактеристикаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК НазначениеОприходование,
		|	НЕОПРЕДЕЛЕНО КАК СерияОприходование,
		|	НЕОПРЕДЕЛЕНО КАК УпаковкаОприходование,
		|	ТабЧасть.ВидОперации КАК ВидОперации
		|ИЗ
		|	Документ.КорректировкаИзлишковНедостачПоТоварнымМестам.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия,
		|	ТабЧасть.ВидОперации
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	НЕОПРЕДЕЛЕНО КАК НоменклатураОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ХарактеристикаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК НазначениеОприходование,
		|	НЕОПРЕДЕЛЕНО КАК СерияОприходование,
		|	НЕОПРЕДЕЛЕНО КАК УпаковкаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ВидОперации
		|ИЗ
		|	Документ.ОрдерНаОтражениеИзлишковТоваров.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	НЕОПРЕДЕЛЕНО КАК НоменклатураОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ХарактеристикаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК НазначениеОприходование,
		|	НЕОПРЕДЕЛЕНО КАК СерияОприходование,
		|	НЕОПРЕДЕЛЕНО КАК УпаковкаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ВидОперации
		|ИЗ
		|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	ТабЧасть.НоменклатураОприходование КАК НоменклатураОприходование,
		|	ТабЧасть.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
		|	ТабЧасть.НазначениеОприходование КАК НазначениеОприходование,
		|	ТабЧасть.СерияОприходование КАК СерияОприходование,
		|	МАКСИМУМ(ТабЧасть.УпаковкаОприходование) КАК УпаковкаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ВидОперации
		|ИЗ
		|	Документ.ОрдерНаОтражениеПересортицыТоваров.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия,
		|	ТабЧасть.НоменклатураОприходование,
		|	ТабЧасть.ХарактеристикаОприходование,
		|	ТабЧасть.НазначениеОприходование,
		|	ТабЧасть.СерияОприходование
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МАКСИМУМ(ТабЧасть.Упаковка) КАК Упаковка,
		|	ТабЧасть.НоменклатураОприходование КАК НоменклатураОприходование,
		|	ТабЧасть.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
		|	ВЫБОР КОГДА ТабЧасть.ПодНазначение ТОГДА
		|				ТабЧасть.Назначение
		|			ИНАЧЕ
		|				ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		КОНЕЦ КАК НазначениеОприходование,
		|	НЕОПРЕДЕЛЕНО КАК СерияОприходование,
		|	МАКСИМУМ(ТабЧасть.УпаковкаОприходование) КАК УпаковкаОприходование,
		|	НЕОПРЕДЕЛЕНО КАК ВидОперации
		|ИЗ
		|	Документ.ОрдерНаОтражениеПорчиТоваров.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия,
		|	ТабЧасть.НоменклатураОприходование,
		|	ТабЧасть.ХарактеристикаОприходование,
		|	ВЫБОР КОГДА ТабЧасть.ПодНазначение ТОГДА
		|				ТабЧасть.Назначение
		|			ИНАЧЕ
		|				ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		КОНЕЦ
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка, Номенклатура, Характеристика, Назначение, Серия, Упаковка,
		|	НоменклатураОприходование, ХарактеристикаОприходование, НазначениеОприходование, СерияОприходование, УпаковкаОприходование, ВидОперации
		|;
		|
		|/////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Упаковка КАК ТоварноеМесто,
		|	ВЫБОР
		|		КОГДА ТабЧасть.СтатусУказанияСерий В (4, 6, 8, 10, 14)
		|			ТОГДА ТабЧасть.Серия
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	КОНЕЦ КАК Серия,
		|	СУММА(ТабЧасть.КоличествоУпаковокФакт - ТабЧасть.КоличествоУпаковок) КАК КоличествоОстаток
		|ПОМЕСТИТЬ ТоварныеМестаВДокументе
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПересчетовТоваров.Выполнено)
		|		И ТабЧасть.Ссылка.Склад.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач
		|		И ТабЧасть.Ссылка.Склад.ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач <= ТабЧасть.Ссылка.Дата
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Упаковка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ВЫБОР
		|		КОГДА ТабЧасть.СтатусУказанияСерий В (4, 6, 8, 10, 14)
		|			ТОГДА ТабЧасть.Серия
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	КОНЕЦ
		|ИМЕЮЩИЕ
		|	СУММА(ТабЧасть.КоличествоУпаковокФакт - ТабЧасть.КоличествоУпаковок) <> 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Упаковка КАК ТоварноеМесто,
		|	ВЫБОР
		|		КОГДА ТабЧасть.СтатусУказанияСерий В (4, 6, 8, 10, 14)
		|			ТОГДА ТабЧасть.Серия
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	КОНЕЦ КАК Серия,
		|	СУММА(ВЫБОР
		|			КОГДА ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
		|					ИЛИ ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишекОставитьВЗонеОтгрузки)
		|				ТОГДА ТабЧасть.КоличествоУпаковок
		|			КОГДА ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
		|				ТОГДА -ТабЧасть.КоличествоУпаковок
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КоличествоОстаток
		|ИЗ
		|	Документ.КорректировкаПоОрдеруНаТовары.Товары КАК ТабЧасть
		|ГДЕ
		|	ТабЧасть.Ссылка.Проведен
		|		И ТабЧасть.ВидОперации В (
		|			ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек),
		|			ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу),
		|			ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишекОставитьВЗонеОтгрузки))
		|		И ТабЧасть.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Упаковка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ВЫБОР
		|		КОГДА ТабЧасть.СтатусУказанияСерий В (4, 6, 8, 10, 14)
		|			ТОГДА ТабЧасть.Серия
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	КОНЕЦ
		|ИМЕЮЩИЕ
		|	СУММА(ВЫБОР
		|			КОГДА ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишек)
		|					ИЛИ ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьИзлишекОставитьВЗонеОтгрузки)
		|				ТОГДА ТабЧасть.КоличествоУпаковок
		|			КОГДА ТабЧасть.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийКорректировокОстатковТоваров.ОтразитьНедостачу)
		|				ТОГДА -ТабЧасть.КоличествоУпаковок
		|			ИНАЧЕ 0
		|		КОНЕЦ) <> 0
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка, Номенклатура, ТоварноеМесто
		|;
		|
		|////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТоварныеМестаОстатки.Ссылка КАК Ссылка,
		|	ТоварныеМестаОстатки.Номенклатура КАК Номенклатура,
		|	УпаковкиЕдиницыИзмерения.Ссылка КАК ТоварноеМесто,
		|	УпаковкиЕдиницыИзмерения.КоличествоУпаковок КАК КоличествоМест
		|ПОМЕСТИТЬ ТоварныеМестаВНоменклатуре
		|ИЗ
		|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварныеМестаВДокументе КАК ТоварныеМестаОстатки
		|		ПО (УпаковкиЕдиницыИзмерения.Владелец = ВЫБОР
		|				КОГДА ТоварныеМестаОстатки.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
		|					ТОГДА ТоварныеМестаОстатки.Номенклатура.Ссылка
		|				ИНАЧЕ ТоварныеМестаОстатки.Номенклатура.НаборУпаковок
		|			КОНЕЦ)
		|ГДЕ
		|	УпаковкиЕдиницыИзмерения.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка, Номенклатура, ТоварноеМесто
		|;
		|
		|//////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабЧасть.Ссылка КАК Ссылка,
		|	ТабЧасть.Номенклатура КАК Номенклатура,
		|	ТабЧасть.Характеристика КАК Характеристика,
		|	ТабЧасть.Назначение КАК Назначение,
		|	ТабЧасть.Серия КАК Серия,
		|	МИНИМУМ(ВЫБОР
		|			КОГДА (ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0)))
		|					- ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест <= 0
		|				ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0))
		|			ИНАЧЕ (ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0))) - 1
		|		КОНЕЦ) КАК КоличествоКомплектов
		|ПОМЕСТИТЬ ЦелыеКомплекты
		|ИЗ
		|	ТоварныеМестаВНоменклатуре КАК ТоварныеМестаВНоменклатуре
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварныеМестаВДокументе КАК ТабЧасть
		|		ПО ТабЧасть.Ссылка = ТоварныеМестаВНоменклатуре.Ссылка
		|			И ТабЧасть.Номенклатура = ТоварныеМестаВНоменклатуре.Номенклатура
		|			И ТабЧасть.ТоварноеМесто = ТоварныеМестаВНоменклатуре.ТоварноеМесто
		|		
		|СГРУППИРОВАТЬ ПО
		|	ТабЧасть.Ссылка,
		|	ТабЧасть.Номенклатура,
		|	ТабЧасть.Характеристика,
		|	ТабЧасть.Назначение,
		|	ТабЧасть.Серия
		|ИМЕЮЩИЕ
		|	МИНИМУМ(ВЫБОР
		|			КОГДА (ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0)))
		|					- ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест <= 0
		|				ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0))
		|			ИНАЧЕ (ВЫРАЗИТЬ(ЕСТЬNULL(ТабЧасть.КоличествоОстаток, 0) / ТоварныеМестаВНоменклатуре.КоличествоМест КАК ЧИСЛО(12, 0))) - 1
		|		КОНЕЦ) <> 0";
	
	Тексты = Новый Массив();
	Тексты.Добавить(ТекстВременнойТаблицы);
	Тексты.Добавить(Текст);
	Текст = СтрСоединить(Тексты, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Возврат Текст;
	
КонецФункции

#КонецОбласти

#КонецЕсли
