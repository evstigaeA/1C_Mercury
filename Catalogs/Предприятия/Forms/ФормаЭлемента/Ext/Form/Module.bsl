﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		Если Не ЗначениеЗаполнено(Объект.GUID_Меркурий) Тогда
			Объект.НеИспользуется = Истина;
		КонецЕсли;
		Объект.ВидРоссийскогоПредприятия = Справочники.ВидыПредприятий.Предприятие;
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") И Параметры.Основание <> Неопределено Тогда
		СкладУчетнойСистемы = Параметры.Основание;
		ЗаполнитьЗначенияСвойств(Объект, СкладУчетнойСистемы);
	КонецЕсли;
	
	Организация = ПараметрыСеанса.ТекущийПользователь.ОсновнаяОрганизация;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	 // СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(СкладУчетнойСистемы) Тогда
		СтруктураЗаписи = Новый Структура();
		
		СтруктураЗаписи.Вставить("СкладУчетнойСистемы", СкладУчетнойСистемы);
		СтруктураЗаписи.Вставить("Предприятие",         Объект.Ссылка);
		
		РегистрыСведений.СоответствиеПредприятийСкладамУчетнойСистемы.ДобавитьЗапись(СтруктураЗаписи);
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновлениеДанныхПредприятия" Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеятельностьОсуществляемаяПредприятиемПриИзменении(Элемент)
	
	Если СтрДлина(Объект.ДеятельностьОсуществляемаяПредприятием) > 255 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Длина поля ""Деятельность, осуществляемая предприятием"" не должна превышать 255 символов.'"));
		Объект.ДеятельностьОсуществляемаяПредприятием = Лев(Объект.ДеятельностьОсуществляемаяПредприятием, 255);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКонтактнаяИнформация

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
    УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Страна", Объект.СтранаРегистрации);
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Страна", Объект.СтранаРегистрации);
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
    УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
    УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти