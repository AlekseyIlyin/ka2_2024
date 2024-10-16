
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьЭлементов(ЭтаФорма);
	УстановитьВидимостьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.РазрезУчета) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущийОбъект.СтатьяРасходов, 
		"ВариантРаспределенияРасходовРегл, ВариантРаспределенияРасходовУпр");
	Если ЗначенияРеквизитов.ВариантРаспределенияРасходовРегл = ЗначенияРеквизитов.ВариантРаспределенияРасходовУпр Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначенияРеквизитов.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
		ТекущийОбъект.РазрезУчета = Перечисления.РазрезыУчета.Регламентированный;
	КонецЕсли;
	
	Если ЗначенияРеквизитов.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
		ТекущийОбъект.РазрезУчета = Перечисления.РазрезыУчета.Управленческий;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов(ЭтаФорма);
	Если Не Элементы.Подразделение.Доступность Тогда
		Запись.Подразделение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементов(Форма)
	
	Элементы = Форма.Элементы;
	Запись = Форма.Запись;
	
	ЗначенияРеквизитов = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Запись.СтатьяРасходов, 
		"ВариантРаспределенияРасходовРегл, ВариантРаспределенияРасходовУпр");
	Элементы.РазрезУчета.Видимость = (ЗначенияРеквизитов.ВариантРаспределенияРасходовРегл = ЗначенияРеквизитов.ВариантРаспределенияРасходовУпр);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	Элементы = Форма.Элементы;
	Запись = Форма.Запись;
	
	Элементы.Подразделение.Доступность = ЗначениеЗаполнено(Запись.Организация);
	
КонецПроцедуры

#КонецОбласти
