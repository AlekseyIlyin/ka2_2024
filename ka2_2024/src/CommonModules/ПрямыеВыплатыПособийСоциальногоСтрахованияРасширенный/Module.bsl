#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтпускПоУходуЗаРебенком.Ссылка
	|ИЗ
	|	Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДатыПередачиВыплатыПособий КАК ВТДатыПередачиВыплатыПособий
	|		ПО ОтпускПоУходуЗаРебенком.Организация = ВТДатыПередачиВыплатыПособий.Организация
	|			И (ВТДатыПередачиВыплатыПособий.Дата МЕЖДУ ОтпускПоУходуЗаРебенком.ДатаНачала И ОтпускПоУходуЗаРебенком.ДатаОкончания)
	|			И (ОтпускПоУходуЗаРебенком.ПособиеВыплачиваетсяФСС = ЛОЖЬ)";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Документ = Выборка.Ссылка.ПолучитьОбъект();
			Документ.ОбменДанными.Загрузка = Истина;
			
			Документ.ПособиеВыплачиваетсяФСС = Истина;
			
			Документ.Записать(РежимЗаписиДокумента.Запись);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#Область РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий

Процедура ПриОпределенииЗапросаРеестраПрямыхВыплатПоПервичнымДокументам(Запрос, Объект, ТаблицаОснований) Экспорт
	
	Если Объект.ВидРеестра = Перечисления.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ЕжемесячныеПособияПоУходуЗаРебенком Тогда
		ПриОпределенииЗапросаРеестраПрямыхВыплатПоОтпускамПоУходу(Запрос, ТаблицаОснований);
		
	Иначе
		ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ПриОпределенииЗапросаРеестраПрямыхВыплатПоПервичнымДокументам(Запрос, Объект, ТаблицаОснований);
		
		Если Объект.ВидРеестра = Перечисления.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПособияПоНетрудоспособности Тогда
			СхемаЗапроса = Новый СхемаЗапроса;
			СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
			ПоследнийЗапрос = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
			Оператор = ПоследнийЗапрос.Операторы[0];
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажЛет");
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажМесяцев");
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажДней");
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажРасширенныйЛет");
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажРасширенныйМесяцев");
			Оператор.ВыбираемыеПоля.Добавить("БольничныйЛист.СтажРасширенныйДней");
			Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОпределенииФиксируемыхРеквизитовРеестраПрямыхВыплат(ФиксируемыеРеквизиты) Экспорт
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь               = "СведенияНеобходимыеДляНазначенияПособий";
	Шаблон.РеквизитСтроки      = Истина;
	Шаблон.ОснованиеЗаполнения = "ПервичныйДокумент";
	Шаблон.ИмяГруппы           = "ПособияПоНетрудоспособности_Стаж";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажДней");
	
	Шаблон.ИмяГруппы           = "ПособияПоНетрудоспособности_СтажРасширенный";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйДней");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь                = "СведенияНеобходимыеДляНазначенияПособий";
	Шаблон.РеквизитСтроки      = Истина;
	Шаблон.ОснованиеЗаполнения = "ПервичныйДокумент";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаРебенкаВыплачиваетсяПособие");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь                = "СведенияНеобходимыеДляНазначенияПособий";
	Шаблон.РеквизитСтроки      = Истина;
	Шаблон.ИмяГруппы           = "ЕжемесячныеПособияПоУходуЗаРебенком";
	Шаблон.ОснованиеЗаполнения = "ПервичныйДокумент";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОчередностьРожденияРебенка");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаименованиеПодтверждающегоДокумента");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаличиеРешенияСудаОЛишенииПрав");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФинансированиеФедеральнымБюджетом");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОдновременныйУходЗаНесколькимиДетьми");
КонецПроцедуры

#КонецОбласти

Процедура ПриОпределенииСвойствПособийФСС(ВидПособияФСС, ПервичныйДокумент, Результат, СтандартнаяОбработка) Экспорт
	
	ОпределитьПоТипу = Не ЗначениеЗаполнено(ВидПособияФСС) И ЗначениеЗаполнено(ПервичныйДокумент);
	
	Если ?(ОпределитьПоТипу,
			ТипЗнч(ПервичныйДокумент) = Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком"),
			ВидПособияФСС = Перечисления.ПособияНазначаемыеФСС.ЕжемесячноеПособиеПоУходуЗаРебенком) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Результат.ЗаголовокПоля = НСтр("ru = 'Отпуск по уходу'");
		Результат.ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка.ОтпускПоУходуЗаРебенком");
		Результат.ОтбиратьПоСотруднику = Ложь;
		Результат.ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ПособиеВыплачиваетсяФСС", Истина));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов

Функция ЗапросОплатДляВозмещенияВыплатРодителямДетейИнвалидов(Документ, ОплатаДнейУходаЗаДетьмиИнвалидами) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ЗначениеЗаполнено(ОплатаДнейУходаЗаДетьмиИнвалидами) Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОплатаШапка.Ссылка КАК Ссылка,
		|	ОплатаШапка.Сотрудник КАК Сотрудник,
		|	ОплатаШапка.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОплатаШапка.ПериодРегистрации КАК ПериодРегистрации,
		|	ОплатаШапка.РасчетДенежногоСодержания КАК РасчетДенежногоСодержания,
		|	ОплатаШапка.СохраняемоеДенежноеСодержание КАК СохраняемоеДенежноеСодержание,
		|	ОплатаШапка.СреднедневнойЗаработок КАК СреднедневнойЗаработок,
		|	ОплатаШапка.СреднийЗаработок КАК СреднийЗаработок,
		|	ОплатаШапка.Начислено КАК Начислено
		|ПОМЕСТИТЬ ВТДокументы
		|ИЗ
		|	Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК ОплатаШапка
		|ГДЕ
		|	ОплатаШапка.Ссылка = &ДокументОснование";
	Иначе
		// Получаются данные документов ОплатаДнейУходаЗаДетьмиИнвалидами
		// по которым еще не было документов ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов,
		// либо которые выбраны в текущем документе ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОплатаШапка.Ссылка КАК Ссылка,
		|	ОплатаШапка.Сотрудник КАК Сотрудник,
		|	ОплатаШапка.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОплатаШапка.ПериодРегистрации КАК ПериодРегистрации,
		|	ОплатаШапка.РасчетДенежногоСодержания КАК РасчетДенежногоСодержания,
		|	ОплатаШапка.СохраняемоеДенежноеСодержание КАК СохраняемоеДенежноеСодержание,
		|	ОплатаШапка.СреднедневнойЗаработок КАК СреднедневнойЗаработок,
		|	ОплатаШапка.СреднийЗаработок КАК СреднийЗаработок,
		|	ОплатаШапка.Начислено КАК Начислено
		|ПОМЕСТИТЬ ВТДокументы
		|ИЗ
		|	Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК ОплатаШапка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.Оплаты КАК ЗаявленияОплат
		|		ПО ОплатаШапка.Ссылка = ЗаявленияОплат.ДокументОснование
		|ГДЕ
		|	ОплатаШапка.Организация = &Организация
		|	И ЕСТЬNULL(ЗаявленияОплат.Ссылка, &Ссылка) = &Ссылка
		|	И ОплатаШапка.Проведен = ИСТИНА";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов();
	Запрос.Текст = Запрос.Текст +
	"ВЫБРАТЬ
	|	ВТДокументы.Ссылка КАК Ссылка,
	|	ВТДокументы.Сотрудник КАК Сотрудник,
	|	ВТДокументы.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТДокументы.РасчетДенежногоСодержания КАК РасчетДенежногоСодержания,
	|	ОплатаНачисления.ДатаНачала КАК ДатаНачала,
	|	ОплатаНачисления.НормаДней КАК НормаДней,
	|	НАЧАЛОПЕРИОДА(ОплатаНачисления.ДатаНачала, МЕСЯЦ) КАК Месяц,
	|	СУММА(ОплатаНачисления.ОтработаноДней) КАК ОтработаноДней
	|ПОМЕСТИТЬ ВТНачисления
	|ИЗ
	|	ВТДокументы КАК ВТДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами.Начисления КАК ОплатаНачисления
	|		ПО ВТДокументы.Ссылка = ОплатаНачисления.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТДокументы.Ссылка,
	|	ВТДокументы.Сотрудник,
	|	ВТДокументы.ФизическоеЛицо,
	|	ВТДокументы.РасчетДенежногоСодержания,
	|	ОплатаНачисления.ДатаНачала,
	|	ОплатаНачисления.НормаДней,
	|	НАЧАЛОПЕРИОДА(ОплатаНачисления.ДатаНачала, МЕСЯЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНачисления.Ссылка КАК Ссылка,
	|	ВТНачисления.НормаДней КАК НормаДней
	|ПОМЕСТИТЬ ВТНормыДнейДенежногоСодержания
	|ИЗ
	|	ВТНачисления КАК ВТНачисления
	|ГДЕ
	|	ВТНачисления.РасчетДенежногоСодержания
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТНачисления.Ссылка,
	|	ВТНачисления.НормаДней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНачисления.Ссылка КАК Ссылка,
	|	ВТНачисления.Сотрудник КАК Сотрудник,
	|	ВТНачисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТНачисления.Месяц КАК Месяц,
	|	ВТНачисления.ДатаНачала КАК ДатаНачала,
	|	СУММА(ВТНачисления.ОтработаноДней) КАК ОтработаноДней
	|ПОМЕСТИТЬ ВТНачисления2
	|ИЗ
	|	ВТНачисления КАК ВТНачисления
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТНачисления.Ссылка,
	|	ВТНачисления.Сотрудник,
	|	ВТНачисления.ФизическоеЛицо,
	|	ВТНачисления.Месяц,
	|	ВТНачисления.ДатаНачала,
	|	ВТНачисления.ОтработаноДней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНачисления2.Ссылка КАК Ссылка,
	|	ВТНачисления2.Сотрудник КАК Сотрудник,
	|	ВТНачисления2.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТНачисления2.Месяц КАК Месяц,
	|	ВТНачисления2.ОтработаноДней КАК ОтработаноДней,
	|	СУММА(ВЫБОР
	|			КОГДА Пособия.СуммаВсего ЕСТЬ NULL
	|				ТОГДА 0
	|			КОГДА Пособия.Сторно
	|				ТОГДА -Пособия.СуммаВсего
	|			ИНАЧЕ Пособия.СуммаВсего
	|		КОНЕЦ) КАК СуммаВзносовДоступная
	|ПОМЕСТИТЬ втСуммыВзносовДоступные
	|ИЗ
	|	ВТНачисления2 КАК ВТНачисления2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПособияПоСоциальномуСтрахованию КАК Пособия
	|		ПО ВТНачисления2.ФизическоеЛицо = Пособия.ФизическоеЛицо
	|			И ВТНачисления2.ДатаНачала = Пособия.ДатаСтраховогоСлучая
	|			И (Пособия.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.СтраховыеВзносыПоДопВыходнымПоУходуЗаДетьмиИнвалидами))
	|			И (Пособия.Организация = &Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТНачисления2.Ссылка,
	|	ВТНачисления2.Сотрудник,
	|	ВТНачисления2.ФизическоеЛицо,
	|	ВТНачисления2.Месяц,
	|	ВТНачисления2.ОтработаноДней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДокументы.Ссылка КАК Ссылка,
	|	ВТДокументы.ФизическоеЛицо КАК ФизическоеЛицо,
	|	НАЧАЛОПЕРИОДА(ОплатыДругихЗаявлений.Месяц, МЕСЯЦ) КАК Месяц,
	|	СУММА(ОплатыДругихЗаявлений.СуммаВзносов) КАК СуммаВзносовУчтенная
	|ПОМЕСТИТЬ втСуммыВзносовУчтенные
	|ИЗ
	|	ВТДокументы КАК ВТДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.Оплаты КАК ОплатыДругихЗаявлений
	|		ПО ВТДокументы.Ссылка = ОплатыДругихЗаявлений.ДокументОснование
	|			И ВТДокументы.Сотрудник = ОплатыДругихЗаявлений.Сотрудник
	|			И (ОплатыДругихЗаявлений.Ссылка.Проведен)
	|			И (ОплатыДругихЗаявлений.Ссылка <> &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТДокументы.Ссылка,
	|	ВТДокументы.ФизическоеЛицо,
	|	НАЧАЛОПЕРИОДА(ОплатыДругихЗаявлений.Месяц, МЕСЯЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДокументы.Сотрудник КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА ВТДокументы.РасчетДенежногоСодержания
	|				И ЕСТЬNULL(ВТНормыДнейДенежногоСодержания.НормаДней, 0) > 0
	|			ТОГДА ВТДокументы.СохраняемоеДенежноеСодержание / ВТНормыДнейДенежногоСодержания.НормаДней
	|		КОГДА ВТДокументы.СреднедневнойЗаработок > 0
	|			ТОГДА ВТДокументы.СреднедневнойЗаработок
	|		ИНАЧЕ ВТДокументы.СреднийЗаработок
	|	КОНЕЦ КАК СреднедневнойЗаработок,
	|	ВТДокументы.Начислено КАК СуммаПособия,
	|	ВЫБОР
	|		КОГДА СуммыВзносовДоступные.СуммаВзносовДоступная >= ЕСТЬNULL(СуммыВзносовУчтенные.СуммаВзносовУчтенная, 0)
	|			ТОГДА СуммыВзносовДоступные.СуммаВзносовДоступная - ЕСТЬNULL(СуммыВзносовУчтенные.СуммаВзносовУчтенная, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВзносов,
	|	ВТДокументы.Ссылка КАК ДокументОснование,
	|	1 КАК КоличествоСтраниц,
	|	СуммыВзносовДоступные.ОтработаноДней КАК КоличествоДней,
	|	СуммыВзносовДоступные.Месяц КАК Месяц
	|ИЗ
	|	ВТДокументы КАК ВТДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСуммыВзносовДоступные КАК СуммыВзносовДоступные
	|		ПО ВТДокументы.Ссылка = СуммыВзносовДоступные.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСуммыВзносовУчтенные КАК СуммыВзносовУчтенные
	|		ПО ВТДокументы.Ссылка = СуммыВзносовУчтенные.Ссылка
	|			И (СуммыВзносовДоступные.Месяц = СуммыВзносовУчтенные.Месяц)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНормыДнейДенежногоСодержания КАК ВТНормыДнейДенежногоСодержания
	|		ПО ВТДокументы.Ссылка = ВТНормыДнейДенежногоСодержания.Ссылка";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Документ.Дата));
	Запрос.УстановитьПараметр("КонецПериода",  КонецМесяца(Документ.Дата));
	Запрос.УстановитьПараметр("Организация",   Документ.Организация);
	Запрос.УстановитьПараметр("Ссылка",        Документ.Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ОплатаДнейУходаЗаДетьмиИнвалидами);
	
	Возврат Запрос;
КонецФункции

#КонецОбласти

#Область ЗаявлениеВФССОВозмещенииРасходовНаПогребение

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииРасходовНаПогребение(Организация, Ссылка, ЕдиновременноеПособие) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ЗначениеЗаполнено(ЕдиновременноеПособие) Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕдиновременноеПособиеЗаСчетФСС.Ссылка
		|ПОМЕСТИТЬ ВТДокументы
		|ИЗ
		|	Документ.ЕдиновременноеПособиеЗаСчетФСС КАК ЕдиновременноеПособиеЗаСчетФСС
		|ГДЕ
		|	ЕдиновременноеПособиеЗаСчетФСС.Ссылка = &ДокументОснование";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ИспользованныеОплаты.ДокументОснование КАК Ссылка
		|ПОМЕСТИТЬ ВТИспользованныеОплаты
		|ИЗ
		|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Оплаты КАК ИспользованныеОплаты
		|ГДЕ
		|	ИспользованныеОплаты.Ссылка.Организация = &Организация
		|	И ИспользованныеОплаты.Ссылка <> &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕдиновременноеПособиеЗаСчетФСС.Ссылка
		|ПОМЕСТИТЬ ВТДокументы
		|ИЗ
		|	Документ.ЕдиновременноеПособиеЗаСчетФСС КАК ЕдиновременноеПособиеЗаСчетФСС
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИспользованныеОплаты КАК ВТИспользованныеОплаты
		|		ПО ЕдиновременноеПособиеЗаСчетФСС.Ссылка = ВТИспользованныеОплаты.Ссылка
		|ГДЕ
		|	ЕдиновременноеПособиеЗаСчетФСС.Организация = &Организация
		|	И ЕдиновременноеПособиеЗаСчетФСС.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью)
		|	И ВТИспользованныеОплаты.Ссылка ЕСТЬ NULL
		|	И ЕдиновременноеПособиеЗаСчетФСС.ПометкаУдаления = ЛОЖЬ
		|	И ЕдиновременноеПособиеЗаСчетФСС.Проведен = ИСТИНА";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|;
	|";
	
	Запрос.Текст = Запрос.Текст +
	"ВЫБРАТЬ
	|	ЕдиновременноеПособиеЗаСчетФСС.ФизическоеЛицо,
	|	ЕдиновременноеПособиеЗаСчетФСС.Начислено КАК РазмерПособия,
	|	ЕдиновременноеПособиеЗаСчетФСС.Ссылка КАК ДокументОснование,
	|	1 КАК КоличествоСтраниц
	|ИЗ
	|	Документ.ЕдиновременноеПособиеЗаСчетФСС КАК ЕдиновременноеПособиеЗаСчетФСС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДокументы КАК ВТДокументы
	|		ПО ЕдиновременноеПособиеЗаСчетФСС.Ссылка = ВТДокументы.Ссылка";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ЕдиновременноеПособие);
	
	Возврат Запрос.Выполнить();
КонецФункции

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Организация";
	Шаблон.ОснованиеЗаполнения = "Организация";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаименованиеТерриториальногоОрганаФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИНН");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КПП");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресЭлектроннойПочтыОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТелефонСоставителя");
	
	// Роль подписанта Руководитель.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения      = "Организация";
	Шаблон.ИмяГруппы                = "Руководитель";
	Шаблон.ФиксацияГруппы           = Истина;
	Шаблон.ОтображатьПредупреждение = Ложь;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Руководитель");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьРуководителя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиРуководителя");
	
	// Реквизиты документа-основания.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Оплаты";
	Шаблон.ОснованиеЗаполнения = "ДокументОснование";
	Шаблон.РеквизитСтроки      = Истина;
	Шаблон.Путь                = "Оплаты";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФизическоеЛицо");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РазмерПособия");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КоличествоСтраниц");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

Функция ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область ЗаявлениеСотрудникаНаВыплатуПособия

Функция БанковскиеРеквизитыСотрудникаДляВыплатыЗарплаты(Дата, Организация, Сотрудник, ФизическоеЛицо) Экспорт
	Результат = Новый Структура("Банк, НомерСчета");
	
	СведенияОМестеВыплаты = ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыСотрудника(Сотрудник, ФизическоеЛицо);
	Если Не СведенияОМестеВыплаты.Выбран() Тогда
		СведенияОМестеВыплаты = ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыОрганизации(Организация);
	КонецЕсли;
	
	// Вид - ПеречислениеСсылка.ВидыМестВыплатыЗарплаты.
	// МестоВыплаты - СправочникСсылка.ФизическиеЛица, СправочникСсылка.Кассы,
	//                СправочникСсылка.БанковскиеСчетаКонтрагентов, СправочникСсылка.ЗарплатныеПроекты.
	
	Если СведенияОМестеВыплаты.Вид = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
		
		ТаблицаЛицевыхСчетов = ОбменСБанкамиПоЗарплатнымПроектам.ЛицевыеСчетаСотрудников(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
			Истина,
			Организация,
			Дата,
			СведенияОМестеВыплаты.МестоВыплаты);
		
		Если ТаблицаЛицевыхСчетов.Количество() > 0 Тогда
			ТаблицаЛицевыхСчетов.Сортировать("МесяцОткрытия Убыв");
			Результат.Банк       = ТаблицаЛицевыхСчетов[0].Банк;
			Результат.НомерСчета = ТаблицаЛицевыхСчетов[0].НомерЛицевогоСчета;
		КонецЕсли;
		
	ИначеЕсли СведенияОМестеВыплаты.Вид = Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет
		И ТипЗнч(СведенияОМестеВыплаты.МестоВыплаты) = Тип("СправочникСсылка.БанковскиеСчетаКонтрагентов")
		И ЗначениеЗаполнено(СведенияОМестеВыплаты.МестоВыплаты) Тогда
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СведенияОМестеВыплаты.МестоВыплаты, "Банк, НомерСчета", Истина);
		ЗаполнитьЗначенияСвойств(Результат, ЗначенияРеквизитов);
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция РайонныйКоэффициентРФПодразделенияОрганизацииДляЗаявленияСотрудникаНаВыплатуПособия(Организация, Подразделение = Неопределено) Экспорт
	
	Если Подразделение = Неопределено Тогда
		Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка()
	КонецЕсли;
	
	// Размер районного коэффициента, установленного для организации
	РайонныйКоэффициентРФПодразделенияОрганизации = 1;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Подразделение",Подразделение);
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Подразделение.РайонныйКоэффициентРФ > 1
	|			ТОГДА Подразделение.РайонныйКоэффициентРФ
	|		КОГДА Организации.РайонныйКоэффициентРФ > 1
	|			ТОГДА Организации.РайонныйКоэффициентРФ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК РайонныйКоэффициентРФОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК Подразделение
	|		ПО Организации.Ссылка = Подразделение.Владелец
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|	И (&Подразделение = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	|			ИЛИ Подразделение.Ссылка = &Подразделение)";
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		РайонныйКоэффициентРФПодразделенияОрганизации = Выборка.РайонныйКоэффициентРФОрганизации;
	КонецЕсли;
	
	Возврат РайонныйКоэффициентРФПодразделенияОрганизации
	
КонецФункции

Процедура ПометитьЗаявлениеНаУдаление(ЗаявлениеСсылка) Экспорт
	ЗаявлениеОбъект = ЗаявлениеСсылка.ПолучитьОбъект();
	ЗаявлениеОбъект.УстановитьПометкуУдаления(Истина);
КонецПроцедуры

Процедура ДобавитьКомандыПечатиЗаявленияСотрудникаНаВыплатуПособия(КомандыПечати) Экспорт
	
	// Печать заявления о выплате пособия.
	Если ПравоДоступа("Использование", Метаданные.Обработки.ПечатьПрямыеВыплатыПособийСоциальногоСтрахованияФСС) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик     = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьПрямыеВыплатыПособийСоциальногоСтрахованияФСС";
		КомандаПечати.Идентификатор  = "СправкаПоРасчетуСуммыДоплатыПособия";
		КомандаПечати.Представление  = НСтр("ru = 'Справка по расчету суммы доплаты пособия'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОбновленииВторичныхДанныхЗаявления(ЗаявлениеОбъект, ПараметрыФиксации, Модифицирован) Экспорт
	
	РеквизитыДокумента = Новый Структура("ИзвещениеИзФССНомер, ИзвещениеИзФССДата");
	Если (ЗначениеЗаполнено(ЗаявлениеОбъект.Ссылка) Или ЗначениеЗаполнено(ЗаявлениеОбъект.ДокументОснование))
		И Не ФиксацияВторичныхДанныхВДокументах.РеквизитыШапкиЗафиксированы(ЗаявлениеОбъект, РеквизитыДокумента) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзвещениеФСС.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ИзвещениеФСС.ИсходящееЗаявление = &Ссылка
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Приоритет,
		|	ИзвещениеФСС.ВходящийНомер КАК ВходящийНомер,
		|	ИзвещениеФСС.ВходящаяДата КАК ВходящаяДата
		|ИЗ
		|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
		|ГДЕ
		|	(ИзвещениеФСС.ИсходящееЗаявление = &Ссылка
		|			ИЛИ ИзвещениеФСС.ИсходящийПервичныйДокумент = &ДокументОснование)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
		Если ЗначениеЗаполнено(ЗаявлениеОбъект.Ссылка) Тогда
			Запрос.УстановитьПараметр("Ссылка", ЗаявлениеОбъект.Ссылка);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИзвещениеФСС.ИсходящееЗаявление = &Ссылка", "ЛОЖЬ");
		КонецЕсли;
		Если ЗначениеЗаполнено(ЗаявлениеОбъект.ДокументОснование) Тогда
			Запрос.УстановитьПараметр("ДокументОснование", ЗаявлениеОбъект.ДокументОснование);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИзвещениеФСС.ИсходящийПервичныйДокумент = &ДокументОснование", "ЛОЖЬ");
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			РеквизитыДокумента.ИзвещениеИзФССДата  = Выборка.ВходящаяДата;
			РеквизитыДокумента.ИзвещениеИзФССНомер = Формат(Выборка.ВходящийНомер, "ЧГ="); // АПК:456 Не локализуется.
		КонецЕсли;
		
		Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЗаявлениеОбъект, ПараметрыФиксации) Тогда
			Модифицирован = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОбновленииФормыЗаявления(Форма) Экспорт
	
	ЗаголовокНадписи = "";
	ЗаявлениеОбъект = Форма.Объект;
	Если ЗначениеЗаполнено(ЗаявлениеОбъект.ИзвещениеИзФССНомер)
		И ЗначениеЗаполнено(ЗаявлениеОбъект.ИзвещениеИзФССДата) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзвещениеФСС.Ссылка КАК Ссылка,
		|	ИзвещениеФСС.Представление КАК Представление
		|ИЗ
		|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
		|ГДЕ
		|	ИзвещениеФСС.ВходящийНомер = &ВходящийНомер
		|	И ИзвещениеФСС.ВходящаяДата = &ВходящаяДата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИзвещениеФСС.ПометкаУдаления,
		|	ИзвещениеФСС.Ссылка УБЫВ";
		Запрос.УстановитьПараметр("ВходящийНомер", СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ЗаявлениеОбъект.ИзвещениеИзФССНомер));
		Запрос.УстановитьПараметр("ВходящаяДата",  ЗаявлениеОбъект.ИзвещениеИзФССДата);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Адрес = ПолучитьНавигационнуюСсылку(Выборка.Ссылка);
			ЗаголовокНадписи = СтроковыеФункции.ФорматированнаяСтрока(
				СтрШаблон("<a href=""%1"">%2</a>", Адрес, Выборка.Представление));
		КонецЕсли;
	КонецЕсли;
	Форма.Элементы.ИзвещениеИзФСССсылка.Заголовок = ЗаголовокНадписи;
	
КонецПроцедуры

#КонецОбласти

#Область РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий

Процедура ПриОпределенииЗапросаРеестраПрямыхВыплатПоОтпускамПоУходу(Запрос, ТаблицаОснований)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтпускПоУходуЗаРебенкомДанныеОДетях.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(ОтпускПоУходуЗаРебенкомДанныеОДетях.Имя) > 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОдновременныйУходЗаНесколькимиДетьми
	|ПОМЕСТИТЬ МногодетныеДокументы
	|ИЗ
	|	ВТЗаявления КАК ВТЗаявления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком.ДанныеОДетях КАК ОтпускПоУходуЗаРебенкомДанныеОДетях
	|		ПО ВТЗаявления.ДокументОснование = ОтпускПоУходуЗаРебенкомДанныеОДетях.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускПоУходуЗаРебенкомДанныеОДетях.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТЗаявления.Заявление КАК Заявление,
	|	ВТЗаявления.Сотрудник КАК Сотрудник,
	|	ВТЗаявления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ДатаРожденияРебенка КАК ДатаРожденияРебенка,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ФамилияРебенка КАК ФамилияРебенка,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ИмяРебенка КАК ИмяРебенка,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ОтчествоРебенка КАК ОтчествоРебенка,
	|	ВТЗаявления.ПервичныйДокумент КАК ПервичныйДокумент,
	|	ОтпускПоУходуЗаРебенкомДанныеОДетях.Очередность КАК ОчередностьРожденияРебенка,
	|	ВЫБОР
	|		КОГДА ОтпускПоУходуЗаРебенком.Ссылка ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаСвидетельстваОРождении = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыПодтверждающихДокументовОтпускаПоУходу.СвидетельствоОРождении)
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаРешенияОбОпеке = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыПодтверждающихДокументовОтпускаПоУходу.РешениеОбУстановленииОпеки)
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаИногоДокументаПодтверждающегоРождение = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыПодтверждающихДокументовОтпускаПоУходу.ИнойДокументПодтверждающийРождениеРебенка)
	|				КОНЕЦ
	|		ИНАЧЕ ОтпускПоУходуЗаРебенкомДанныеОДетях.ВидПодтверждающегоДокумента
	|	КОНЕЦ КАК ВидПодтверждающегоДокумента,
	|	ОтпускПоУходуЗаРебенкомДанныеОДетях.НаименованиеПодтверждающегоДокумента КАК НаименованиеПодтверждающегоДокумента,
	|	ВЫБОР
	|		КОГДА ОтпускПоУходуЗаРебенком.Ссылка ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаСвидетельстваОРождении = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.ДатаСвидетельстваОРождении
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаРешенияОбОпеке = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.ДатаРешенияОбОпеке
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаИногоДокументаПодтверждающегоРождение = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.ДатаИногоДокументаПодтверждающегоРождение
	|				КОНЕЦ
	|		ИНАЧЕ ОтпускПоУходуЗаРебенкомДанныеОДетях.ДатаДокумента
	|	КОНЕЦ КАК ДатаДокумента,
	|	ВЫБОР
	|		КОГДА ОтпускПоУходуЗаРебенком.Ссылка ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаСвидетельстваОРождении = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.СерияСвидетельстваОРождении
	|				КОНЕЦ
	|		ИНАЧЕ ОтпускПоУходуЗаРебенкомДанныеОДетях.СерияДокумента
	|	КОНЕЦ КАК СерияДокумента,
	|	ВЫБОР
	|		КОГДА ОтпускПоУходуЗаРебенком.Ссылка ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаСвидетельстваОРождении = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.НомерСвидетельстваОРождении
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаРешенияОбОпеке = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.НомерРешенияОбОпеке
	|					КОГДА НЕ ЗаявлениеСотрудникаНаВыплатуПособия.ДатаИногоДокументаПодтверждающегоРождение = ДАТАВРЕМЯ(1, 1, 1)
	|						ТОГДА ЗаявлениеСотрудникаНаВыплатуПособия.НомерИногоДокументаПодтверждающегоРождение
	|				КОНЕЦ
	|		ИНАЧЕ ОтпускПоУходуЗаРебенкомДанныеОДетях.НомерДокумента
	|	КОНЕЦ КАК НомерДокумента,
	|	ОтпускПоУходуЗаРебенкомДанныеОДетях.НаличиеРешенияСудаОЛишенииПрав КАК НаличиеРешенияСудаОЛишенииПрав,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ФинансированиеФедеральнымБюджетом КАК ФинансированиеФедеральнымБюджетом,
	|	МногодетныеДокументы.ОдновременныйУходЗаНесколькимиДетьми КАК ОдновременныйУходЗаНесколькимиДетьми,
	|	ВТЗаявления.ДатаПредставленияПакетаДокументов КАК ДатаПредставленияПакетаДокументов,
	|	ВТЗаявления.ИзвещениеИзФССНомер КАК ИзвещениеИзФССНомер,
	|	ВТЗаявления.ИзвещениеИзФССДата КАК ИзвещениеИзФССДата,
	|	ВЫБОР
	|		КОГДА ВТЗаявления.ИзвещениеИзФССНомер <> """"
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИзвещениеИзФССИспользование
	|ИЗ
	|	ВТЗаявления КАК ВТЗаявления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудникаНаВыплатуПособия
	|		ПО ВТЗаявления.Заявление = ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком.ДанныеОДетях КАК ОтпускПоУходуЗаРебенкомДанныеОДетях
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
	|			ПО ОтпускПоУходуЗаРебенкомДанныеОДетях.Ссылка = ОтпускПоУходуЗаРебенком.Ссылка
	|		ПО ВТЗаявления.ДокументОснование = ОтпускПоУходуЗаРебенкомДанныеОДетях.Ссылка
	|			И ВТЗаявления.ИдентификаторСтрокиОснования = ОтпускПоУходуЗаРебенкомДанныеОДетях.ИдентификаторСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ МногодетныеДокументы КАК МногодетныеДокументы
	|		ПО ВТЗаявления.ДокументОснование = МногодетныеДокументы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРанееПринятыеРеестры КАК ВТРанееПринятыеРеестры
	|		ПО ВТЗаявления.Заявление = ВТРанееПринятыеРеестры.Заявление";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
