
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
	Обработчик.Процедура = "РегистрыСведений.ПорядокУчетаОСБУ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.9.24";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("21f0f7e1-1194-4506-94d6-38b6087b7253");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ПорядокУчетаОСБУ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Порядок учета ОС (бухгалтерский и налоговый учет)"":
	|- в международной версии заполняет по данным упр. учета'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ВводОстатковВнеоборотныхАктивов2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ВозвратОСИзАренды2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ВыбытиеАрендованныхОС.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ЗаключениеДоговораАренды.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ИзменениеПараметровОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.МодернизацияОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ОбъединениеОС.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПередачаОСВАренду2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПеремещениеОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПодготовкаКПередачеОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПоступлениеАрендованныхОС.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПринятиеКУчетуОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.РазукомплектацияОС.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СписаниеОС2_4.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОСБУ.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ОбъектыЭксплуатации.ПолноеИмя());
	
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОСБУ.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ПорядокУчетаОСБУ.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ПорядокУчетаОСБУ";
	ИмяРегистра = "ПорядокУчетаОСБУ";
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РегистрИсточник.Регистратор
	|ИЗ
	|	РегистрСведений.ПорядокУчетаОСУУ КАК РегистрИсточник
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ КАК РегистрПриемник
	|		ПО РегистрПриемник.Регистратор = РегистрИсточник.Регистратор
	|ГДЕ
	|	РегистрПриемник.Регистратор ЕСТЬ NULL
	|	И &ЭтоМеждународнаяВерсия
	|	И НЕ &РеглУчетВНАВедетсяНезависимо
	|	И НЕ РегистрИсточник.Регистратор ССЫЛКА Документ.КорректировкаРегистров";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЭтоМеждународнаяВерсия", НЕ ПолучитьФункциональнуюОпцию("ЛокализацияРФ"));
	Запрос.УстановитьПараметр("РеглУчетВНАВедетсяНезависимо", НастройкиНалоговУчетныхПолитикПовтИсп.РеглУчетВНАВедетсяНезависимо());

	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ВнеоборотныеАктивы.СформироватьДвиженияПриОбновленииИБ("ПорядокУчетаОСБУ", Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
