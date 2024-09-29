﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
	КонецЕсли;
	
	Если Параметры.Свойство("ГруппаПоискВидимость") Тогда
		Элементы.ГруппаПоиск.Видимость = Параметры.ГруппаПоискВидимость;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ПодключитьОбработчикОжидания("ВыполнитьПоиск", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.ШагиЗагрузки.ТекущаяСтраница <> Элементы.ОжиданиеЗагрузки 
		Или ПодтверждениеЗакрытияФормы = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
	Текст = НСтр("ru = 'Прервать загрузку списка предприятий?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Предприятия.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоискПредприятий(Команда)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка данных из ИС ""Меркурий""...'");
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
	Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(Контрагент, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	НастройкиОжидания.ПолучатьРезультат = Истина;
	НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	Обработчик = Новый ОписаниеОповещения("ПослеФоновойЗагрузкиССайта", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);

	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	// Запущенное
	Элементы.ПрерватьЗагрузку.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из Предприятия Цикл
		ТекСтрока.Загружать = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из Предприятия Цикл
		ТекСтрока.Загружать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыбранные(Команда)
	
	ЗагрузитьВыбранныеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВыбранныеНаСервере()
	
	ПредприятияДляЗагрузки = Предприятия.НайтиСтроки(Новый Структура("Загружать", Истина));
	
	Если ПредприятияДляЗагрузки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбраны предприятия для загрузки.'"));
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	ИнтеграцияВетисAPIКонтрагентыПредприятия.СоздатьОбновитьДанныеПредприятий(ПредприятияДляЗагрузки, Контрагент, ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПредставлениеОшибки = НСтр("ru = 'При загрузке предприятий произошли ошибки:'") + Символы.ПС + ТекстОшибки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Загрузка предприятий завершена.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьЗагрузку(Команда)
	
	Если ИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПрерватьЗагрузкуСервер();
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиССайта(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда
		ТекстОшибки = НСтр("ru = 'При получении списка предприятий произошли ошибки: '") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
		ВывестиСообщениеОбОшибке(ТекстОшибки);
	ИначеЕсли Задание.Статус = "Выполнено" Тогда
		ОбработатьРезультат(Задание.АдресРезультата);
		ЗавершениеЗагрузки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщениеОбОшибке(Знач ТекстОшибки)
	ОчиститьСообщения();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ЗагрузкаПредприятий;
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультат(АдресРезультата)
	
	РезультатВыполненияОперации = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если РезультатВыполненияОперации.КоличествоНайденных = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='К данному хозяйствующему субъекту предприятия не привязаны.'"));
	Иначе
		ОбработатьРезультатВыполненияОперации(РезультатВыполненияОперации.Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузки()
	
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ЗагрузкаПредприятий;
	Элементы.ЗагрузитьВыбранные.КнопкаПоУмолчанию = Истина;
	ТекущийЭлемент = Элементы.ЗагрузитьВыбранные;
	
	Возврат;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуССайтаНаСервере(Контрагент, УникальныйИдентификатор)
	
	ПараметрыВызоваСервера = Новый Массив;
	ПараметрыВызоваСервера.Добавить(Контрагент);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка списка предприятий'");

	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIКонтрагентыПредприятия.ФоновоеЗаданиеЗагрузкаСпискаПредприятийКонтрагента",
		ПараметрыВызоваСервера, ПараметрыВыполнения);
		
	Возврат ФоновоеЗадание;
КонецФункции

&НаКлиенте
Процедура ПрогрессВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполняется" Тогда
		Прогресс = ПрочитатьПрогресс(Результат.ИдентификаторЗадания);
		Если Прогресс <> Неопределено Тогда
			ТекстСостоянияЗагрузки = Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьРезультатВыполненияОперации(ТаблицаПредприятий)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаПредприятий.Наименование КАК Наименование,
		|	ТаблицаПредприятий.GUID_Меркурий КАК GUID_Меркурий,
		|	ТаблицаПредприятий.GLN КАК GLN,
		|	ТаблицаПредприятий.СписокНомеров КАК СписокНомеров,
		|	ТаблицаПредприятий.ВидПредприятия КАК ВидПредприятия,
		|	ТаблицаПредприятий.СтатусПредприятия КАК СтатусПредприятия,
		|	ТаблицаПредприятий.АдресПредприятия КАК АдресПредприятия,
		|	ТаблицаПредприятий.ОписаниеОбъекта КАК ОписаниеОбъекта
		|ПОМЕСТИТЬ ВТ_ТаблицаПредприятий
		|ИЗ
		|	&ТаблицаПредприятий КАК ТаблицаПредприятий
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаПредприятий.Наименование КАК Наименование,
		|	ВТ_ТаблицаПредприятий.GUID_Меркурий КАК GUID_Меркурий,
		|	ВТ_ТаблицаПредприятий.GLN КАК GLN,
		|	ВТ_ТаблицаПредприятий.СписокНомеров КАК СписокНомеров,
		|	ВидыПредприятий.Ссылка КАК ВидПредприятия,
		|	ВТ_ТаблицаПредприятий.АдресПредприятия КАК АдресПредприятия,
		|	ВТ_ТаблицаПредприятий.ОписаниеОбъекта КАК ОписаниеОбъекта,
		|	ВЫБОР
		|		КОГДА Предприятия.Ссылка ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Загружено,
		|	ВЫБОР
		|		КОГДА СвязиМеждуКонтрагентамиИПредприятиями.Предприятие ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Связано,
		|	СтатусыПредприятий.Ссылка КАК СтатусПредприятия
		|ИЗ
		|	ВТ_ТаблицаПредприятий КАК ВТ_ТаблицаПредприятий
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Предприятия КАК Предприятия
		|		ПО ВТ_ТаблицаПредприятий.GUID_Меркурий = Предприятия.GUID_Меркурий
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПредприятий КАК ВидыПредприятий
		|		ПО ВТ_ТаблицаПредприятий.ВидПредприятия = ВидыПредприятий.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиМеждуКонтрагентамиИПредприятиями КАК СвязиМеждуКонтрагентамиИПредприятиями
		|		ПО ВТ_ТаблицаПредприятий.GUID_Меркурий = СвязиМеждуКонтрагентамиИПредприятиями.Предприятие.GUID_Меркурий
		|			И (СвязиМеждуКонтрагентамиИПредприятиями.Контрагент = &Контрагент)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтатусыПредприятий КАК СтатусыПредприятий
		|		ПО ВТ_ТаблицаПредприятий.СтатусПредприятия = СтатусыПредприятий.Код";
		
	Запрос.УстановитьПараметр("ТаблицаПредприятий", ТаблицаПредприятий);
	Запрос.УстановитьПараметр("Контрагент"        , Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Предприятия.Загрузить(РезультатЗапроса.Выгрузить());

КонецПроцедуры

// Завершение диалога закрытия формы.
&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		ПрерватьЗагрузкуСервер();
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрерватьЗагрузкуСервер()
	
	МодульДлительныеОперации = ОбщегоНазначения.ОбщийМодуль("ДлительныеОперации");
	МодульДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти