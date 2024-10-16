#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура рвк_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ВключитьИнтеркампани = Константы.рвк_ВключитьИнтеркампани.Получить();	
	ЕстьИнтеркампани = ВключитьИнтеркампани	И рвк_ОбщийМодульПовтИсп.ПартнерНашаОрганизация(Партнер);
	ДополнительныеСвойства.Вставить("ЕстьИнтеркампани", ЕстьИнтеркампани);
	
	Если ЕстьИнтеркампани Тогда
		Дата = НачалоДня(Дата);
	КонецЕсли;
	
КонецПроцедуры

&После("ПриЗаписи")
Процедура рвк_ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	рвк_СформироватьПриобретение(Отказ);
	
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура рвк_ОбработкаПроведения(Отказ, РежимПроведения)
	
	рвк_СформироватьСчетФактуру(Отказ);
	рвк_ПровестиПриобраетение(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаПроведения

Процедура рвк_СформироватьСчетФактуру(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если Не рвк_ОбщийМодульПовтИсп.СоздаватьСчетфактурАвтоматически(Организация) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыРегистрации = УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурВыданных();
	ЗаполнитьЗначенияСвойств(ПараметрыРегистрации,ЭтотОбъект);
	ПараметрыРегистрации.РеализацияТоваров = Истина;
	РезультатПроверки = УчетНДСУП.СчетаФактурыВыданныеНаОсновании(ПараметрыРегистрации);
	
	ЗначенияРеквизитовКонтрагентаРеализации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, "ИНН,КПП");
	ПерезаполнитьРеквизитыСчетаФактуры = Ложь;
	
	Если ЗначениеЗаполнено(РезультатПроверки.СчетаФактуры) Тогда
		
		ЗначенияРеквизитовСчетаФактуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РезультатПроверки.СчетаФактуры[0], "Номер,Дата,Склад,Контрагент,Партнер,ИННКонтрагента,КППКонтрагента");
		
		ПерезаполнитьРеквизитыСчетаФактуры = 
			ЗначенияРеквизитовСчетаФактуры.Контрагент <> Контрагент ИЛИ 
			ЗначенияРеквизитовСчетаФактуры.Партнер <> Партнер ИЛИ 
			ЗначенияРеквизитовСчетаФактуры.Склад <> Склад ИЛИ 
			ЗначенияРеквизитовКонтрагентаРеализации.ИНН <> ЗначенияРеквизитовСчетаФактуры.ИННКонтрагента ИЛИ 
			ЗначенияРеквизитовКонтрагентаРеализации.КПП <> ЗначенияРеквизитовСчетаФактуры.КППКонтрагента ИЛИ 
			СокрЛП(ЗначенияРеквизитовСчетаФактуры.Номер) <> СокрЛП(Номер) ИЛИ 
			НачалоДня(ЗначенияРеквизитовСчетаФактуры.Дата) <> НачалоДня(Дата);
		
		Если ПерезаполнитьРеквизитыСчетаФактуры Тогда
			СчетФактураОбъект = РезультатПроверки.СчетаФактуры[0].ПолучитьОбъект();
		КонецЕсли;
		
	Иначе
		СчетФактураОбъект = Документы.СчетФактураВыданный.СоздатьДокумент();
		СчетФактураОбъект.Заполнить(Ссылка);
		СчетФактураОбъект.Дата = Дата;
		
		СчетФактураОбъект.Организация = Организация;
		СчетФактураОбъект.ДатаВыставления = Дата;
		
		СчетФактураОбъект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		СчетФактураОбъект.ДокументОснование = Ссылка;
		СтрокаДокументаОснования = СчетФактураОбъект.ДокументыОснования.Добавить();
		СтрокаДокументаОснования.ХозяйственнаяОперация = ХозяйственнаяОперация;
		СтрокаДокументаОснования.ДокументОснование = Ссылка;
		
		СчетФактураОбъект.ИдентификаторГосКонтракта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ИдентификаторГосКонтракта");
		
		ПерезаполнитьРеквизитыСчетаФактуры = Истина;
	КонецЕсли;
	
	Если ПерезаполнитьРеквизитыСчетаФактуры Тогда
		СчетФактураОбъект.Номер = Номер;
		СчетФактураОбъект.Дата = Дата;
		СчетФактураОбъект.Контрагент = Контрагент;
		СчетФактураОбъект.Партнер = Партнер;
		СчетФактураОбъект.Склад = Склад;
		СчетФактураОбъект.ИННКонтрагента = ЗначенияРеквизитовКонтрагентаРеализации.ИНН;
		СчетФактураОбъект.КППКонтрагента = ЗначенияРеквизитовКонтрагентаРеализации.КПП;
		Попытка
			СчетФактураОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		Исключение
			ОбщегоНазначения.СообщитьПользователю("Не удалось провести счет-фактуру по причине: " + ОписаниеОшибки());
			ТекстСообщения = СтрШаблон("В дополнительных реквизитах Партнера: %1 не указано соглашение с поставщиком", Партнер);
			рвк_ЖурналРегистрацииВызовСервера.ЗаписатьПредупреждение("СчетФактура", ТекстСообщения, Ссылка);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура рвк_ПровестиПриобраетение(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Приобретение = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("Приобретение", Приобретение) 
			Или Не ЗначениеЗаполнено(Приобретение) Тогда
		Возврат;
	КонецЕсли;
	
	ПриобретениеОбъект = Приобретение.ПолучитьОбъект();
	ПриобретениеОбъект.ДополнительныеСвойства.Вставить("ОтключитьКонтрольПриПроведении", Истина);
	
	Попытка
		ПриобретениеОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщенияЖР = СтрШаблон("Не удалось провести Приобретение: %1 по причине: %2", 
			Приобретение, 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщенияЖР, Ссылка);
		ТекстСообщенияПользователю = СтрШаблон("Не удалось записать Приобретение: %1 по причине: %2", 
					Приобретение, 
					ОбработкаОшибок.КраткоеПредставлениеОшибки((ИнформацияОбОшибке)));		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщенияПользователю, Ссылка);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

Процедура рвк_СформироватьПриобретение(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьИнтеркампани = Ложь;
	Если Не ДополнительныеСвойства.Свойство("ЕстьИнтеркампани", ЕстьИнтеркампани) 
			Или Не ЕстьИнтеркампани Тогда
		Возврат;
	КонецЕсли;
	
	СоглашениеСПоставщиком = рвк_СоглашениеСПоставщиком(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПриобретениеGUID = Документы.РеализацияТоваровУслуг.рвк_ПриобретениеИнтеркампани(Ссылка);
	Если ЗначениеЗаполнено(ПриобретениеGUID) Тогда
		Приобретение = Документы.ПриобретениеТоваровУслуг.ПолучитьСсылку(Новый УникальныйИдентификатор(ПриобретениеGUID));
		ПриобретениеОбъект = Неопределено;
		Если ЗначениеЗаполнено(Приобретение) Тогда
			ПриобретениеОбъект = Приобретение.ПолучитьОбъект();
		КонецЕсли;
		СсылкаЛиквидна = ПриобретениеОбъект <> Неопределено;
		Если СсылкаЛиквидна Тогда
			Если Проведен Тогда
				Если Не ПриобретениеОбъект.Проведен И ПриобретениеОбъект.ПометкаУдаления Тогда
					Попытка
						ПриобретениеОбъект.УстановитьПометкуУдаления(Ложь);
					Исключение
						ТекстСообщения = СтрШаблон("Не удалось отменить пометку удаления для Приобретения: %1 по причине: %2", 
							Приобретение, 
							ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Ссылка, Отказ);
						Возврат;
					КонецПопытки;
				КонецЕсли;
			ИначеЕсли Не Проведен И ПриобретениеОбъект.Проведен Тогда
				Попытка
					ПриобретениеОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				Исключение
					ТекстСообщения = СтрШаблон("Не удалось отменить проведение для Приобретения: %1 по причине: %2", 
						Приобретение, 
						ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Ссылка, Отказ);
					Возврат;
				КонецПопытки;
			КонецЕсли;
			Если ПометкаУдаления И Не ПриобретениеОбъект.ПометкаУдаления Тогда
				Попытка
					ПриобретениеОбъект.УстановитьПометкуУдаления(Истина);
				Исключение
					ТекстСообщения = СтрШаблон("Не удалось пометить на удаление Приобретение: %1 по причине: %2", 
						Приобретение, 
						ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Ссылка, Отказ);
					Возврат;
				КонецПопытки;
			КонецЕсли;
		Иначе			
			ПриобретениеОбъект = Документы.ПриобретениеТоваровУслуг.СоздатьДокумент();
		КонецЕсли;
	Иначе // Нет приобретения
		Если ПометкаУдаления Тогда
			Возврат;
		Иначе
			ПриобретениеОбъект = Документы.ПриобретениеТоваровУслуг.СоздатьДокумент();
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаТовары = рвк_ТаблицаТоваровПриобретение(ПриобретениеОбъект.Склад);
	
	ПриобретениеОбъект.Заполнить(СоглашениеСПоставщиком);
	ПриобретениеОбъект.Дата = НачалоДня(Дата);
	ПриобретениеОбъект.ДатаВходящегоДокумента = Дата;
	ПриобретениеОбъект.НомерВходящегоДокумента = Номер;
	ПриобретениеОбъект.ЗакупкаПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаПоПатенту;
	
	Склад = ПриобретениеОбъект.Склад;
	ТаблицаТовары.ЗаполнитьЗначения(Склад, "Склад");
	
	ПриобретениеОбъект.Товары.Загрузить(ТаблицаТовары);
	ПриобретениеОбъект.ЗаполнитьУсловияЗакупокПоСоглашению(Ложь);
	ПриобретениеОбъект.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.РазделенаТолькоПоНакладным;
	ПриобретениеОбъект.Согласован = Истина;

	ПриобретениеОбъект.ОбменДанными.Загрузка = Истина;
	ПриобретениеОбъект.Записать();
	Приобретение = ПриобретениеОбъект.Ссылка;
	
	ДополнительныеСвойства.Вставить("Приобретение", Приобретение);
	рвк_ОбновитьСсылкуНаПриобретение(Приобретение);

	ТекстСообщения = СтрШаблон("Сформирован / обновлен: %1", Приобретение);
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
КонецПроцедуры

Функция рвк_ТаблицаТоваровПриобретение(Склад)
	
	ОписаниеТипаНеотрицательнаяСумма = Метаданные.ОпределяемыеТипы.ДенежнаяСуммаНеотрицательная.Тип;
	
	ТаблицаТовары = ВидыЗапасов.Выгрузить();
	ТаблицаТовары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТовары.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТовары.Колонки.Добавить("Сумма", ОписаниеТипаНеотрицательнаяСумма);
	ТаблицаТовары.Колонки.Добавить("СуммаИтог", ОписаниеТипаНеотрицательнаяСумма);
	ТаблицаТовары.Колонки.Добавить("СуммаНДСВзаиморасчетов", ОписаниеТипаНеотрицательнаяСумма);
	ТаблицаТовары.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	АналитикаУчетаНоменклатуры = ТаблицаТовары.ВыгрузитьКолонку("АналитикаУчетаНоменклатуры"); 
	РеквизитыАналитикиНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(АналитикаУчетаНоменклатуры, "Номенклатура,Характеристика");
	Для Каждого СтрокаТаблицыТовары Из ТаблицаТовары Цикл
		РеквизитыАналитики = РеквизитыАналитикиНоменклатуры[СтрокаТаблицыТовары.АналитикаУчетаНоменклатуры];
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыТовары, РеквизитыАналитики, "Номенклатура,Характеристика");
		СуммаСНДС = СтрокаТаблицыТовары.СуммаСНДС;
		СтрокаТаблицыТовары.Сумма = СуммаСНДС;
		СтрокаТаблицыТовары.СуммаИтог = СуммаСНДС;
		СтрокаТаблицыТовары.СуммаВзаиморасчетов = СуммаСНДС;
		СтрокаТаблицыТовары.СуммаНДСВзаиморасчетов = СуммаСНДС;
	КонецЦикла;
	
	Возврат ТаблицаТовары;	
	
КонецФункции

Процедура рвк_ОбновитьСсылкуНаПриобретение(Приобретение)
	ТаблицаСвойствИЗначений = УправлениеСвойствами.ЗначенияСвойств(Ссылка, Ложь);
	СвойстваПриобретениеИнтеркампани = Документы.РеализацияТоваровУслуг.рвк_СвойстваПриобретениеИнтеркампани();
	СтрокаЗначенияСвойства = ТаблицаСвойствИЗначений.Найти(СвойстваПриобретениеИнтеркампани, "Свойство");
	Если СтрокаЗначенияСвойства = Неопределено Тогда
		СтрокаЗначенияСвойства = ТаблицаСвойствИЗначений.Добавить();
		СтрокаЗначенияСвойства.Свойство = СвойстваПриобретениеИнтеркампани;
	КонецЕсли;
	СтрокаЗначенияСвойства.Значение = рвк_ОбщегоНазначения.ИдентификаторОбъекта(Приобретение);
	СтрокаЗначенияСвойства.Представление = Приобретение;
	УправлениеСвойствами.ЗаписатьСвойстваУОбъекта(Ссылка, ТаблицаСвойствИЗначений); 
КонецПроцедуры

Функция рвк_СоглашениеСПоставщиком(Отказ)
	Результат = Неопределено;
	
	Если Отказ Тогда
		Возврат Результат;
	КонецЕсли;
	
	ИмяСвойста = "СоглашениеСПоставщиком_fce5fe05c0de4363ac8f62295fa98d13";
	Гиперссылка = рвк_ОбщегоНазначения.ЗначениеСвойства(Партнер, ИмяСвойста, Неопределено);
		
	Если ЗначениеЗаполнено(Гиперссылка) Тогда
		Попытка
			Результат = рвк_ОбщегоНазначения.СсылкуИзНавигационной(Гиперссылка, Отказ);
		Исключение
			ТекстСообщения = СтрШаблон("Не удалось получить соглашение с Поставщиком интеркампани по причине: %1", 
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, ЭтотОбъект, Отказ);
		КонецПопытки;
	Иначе		
		ТекстСообщения = СтрШаблон("В дополнительных реквизитах Партнера: %1 не указано соглашение с поставщиком", Партнер);
		рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Партнер, Отказ);
	КонецЕсли;
	
	РеквизитыСоглашенияИнтеркампани = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Результат, "Склад,Организация");
	Если Не ЗначениеЗаполнено(РеквизитыСоглашенияИнтеркампани.Склад) Тогда
		ТекстСообщения = СтрШаблон("В соглашении интеркампани: %1 не заполнен склад", Результат);
		рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Партнер, Отказ);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РеквизитыСоглашенияИнтеркампани.Организация) Тогда
		ТекстСообщения = СтрШаблон("В соглашении интеркампани: %1 не заполнена организация", Результат);
		рвк_ЖурналРегистрацииВызовСервера.ЗаписатьОшибку("Интеркампани", ТекстСообщения, Партнер, Отказ);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли