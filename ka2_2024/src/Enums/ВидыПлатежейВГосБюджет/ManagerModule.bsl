#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВидыНалоговыхПлатежей() Экспорт
	
	ВидыПлатежей = Новый Массив;
	ВидыПлатежей.Добавить(Налог);
	ВидыПлатежей.Добавить(НалогАкт);
	ВидыПлатежей.Добавить(НалогСам);
	ВидыПлатежей.Добавить(ВзносыСвышеПредела);
	ВидыПлатежей.Добавить(ВзносыБезСпецоценки);
	ВидыПлатежей.Добавить(ГосрегистрацияОрганизацийЧерезМФЦ);
	
	Возврат ВидыПлатежей;
	
КонецФункции

Функция ЭтоПени(ВидНалоговогоОбязательства) Экспорт
	
	Если ТипЗнч(ВидНалоговогоОбязательства) <> ТипЗнч(ПустаяСсылка()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства = ПениАкт
		Или ВидНалоговогоОбязательства = ПениСам;
	
КонецФункции

Функция ЭтоПроценты(ВидНалоговогоОбязательства) Экспорт
	
	Если ТипЗнч(ВидНалоговогоОбязательства) <> ТипЗнч(ПустаяСсылка()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства = Проценты;
	
КонецФункции

Функция ЭтоШтраф(ВидНалоговогоОбязательства) Экспорт
	
	Если ТипЗнч(ВидНалоговогоОбязательства) <> ТипЗнч(ПустаяСсылка()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства = Штраф;
	
КонецФункции

Функция ЭтоВзносыСвышеПредела(ВидНалоговогоОбязательства) Экспорт
	
	Если ТипЗнч(ВидНалоговогоОбязательства) <> ТипЗнч(ПустаяСсылка()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства = ВзносыСвышеПредела;
	
КонецФункции

Функция ВидПлатежа(ВидНалоговогоОбязательства) Экспорт
	
	ТипЗначения = ТипЗнч(ВидНалоговогоОбязательства);
	
	Если ТипЗнч(ВидНалоговогоОбязательства) = ТипЗнч(ПустаяСсылка()) Тогда
		Возврат ВидНалоговогоОбязательства;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает ссылку на значение перечисления по переданному имени.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыПлатежейВГосБюджет - ссылка на найденное значение перечисление или ПустаяСсылка().
//
Функция ВидНалоговогоОбязательстваПоИмени(ИмяНалоговогоОбязательства) Экспорт
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыПлатежейВГосБюджет.ЗначенияПеречисления Цикл
		
		Если ВРег(ЗначениеПеречисления.Имя) = ВРег(ИмяНалоговогоОбязательства) Тогда
			Возврат Перечисления.ВидыПлатежейВГосБюджет[ЗначениеПеречисления.Имя];
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Перечисления.ВидыПлатежейВГосБюджет.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#КонецЕсли
