﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресХранения") Тогда
		АдресХранения = Параметры.АдресХранения;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоПросмотр") Тогда
		Элементы.ДеревоУпаковок.ТолькоПросмотр                     = Параметры.ТолькоПросмотр;
		Элементы.ДеревоУпаковокДобавитьУровеньУпаковки.Доступность = Не Параметры.ТолькоПросмотр;
		Элементы.ДеревоУпаковокДобавитьУпаковку.Доступность        = Не Параметры.ТолькоПросмотр;
		Элементы.ДеревоУпаковокДобавитьМаркировку.Доступность      = Не Параметры.ТолькоПросмотр;
		Элементы.ПеренестиВДокумент.Доступность                    = Не Параметры.ТолькоПросмотр;
	КонецЕсли;
	
	ИнициализацияФормы();
	
	ЗаполнитьДеревоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Отказ = Ложь;
	
	ПроверитьПравильностьЗаполнения(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// заполним табличную часть обработки по дереву
	ОбновитьТабличнуюЧастьУпаковок();
	
	Закрыть(Объект.СписокУпаковок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТабличнуюЧастьУпаковок()
	
	Объект.СписокУпаковок.Очистить();
	
	Для Каждого ТекУровень Из ДеревоУпаковок.ПолучитьЭлементы() Цикл
		
		Если ТекУровень.ПолучитьЭлементы().Количество() = 0 Тогда
			НоваяСтрока = Объект.СписокУпаковок.Добавить();
			НоваяСтрока.УровеньУпаковки = ТекУровень.ДанныеУпаковки;
		КонецЕсли;
		
		Для Каждого ТекУпаковка Из ТекУровень.ПолучитьЭлементы() Цикл
			
			Если ТекУпаковка.ПолучитьЭлементы().Количество() = 0 Тогда
				НоваяСтрока = Объект.СписокУпаковок.Добавить();
				НоваяСтрока.УровеньУпаковки    = ТекУровень.ДанныеУпаковки;
				НоваяСтрока.Упаковка           = ТекУпаковка.ДанныеУпаковки;
				НоваяСтрока.КоличествоУпаковок = ТекУпаковка.ДетальнаяИнформация;
			КонецЕсли;
			
			Для Каждого ТекМаркировка Из ТекУпаковка.ПолучитьЭлементы() Цикл
				
				НоваяСтрока = Объект.СписокУпаковок.Добавить();
				НоваяСтрока.УровеньУпаковки        = ТекУровень.ДанныеУпаковки;
				НоваяСтрока.Упаковка               = ТекУпаковка.ДанныеУпаковки;
				НоваяСтрока.КоличествоУпаковок     = ТекУпаковка.ДетальнаяИнформация;
				НоваяСтрока.ТипМаркировки          = ТекМаркировка.ДанныеУпаковки;
				НоваяСтрока.НаименованиеМаркировки = ТекМаркировка.ДетальнаяИнформация;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУровеньУпаковки(Команда)
	
	ОткрытьФорму("Справочник.УровниУпаковок.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораУровняУпаковок", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораУровняУпаковок(УровеньУпаковки, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(УровеньУпаковки) Тогда
		
		УровеньДобавлен = Ложь;
		КоллекцияЭлементовДерева = ДеревоУпаковок.ПолучитьЭлементы();
		Для Каждого ТекЭлемент Из КоллекцияЭлементовДерева Цикл
			Если УровеньУпаковки = ТекЭлемент.ДанныеУпаковки Тогда
				УровеньДобавлен = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если УровеньДобавлен Тогда
			Состояние(НСтр("ru = 'Обнаружен дублирующийся уровень упаковки. Редактирование отменено.'"));
		Иначе
			НовыйУровень = ДеревоУпаковок.ПолучитьЭлементы().Добавить();
			НовыйУровень.ДанныеУпаковки = УровеньУпаковки;
			НовыйУровень.Уровень        = 0;
			Элементы.ДеревоУпаковок.ТекущаяСтрока = НовыйУровень.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУпаковку(Команда)
	
	Если Не Элементы.ДеревоУпаковок.ТекущиеДанные = Неопределено Тогда
		ОткрытьФорму("Справочник.Упаковки.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораУпаковки", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораУпаковки(Упаковка, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Упаковка) Тогда
		
		Если Не Элементы.ДеревоУпаковок.ТекущиеДанные = Неопределено Тогда
			
			Если Элементы.ДеревоУпаковок.ТекущиеДанные.Уровень = 1 Тогда
				ТекРодитель = Элементы.ДеревоУпаковок.ТекущиеДанные.ПолучитьРодителя();
				НовыеДанные = ТекРодитель.ПолучитьЭлементы().Добавить();
				НовыеДанные.ДанныеУпаковки      = Упаковка;
				НовыеДанные.Уровень             = 1;
				НовыеДанные.ДетальнаяИнформация = 0;
			ИначеЕсли Элементы.ДеревоУпаковок.ТекущиеДанные.Уровень = 2 Тогда
				ТекРодитель = Элементы.ДеревоУпаковок.ТекущиеДанные.ПолучитьРодителя().ПолучитьРодителя();
				НовыеДанные = ТекРодитель.ПолучитьЭлементы().Добавить();
				НовыеДанные.ДанныеУпаковки      = Упаковка;
				НовыеДанные.Уровень             = 1;
				НовыеДанные.ДетальнаяИнформация = 0;
			Иначе
				НовыеДанные = Элементы.ДеревоУпаковок.ТекущиеДанные.ПолучитьЭлементы().Добавить();
				НовыеДанные.ДанныеУпаковки      = Упаковка;
				НовыеДанные.Уровень             = 1;
				НовыеДанные.ДетальнаяИнформация = 0;
			КонецЕсли;
			
			Элементы.ДеревоУпаковок.ТекущаяСтрока = НовыеДанные.ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМаркировку(Команда)
	
	Если Не Элементы.ДеревоУпаковок.ТекущиеДанные = Неопределено Тогда
		
		Если Элементы.ДеревоУпаковок.ТекущиеДанные.Уровень = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При добавлении маркировки необходимо чтобы текущая строка была либо на уровне упаковки либо на уровне маркировки!");
			Возврат;
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ТипыМаркировок.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораТипаМаркировки", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораТипаМаркировки(ТипМаркировки, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ТипМаркировки) Тогда
		
		Если Не Элементы.ДеревоУпаковок.ТекущиеДанные = Неопределено Тогда
			
			Если Элементы.ДеревоУпаковок.ТекущиеДанные.Уровень = 1 Тогда
				НовыеДанные = Элементы.ДеревоУпаковок.ТекущиеДанные.ПолучитьЭлементы().Добавить();
				НовыеДанные.ДанныеУпаковки      = ТипМаркировки;
				НовыеДанные.Уровень             = 2;
				НовыеДанные.ДетальнаяИнформация = "";
			ИначеЕсли Элементы.ДеревоУпаковок.ТекущиеДанные.Уровень = 2 Тогда
				ТекРодитель = Элементы.ДеревоУпаковок.ТекущиеДанные.ПолучитьРодителя();
				НовыеДанные = ТекРодитель.ПолучитьЭлементы().Добавить();
				НовыеДанные.ДанныеУпаковки      = ТипМаркировки;
				НовыеДанные.Уровень             = 2;
				НовыеДанные.ДетальнаяИнформация = "";
			КонецЕсли;
			
			Элементы.ДеревоУпаковок.ТекущаяСтрока = НовыеДанные.ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДереваУпаковок

&НаКлиенте
Процедура ДеревоУпаковокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущиеДанные = Элементы.ДеревоУпаковок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		// Данных нет значит даем возможность на добавление уровня упаковки
		
		ОткрытьФорму("Справочник.УровниУпаковок.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораУровняУпаковок", ЭтотОбъект));
		
	Иначе
		
		Уровень = ТекущиеДанные.Уровень;
		
		Если Уровень = 0 Тогда
			// Находимся на строке уровень упаковки значит даем возможность на добавление упаковки
			ОткрытьФорму("Справочник.Упаковки.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораУпаковки", ЭтотОбъект, "Добавление"));
		ИначеЕсли Уровень = 1 ИЛИ Уровень = 2 Тогда
			// Находимся на строке упаковки либо маркировки значит даем возможность на добавление маркировки
			ОткрытьФорму("Справочник.ТипыМаркировок.ФормаВыбора", Новый Структура("РежимВыбора", Истина), , , , , Новый ОписаниеОповещения("ВыполнитьПослеВыбораТипаМаркировки", ЭтотОбъект));
		КонецЕсли;
		
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУпаковокПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ДеревоУпаковок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Уровень = ТекущиеДанные.Уровень;
	
	Если Уровень = 0 Тогда//Уровень упаковки
		Элементы.ДеревоУпаковокДанныеУпаковки.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.УровниУпаковок");
	ИначеЕсли Уровень = 1 Тогда//Упаковка
		Элементы.ДеревоУпаковокДанныеУпаковки.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Упаковки");
	ИначеЕсли Уровень = 2 Тогда//Маркировка
		Элементы.ДеревоУпаковокДанныеУпаковки.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ТипыМаркировок");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоУпаковокДанныеУпаковкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоУпаковок.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Уровень <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	КоллекцияЭлементовДерева = ДеревоУпаковок.ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из КоллекцияЭлементовДерева Цикл
		Если ТекущиеДанные <> ТекЭлемент Тогда
			Если ТекущиеДанные.ДанныеУпаковки = ТекЭлемент.ДанныеУпаковки Тогда
				Состояние(НСтр("ru = 'Обнаружен дублирующийся уровень упаковки. Редактирование отменено.'"));
				ТекущиеДанные.ДанныеУпаковки = ТекущийУровеньУпаковки;
				Элементы.ДеревоУпаковок.ЗакончитьРедактированиеСтроки(Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВозможностьПереноса(ПереносимыйЭлемент, Знач НовыйРодитель)
	
	Если НовыйРодитель = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПереносимыйЭлемент = НовыйРодитель ИЛИ ПереносимыйЭлемент.Уровень = 0 Тогда//Верхний уровень ни куда не переносится
		Возврат Ложь;
	КонецЕсли;
	Если ПереносимыйЭлемент.Уровень = 1 И НовыйРодитель.Уровень <> 0 Тогда//Уровень упаковок может быть подчинен только уровню уровень упаковок
		Возврат Ложь;
	КонецЕсли;
	Если ПереносимыйЭлемент.Уровень = 2 И НовыйРодитель.Уровень <> 1 Тогда//Уровень маркировки может быть подчинен только уровню упаковок
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ДеревоУпаковокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	// Узел нельзя переносить в узлы подчиненные ему самому
	// т.е. родительский узел нельзя переносить в дочерние.
	// Так же нельзя переносить верхний уровень (уровень = 0)
	// Проверим эти условия для всех выделенных элементов
	
	СтандартнаяОбработка = Ложь;
	
	РеквизитДерево = ЭтаФорма["ДеревоУпаковок"];
	
	ИДНовыйРодитель = Строка;
	// Если НовыйРодитель = Неопределено => Корень дерева
	НовыйРодитель = ?(ИДНовыйРодитель = Неопределено, Неопределено, РеквизитДерево.НайтиПоИдентификатору(ИДНовыйРодитель));
	
	МассивИДПереносимыхЭлементов = ПараметрыПеретаскивания.Значение;
	
	Для каждого ИДПереносимыйЭлемент из МассивИДПереносимыхЭлементов Цикл
		
		ПереносимыйЭлемент = РеквизитДерево.НайтиПоИдентификатору(ИДПереносимыйЭлемент);
		
		Если НЕ ПроверитьВозможностьПереноса(ПереносимыйЭлемент, НовыйРодитель) Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция СкопироватьСтрокуДерева(РеквизитДерево, Приемник, Источник)
	
	Перем НоваяСтрока, ОбратныйИндекс, КолПодчиненныхСтрок;
	
	// Источник может быть уже перенесен
	// Это происходит если выделены несколько элементов
	// одной и той же ветви дерева на разных уровнях иерархии
	Если Источник = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Приемник = Неопределено Тогда
		// Добавляем в корень
		НоваяСтрока = РеквизитДерево.ПолучитьЭлементы().Добавить();
	Иначе
		НоваяСтрока = Приемник.ПолучитьЭлементы().Добавить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Источник);
	
	КолПодчиненныхСтрок = Источник.ПолучитьЭлементы().Количество();
	Для ОбратныйИндекс = 1 По КолПодчиненныхСтрок Цикл
		ПодчиненнаяСтрока = Источник.ПолучитьЭлементы()[КолПодчиненныхСтрок - ОбратныйИндекс];
		СкопироватьСтрокуДерева(РеквизитДерево, НоваяСтрока, ПодчиненнаяСтрока);
	КонецЦикла;
	
	Если Источник.ПолучитьРодителя() = Неопределено Тогда
		РеквизитДерево.ПолучитьЭлементы().Удалить(Источник);
	Иначе
		Источник.ПолучитьРодителя().ПолучитьЭлементы().Удалить(Источник);
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаКлиенте
Процедура ДеревоУпаковокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка=Ложь;
	
	РеквизитДерево = ЭтаФорма["ДеревоУпаковок"];
	
	ИДПриемник = Строка;
	// Если ИДПриемник = Неопределено => Корень дерева
	Приемник = ?(ИДПриемник = Неопределено, Неопределено,
	РеквизитДерево.НайтиПоИдентификатору(ИДПриемник));
	
	МассивИДИсточник = ПараметрыПеретаскивания.Значение;
	
	Для Каждого ИДИсточник Из МассивИДИсточник Цикл
		Источник = РеквизитДерево.НайтиПоИдентификатору(ИДИсточник);
		НоваяСтрока = СкопироватьСтрокуДерева(РеквизитДерево, Приемник, Источник);
		// Производится копирование в корень
		// Для "красоты" развернем вновь созданную ветвь
		Если Приемник = Неопределено и НоваяСтрока<>Неопределено Тогда
			Элементы["ДеревоУпаковок"].Развернуть(НоваяСтрока.ПолучитьИдентификатор(),
			Истина);
		КонецЕсли;
	КонецЦикла;
	
	// Для "красоты" развернем ветвь-родителя
	Если НЕ Приемник = Неопределено Тогда
		Элементы["ДеревоУпаковок"].Развернуть(ИДПриемник, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПравильностьЗаполнения(Отказ)
	
	Для Каждого ТекУровень Из ДеревоУпаковок.ПолучитьЭлементы() Цикл
		
		Индекс = ТекУровень.ПолучитьИдентификатор();
		
		Если Не ЗначениеЗаполнено(ТекУровень.ДанныеУпаковки) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан уровень упаковки.'"),
				,
				,
				,
				Отказ);
				
		КонецЕсли;
		
		Для Каждого ТекУпаковка Из ТекУровень.ПолучитьЭлементы() Цикл
			
			Если Не ЗначениеЗаполнено(ТекУпаковка.ДанныеУпаковки) Тогда

					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана упаковка. Уровень упаковки - '") + ТекУровень.ДанныеУпаковки,
						,
						,
						,
						Отказ);
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ТекУпаковка.ДетальнаяИнформация) Тогда
				
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не указано количество упаковок. Уровень упаковки - %1. Упаковка - %2'"), ТекУровень.ДанныеУпаковки, ТекУпаковка.ДанныеУпаковки),
						,
						,
						,
						Отказ);
				
			КонецЕсли;
			
			Для Каждого ТекМаркировка Из ТекУпаковка.ПолучитьЭлементы() Цикл
				
				Если Не ЗначениеЗаполнено(ТекМаркировка.ДанныеУпаковки) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не указан тип маркировки. Уровень упаковки - %1. Упаковка - %2.'"), ТекУровень.ДанныеУпаковки, ТекУпаковка.ДанныеУпаковки),
						,
						,
						,
						Отказ);
					
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(ТекМаркировка.ДетальнаяИнформация) Тогда
				
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не указана информация по маркировке. Уровень упаковки - %1. Упаковка - %2. Тип маркировки - %3'"), ТекУровень.ДанныеУпаковки, ТекУпаковка.ДанныеУпаковки, ТекМаркировка.ДанныеУпаковки),
						,
						,
						,
						Отказ);
				
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормы()
	
	ТаблицаУпаковок = ПолучитьИзВременногоХранилища(АдресХранения);
	
	Объект.СписокУпаковок.Загрузить(ТаблицаУпаковок);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоУпаковок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписокУпаковок.УровеньУпаковки КАК УровеньУпаковки,
	|	СписокУпаковок.Упаковка КАК Упаковка,
	|	СписокУпаковок.КоличествоУпаковок КАК КоличествоУпаковок,
	|	СписокУпаковок.ТипМаркировки КАК ТипМаркировки,
	|	СписокУпаковок.НаименованиеМаркировки КАК НаименованиеМаркировки
	|ПОМЕСТИТЬ ВТ_СписокУпаковок
	|ИЗ
	|	&СписокУпаковок КАК СписокУпаковок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СписокУпаковок.УровеньУпаковки КАК УровеньУпаковки,
	|	ВТ_СписокУпаковок.Упаковка КАК Упаковка,
	|	ВТ_СписокУпаковок.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВТ_СписокУпаковок.ТипМаркировки КАК ТипМаркировки,
	|	ВТ_СписокУпаковок.НаименованиеМаркировки КАК НаименованиеМаркировки
	|ИЗ
	|	ВТ_СписокУпаковок КАК ВТ_СписокУпаковок
	|
	|УПОРЯДОЧИТЬ ПО
	|	УровеньУпаковки.Код
	|ИТОГИ ПО
	|	УровеньУпаковки,
	|	Упаковка,
	|	КоличествоУпаковок";
	
	Запрос.УстановитьПараметр("СписокУпаковок", Объект.СписокУпаковок.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаУровеньУпаковки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДеревоУпаковок.ПолучитьЭлементы().Очистить();
	Пока ВыборкаУровеньУпаковки.Следующий() Цикл
		
		СтрокаУровеньУпаковки = ДеревоУпаковок.ПолучитьЭлементы().Добавить();
		СтрокаУровеньУпаковки.ДанныеУпаковки = ВыборкаУровеньУпаковки.УровеньУпаковки;
		СтрокаУровеньУпаковки.Уровень        = 0;
		
		ВыборкаУпаковки = ВыборкаУровеньУпаковки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаУпаковки.Следующий() Цикл
			
			ВыборкаКоличество = ВыборкаУпаковки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКоличество.Следующий() Цикл
				
				ВыборкаМаркировка = ВыборкаКоличество.Выбрать();
				
				Если Не ЗначениеЗаполнено(ВыборкаУпаковки.Упаковка) И (ВыборкаМаркировка.Количество() = 0
				          ИЛИ (ВыборкаМаркировка.Количество() = 1 И ВыборкаМаркировка.Следующий() И Не ЗначениеЗаполнено(ВыборкаМаркировка.ТипМаркировки))) Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаУпаковка = СтрокаУровеньУпаковки.ПолучитьЭлементы().Добавить();
				СтрокаУпаковка.ДанныеУпаковки      = ВыборкаУпаковки.Упаковка;
				СтрокаУпаковка.ДетальнаяИнформация = ВыборкаКоличество.КоличествоУпаковок;
				СтрокаУпаковка.Уровень             = 1;
				
				ВыборкаМаркировка.Сбросить();
				
				Пока ВыборкаМаркировка.Следующий() Цикл
					Если Не ЗначениеЗаполнено(ВыборкаМаркировка.ТипМаркировки) Тогда
						Продолжить;
					КонецЕсли;
					СтрокаМаркировка = СтрокаУпаковка.ПолучитьЭлементы().Добавить();
					СтрокаМаркировка.ДанныеУпаковки      = ВыборкаМаркировка.ТипМаркировки;
					СтрокаМаркировка.ДетальнаяИнформация = ВыборкаМаркировка.НаименованиеМаркировки;
					СтрокаМаркировка.Уровень             = 2;
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти