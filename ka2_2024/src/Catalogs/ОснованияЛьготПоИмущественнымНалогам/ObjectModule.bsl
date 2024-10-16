
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если УстановленаРегиональнымЗаконом Тогда
		Наименование = ЛьготыПоИмущественнымНалогамКлиентСервер.НаименованиеРегиональнойЛьготы(
			ЭтотОбъект,
			,
			АдресныйКлассификатор.НаименованиеРегионаПоКоду(КодРегиона));
	ИначеЕсли Не УстановленаРегиональнымЗаконом И ЗначениеЗаполнено(КодЛьготы) Тогда
		Наименование = ЛьготыПоИмущественнымНалогам.НаименованиеФедеральнойЛьготы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не УстановленаРегиональнымЗаконом Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаРегиональногоЗакона");
		МассивНепроверяемыхРеквизитов.Добавить("НомерРегиональногоЗакона");
	КонецЕсли;
	
	Если ВидЛьготы <> Перечисления.ВидыЛьготПоИмущественнымНалогам.СнижениеСтавкиНаПроцент 
		 Или ВидЛьготы <> Перечисления.ВидыЛьготПоИмущественнымНалогам.СнижениеСуммыНаПроцент Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПроцентУменьшения");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли