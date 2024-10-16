
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляРегистраПодчиненногоРегистратору(Настройки);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ПеренестиВыполненныеРаботыСотрудников() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УдалитьВыполненныеРаботыСотрудников.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрНакопления.УдалитьВыполненныеРаботыСотрудников КАК УдалитьВыполненныеРаботыСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников КАК ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников
		|		ПО УдалитьВыполненныеРаботыСотрудников.Регистратор = ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Регистратор
		|			И УдалитьВыполненныеРаботыСотрудников.Сотрудник = ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Сотрудник
		|			И УдалитьВыполненныеРаботыСотрудников.Период = ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Период
		|			И (ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Показатель = &СдельныйЗаработок)
		|ГДЕ
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Регистратор ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("СдельныйЗаработок", ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.СдельныйЗаработок"));
	РезультатЗапроса = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ВыполнитьЗапросПолученияОбновляемыхДанных(Запрос, Неопределено, "ВТРегистраторы");
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УдалитьВыполненныеРаботыСотрудников.Период КАК Период,
		|	УдалитьВыполненныеРаботыСотрудников.ВидРабот КАК ВидРабот
		|ПОМЕСТИТЬ ВТВидыРаботПериоды
		|ИЗ
		|	РегистрНакопления.УдалитьВыполненныеРаботыСотрудников КАК УдалитьВыполненныеРаботыСотрудников
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторы КАК Регистраторы
		|		ПО Регистраторы.Регистратор = УдалитьВыполненныеРаботыСотрудников.Регистратор";
	Запрос.Выполнить();
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТВидыРаботПериоды", "ВидРабот");
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних("РасценкиРаботСотрудников", Запрос.МенеджерВременныхТаблиц, Истина, ОписаниеФильтра);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Период КАК Период,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Регистратор КАК Регистратор,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Сотрудник КАК Сотрудник,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Значение КАК Значение,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Сторно КАК Сторно,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Организация КАК Организация,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Показатель КАК Показатель,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.ИспользоватьПриРасчетеПервойПоловиныМесяца КАК ИспользоватьПриРасчетеПервойПоловиныМесяца,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.СтатьяФинансирования КАК СтатьяФинансирования,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
		|	ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Подразделение КАК Подразделение
		|ИЗ
		|	РегистрНакопления.ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников КАК ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторы КАК Регистраторы
		|		ПО ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.Регистратор = Регистраторы.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УдалитьВыполненныеРаботыСотрудников.Период,
		|	УдалитьВыполненныеРаботыСотрудников.Регистратор,
		|	УдалитьВыполненныеРаботыСотрудников.Сотрудник,
		|	СУММА(УдалитьВыполненныеРаботыСотрудников.ОбъемВыполненныхРабот * ЕСТЬNULL(РасценкиРаботСотрудников.Расценка, 0)),
		|	УдалитьВыполненныеРаботыСотрудников.Сторно,
		|	УдалитьВыполненныеРаботыСотрудников.Организация,
		|	&СдельныйЗаработок,
		|	УдалитьВыполненныеРаботыСотрудников.Сотрудник.ФизическоеЛицо,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL
		|ИЗ
		|	РегистрНакопления.УдалитьВыполненныеРаботыСотрудников КАК УдалитьВыполненныеРаботыСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторы КАК Регистраторы
		|		ПО УдалитьВыполненныеРаботыСотрудников.Регистратор = Регистраторы.Регистратор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРасценкиРаботСотрудниковСрезПоследних КАК РасценкиРаботСотрудников
		|		ПО УдалитьВыполненныеРаботыСотрудников.ВидРабот = РасценкиРаботСотрудников.ВидРабот
		|			И УдалитьВыполненныеРаботыСотрудников.Период = РасценкиРаботСотрудников.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	УдалитьВыполненныеРаботыСотрудников.Период,
		|	УдалитьВыполненныеРаботыСотрудников.Регистратор,
		|	УдалитьВыполненныеРаботыСотрудников.Организация,
		|	УдалитьВыполненныеРаботыСотрудников.Сторно,
		|	УдалитьВыполненныеРаботыСотрудников.Сотрудник,
		|	УдалитьВыполненныеРаботыСотрудников.Сотрудник.ФизическоеЛицо
		|
		|ИМЕЮЩИЕ
		|	СУММА(УдалитьВыполненныеРаботыСотрудников.ОбъемВыполненныхРабот * ЕСТЬNULL(РасценкиРаботСотрудников.Расценка, 0)) <> 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
		НаборЗаписей = РегистрыНакопления.ЗначенияОперативныхПоказателейРасчетаЗарплатыСотрудников.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
