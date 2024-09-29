﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если Параметры.Свойство("Отображение") Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы[Параметры.Отображение];
	КонецЕсли;
	
	СписокВыбораПубликаций = Элементы.ПубликацияОтбор.СписокВыбора;
	
	ВидИспользуется = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
	ВидОтключена = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
	ВидРежимОтладки = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
	
	ДоступныеВидыПубликации = ДополнительныеОтчетыИОбработкиПовтИсп.ДоступныеВидыПубликации();
	
	ВсеПубликацииКромеНеиспользующихся = Новый Массив;
	ВсеПубликацииКромеНеиспользующихся.Добавить(ВидИспользуется);
	Если ДоступныеВидыПубликации.Найти(ВидРежимОтладки) <> Неопределено Тогда
		ВсеПубликацииКромеНеиспользующихся.Добавить(ВидРежимОтладки);
	КонецЕсли;
	Если ВсеПубликацииКромеНеиспользующихся.Количество() > 1 Тогда
		ПредставлениеМассива = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 или %2'"),
			Строка(ВсеПубликацииКромеНеиспользующихся[0]),
			Строка(ВсеПубликацииКромеНеиспользующихся[1]));
		СписокВыбораПубликаций.Добавить(1, ПредставлениеМассива);
	КонецЕсли;
	Для Каждого ЗначениеПеречисления Из Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок Цикл
		Если ДоступныеВидыПубликации.Найти(ЗначениеПеречисления) <> Неопределено Тогда
			СписокВыбораПубликаций.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Отбор.Свойство("Публикация") Тогда
		ПубликацияОтбор = Параметры.Отбор.Публикация;
		Параметры.Отбор.Удалить("Публикация");
		Если СписокВыбораПубликаций.НайтиПоЗначению(ПубликацияОтбор) = Неопределено Тогда
			ПубликацияОтбор = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	СписокВыбора = Элементы.ВидОтбор.СписокВыбора;
	СписокВыбора.Добавить(1, НСтр("ru = 'Только отчеты'"));
	СписокВыбора.Добавить(2, НСтр("ru = 'Только обработки'"));
	Для Каждого ЗначениеПеречисления Из Перечисления.ВидыДополнительныхОтчетовИОбработок Цикл
		СписокВыбора.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
	КонецЦикла;
	
	ВидыДопОтчетов = Новый Массив;
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет);
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет);
	
	Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор",        ВидОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыДопОтчетов",  ВидыДопОтчетов);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПубликацииКромеНеиспользующихся", ВсеПубликацииКромеНеиспользующихся);
	
	ПравоДобавления = ДополнительныеОтчетыИОбработки.ПравоДобавления();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Создать",              "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьМеню",          "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьГруппу",        "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьГруппуМеню",    "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Скопировать",          "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СкопироватьМеню",      "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьИзФайла",     "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьИзФайлаМеню", "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыгрузитьВФайл",       "Видимость", ПравоДобавления);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыгрузитьВФайлМеню",   "Видимость", ПравоДобавления);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	
	ПрофилиИспользуются = Не ИспользуютсяПрофилиБезопасности;
	Элементы.ИзменитьПометкуУдаленияБезПрофилей.Видимость     = Не ПрофилиИспользуются;
	Элементы.ИзменитьПометкуУдаленияБезПрофилейМеню.Видимость = Не ПрофилиИспользуются;
	Элементы.ИзменитьПометкуУдаленияСПрофилями.Видимость     = ПрофилиИспользуются;
	Элементы.ИзменитьПометкуУдаленияСПрофилямиМеню.Видимость = ПрофилиИспользуются;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
		Или Не ПравоДоступа("Изменение", Метаданные.Справочники.ДополнительныеОтчетыИОбработки) Тогда
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
		Элементы.ИзменитьВыделенныеМеню.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПроверкаДополнительныхОтчетовИОбработок") Тогда
		Элементы.Создать.Видимость = Ложь;
		Элементы.СоздатьГруппу.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Если Не ЗначениеЗаполнено(ПубликацияОтбор) Тогда
		ПубликацияОтбор = Настройки.Получить("ПубликацияОтбор");
		Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	КонецЕсли;
	ВидОтбор = Настройки.Получить("ВидОтбор");
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор", ВидОтбор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПубликацияОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ПубликацияОтбор");
	Если ЗначениеПараметраКД.Значение <> ПубликацияОтбор Тогда
		ЗначениеПараметраКД.Значение = ПубликацияОтбор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ВидОтбор");
	Если ЗначениеПараметраКД.Значение <> ВидОтбор Тогда
		ЗначениеПараметраКД.Значение = ВидОтбор;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Если ПрофилиИспользуются Тогда
		Отказ = Истина;
		СписокИзменитьПометкуУдаления();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или Не ВыбранЭлемент(ДанныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("Ссылка",   ДанныеСтроки.Ссылка);
	ПараметрыВыгрузки.Вставить("ЭтоОтчет", ДанныеСтроки.ЭтоОтчет);
	ПараметрыВыгрузки.Вставить("ИмяФайла", ДанныеСтроки.ИмяФайла);
	ДополнительныеОтчетыИОбработкиКлиент.ВыгрузитьВФайл(ПараметрыВыгрузки);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлОбработкиОтчета(Команда)
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или Не ВыбранЭлемент(ДанныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ДанныеСтроки.Ссылка);
	ПараметрыФормы.Вставить("ПоказатьДиалогЗагрузкиИзФайлаПриОткрытии", Истина);
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
	МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияИспользуется(Команда)
	ИзменитьПубликацию("Используется");
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияОтключена(Команда)
	ИзменитьПубликацию("Отключена");
КонецПроцедуры

&НаКлиенте
Процедура ПубликацияРежимОтладки(Команда)
	ИзменитьПубликацию("РежимОтладки");
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометкуУдаленияСПрофилями(Команда)
	СписокИзменитьПометкуУдаления();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ВыбранЭлемент(ДанныеСтроки)
	Если ТипЗнч(ДанныеСтроки.Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.
			|Выберите дополнительный отчет или обработку.'"));
		Возврат Ложь;
	КонецЕсли;
	Если ДанныеСтроки.ЭтоГруппа Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для группы.
			|Выберите дополнительный отчет или обработку.'"));
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьФайлОбработкиОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ФайлЗагружен" Тогда
		ПоказатьЗначение(,Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	//
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	//
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПубликацию(ВариантПубликации)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = ВыделенныеСтроки.Количество();
	Если КоличествоСтрок = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один дополнительный отчет (обработка)'"));
		Возврат;
	КонецЕсли;
	
	ИзменениеПубликации(ВариантПубликации);
	
	Если КоличествоСтрок = 1 Тогда
		ТекстСообщения = НСтр("ru = 'Изменена публикация дополнительного отчета (обработки) ""%1""'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка(ВыделенныеСтроки[0]));
	Иначе
		ТекстСообщения = НСтр("ru = 'Изменена публикация у дополнительных отчетов (обработок): %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КоличествоСтрок);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Изменена публикация'"),, ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеПубликации(ВариантПубликации)
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ДополнительныйОтчетИлиОбработка Из ВыделенныеСтроки Цикл
			ЗаблокироватьДанныеДляРедактирования(ДополнительныйОтчетИлиОбработка);
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ДополнительныеОтчетыИОбработки");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ДополнительныйОтчетИлиОбработка);
			Блокировка.Заблокировать();
		КонецЦикла;
		
		Для Каждого ДополнительныйОтчетИлиОбработка Из ВыделенныеСтроки Цикл
			Объект = ДополнительныйОтчетИлиОбработка.ПолучитьОбъект();
			Если ВариантПубликации = "Используется" Тогда
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
			ИначеЕсли ВариантПубликации = "РежимОтладки" Тогда
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
			Иначе
				Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
			КонецЕсли;
			
			Объект.ДополнительныеСвойства.Вставить("ПроверкаСписка");
			Если Не Объект.ПроверитьЗаполнение() Тогда
				ПредставлениеОшибки = "";
				МассивСообщений = ПолучитьСообщенияПользователю(Истина);
				Для Каждого СообщениеПользователю Из МассивСообщений Цикл
					ПредставлениеОшибки = ПредставлениеОшибки + СообщениеПользователю.Текст + Символы.ПС;
				КонецЦикла;
				
				ВызватьИсключение ПредставлениеОшибки;
			КонецЕсли;
			
			Объект.Записать();
		КонецЦикла;
		
		РазблокироватьДанныеДляРедактирования();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		РазблокироватьДанныеДляРедактирования();
		ВызватьИсключение;
	КонецПопытки;
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИзменитьПометкуУдаления()
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура("Ссылка, ПометкаУдаления");
	ЗаполнитьЗначенияСвойств(Контекст, СтрокаТаблицы);
	
	Если Контекст.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, СтрокаТаблицы.Наименование);
	
	Обработчик = Новый ОписаниеОповещения("СписокИзменитьПометкуУдаленияПослеПодтверждения", ЭтотОбъект, Контекст);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура СписокИзменитьПометкуУдаленияПослеПодтверждения(Ответ, Контекст) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("Запросы", Неопределено);
	Контекст.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	ЗаблокироватьОбъектыИСформироватьЗапросыРазрешений(Контекст);
	
	Обработчик = Новый ОписаниеОповещения("СписокИзменитьПометкуУдаленияПослеПодтвержденияЗапросов", ЭтотОбъект, Контекст);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Контекст.Запросы, ЭтотОбъект, Обработчик);
	Иначе
		ВыполнитьОбработкуОповещения(Обработчик, КодВозвратаДиалога.ОК);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаблокироватьОбъектыИСформироватьЗапросыРазрешений(Контекст)
	ЗаблокироватьДанныеДляРедактирования(Контекст.Ссылка, , Контекст.ИдентификаторФормы);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		Объект = Контекст.Ссылка.ПолучитьОбъект();
		
		Контекст.Запросы = ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный.ЗапросыРазрешенийДополнительнойОбработки(
			Объект,
			Объект.Разрешения.Выгрузить(),
			,
			Не Контекст.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИзменитьПометкуУдаленияПослеПодтвержденияЗапросов(Ответ, Контекст) Экспорт
	ИзменятьПометку = (Ответ = КодВозвратаДиалога.ОК);
	РазблокироватьИИзменитьПометкуУдаленияОбъектов(Контекст, ИзменятьПометку);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РазблокироватьИИзменитьПометкуУдаленияОбъектов(Контекст, ИзменятьПометку)
	Если ИзменятьПометку Тогда
		Объект = Контекст.Ссылка.ПолучитьОбъект();
		Объект.УстановитьПометкуУдаления(Не Контекст.ПометкаУдаления);
		Объект.Записать();
	КонецЕсли;
	РазблокироватьДанныеДляРедактирования(Контекст.Ссылка, Контекст.ИдентификаторФормы);
КонецПроцедуры

#КонецОбласти
