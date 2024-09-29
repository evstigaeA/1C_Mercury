﻿
&НаСервере
Функция ПроверкаЗаполненияТранспортом()
	
	тзТранспорт.Очистить();
	
	Для Каждого ТекСтр1 Из Объект.ТаблицаТОДляВторогоТранспорта Цикл
		НовСтр1 = тзТранспорт.Добавить();
		НовСтр1.ИсхТО = ТекСтр1.ТО;
		СтрОтб2 = Новый Структура("ТО",ТекСтр1.ТО);
		мСтр2 = Объект.ТаблицаМаршрутСледования.НайтиСтроки(СтрОтб2);
		Если мСтр2.Количество() > 0 Тогда
			Для м2=0 по мСтр2.Количество()-1 Цикл
				ТекСтр2 = мСтр2.Получить(м2);
				НовСтр2 = НовСтр1.тзВторойТранспорт.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр2,ТекСтр2);
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат Истина;
	
КонецФункции	

&НаКлиенте
Процедура Завершить(Команда)
	
	Если Не ПроверкаЗаполненияТранспортом() Тогда
		ОповеститьОВыборе(Ложь);
	Иначе	
		РезультатВыбора = Новый Структура("тзТранспорт",тзТранспорт);
		ОповеститьОВыборе(РезультатВыбора);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусЗаявки(ДокУВС)
	
	Запр = Новый Запрос;
	Запр.Текст = "ВЫБРАТЬ
	|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус КАК ТекСтатус
	|ИЗ
	|	РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
	|ГДЕ
	|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка = &ДокУВС";
	
	ТекСтатус = Справочники.СтатусыЗаявок.Черновик;
	
	Запр.Параметры.Вставить("ДокУВС",ДокУВС);
	ВыбЗапр = Запр.Выполнить().Выбрать();
	Если ВыбЗапр.Следующий() Тогда
		ТекСтатус = ВыбЗапр.ТекСтатус;
	КонецЕсли;	
	
	Возврат ТекСтатус; 
	
КонецФункции	

&НаСервере
Процедура ОбновитьТЗ(АдресТЗТаблицаМаршрутСледования)
	
	Объект.ТаблицаМаршрутСледования.Загрузить(ПолучитьИзВременногоХранилища(АдресТЗТаблицаМаршрутСледования));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТЗ(ИсхТаблЧасть)
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Объект[ИсхТаблЧасть].Выгрузить());
	Возврат АдресХранилища;
	
КонецФункции	

&НаКлиенте
Процедура ТаблицаТОДляВторогоТранспортаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТОДляВторогоТранспортаПередУдалением(Элемент, Отказ)
	Отказ = Истина;	
КонецПроцедуры

&НаСервере
Функция ПроверитьСтатусыВСД(ИсхТО)
	
	ЗапрПров = Новый Запрос;
	ЗапрПров.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                 |	ТранспортныеОперации.Ссылка КАК Документ
	                 |ИЗ
	                 |	Документ.ТранспортныеОперации КАК ТранспортныеОперации
	                 |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТранспортныеОперации.ТаблицаВСД КАК ТранспортныеОперацииТаблицаВСД
	                 |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыВСД.СрезПоследних КАК СтатусыВСДСрезПоследних
	                 |			ПО ТранспортныеОперацииТаблицаВСД.ВСД = СтатусыВСДСрезПоследних.ВСД
	                 |				И (СтатусыВСДСрезПоследних.СтатусВСД = ЗНАЧЕНИЕ(Справочник.СтатусыВСД.Оформлен))
	                 |		ПО ТранспортныеОперации.Ссылка = ТранспортныеОперацииТаблицаВСД.Ссылка
	                 |ГДЕ
	                 |	ТранспортныеОперации.Ссылка = &ИсхТО";
	
	ЗапрПров.Параметры.Вставить("ИсхТО",ИсхТО);
	ВыбЗапр = ЗапрПров.Выполнить().Выбрать();
	
	Возврат ВыбЗапр.Следующий();
	
	
КонецФункции			


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры) <> Тип("ДанныеФормыСтруктура") Тогда
		Отказ = Истина;
	КонецЕсли;	
		
	Для м=0 по Параметры.МассивОтобранныхДокументов.Количество()-1 Цикл
		ИсхТО = Параметры.МассивОтобранныхДокументов.Получить(м);
		Если ТипЗнч(ИсхТО) <> Тип("ДокументСсылка.ТранспортныеОперации") Тогда
			Продолжить;
		ИначеЕсли ПолучитьСтатусЗаявки(ИсхТО) <> Справочники.СтатусыЗаявок.УспешноОбработана Тогда
			Продолжить;
		ИначеЕсли Не ПроверитьСтатусыВСД(ИсхТО) Тогда
			Продолжить;
		ИначеЕсли ИсхТО.ТаблицаМаршрутСледования.Количество() = 0 Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Исключена для обработки " + ИсхТО + ", поскольку в ней нет записей о мультимодальной перевозке");
			Продолжить;
		КонецЕсли;
		НовСтр = Объект.ТаблицаТОДляВторогоТранспорта.Добавить();
		НовСтр.ТО = ИсхТО;
		Если ИсхТО.ТаблицаМаршрутСледования.Количество() > 0 Тогда
			СтрМС = "";
			Для Каждого ТекСтр из ИсхТО.ТаблицаМаршрутСледования Цикл
				Если Не ПустаяСтрока(СтрМС) Тогда
					СтрМС = СтрМС + "
					|";
				КонецЕсли;	
				СтрМС = СтрМС + "" + ТекСтр.ИнформацияОСледующемТранспорте + " " + ТекСтр.НазваниеПункта;
			КонецЦикла;
			НовСтр.ТаблицаМаршрутСледования = СтрМС;
		КонецЕсли;
	КонецЦикла;	
	
	Если Объект.ТаблицаТОДляВторогоТранспорта.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет в списке отобранных документов подходящих по условиям транспортных операций");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТОДляВторогоТранспортаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТО",Объект.ТаблицаТОДляВторогоТранспорта.Получить(ВыбраннаяСтрока).ТО);
	ПараметрыФормы.Вставить("АдресТЗТаблицаМаршрутСледования",ПолучитьАдресТЗ("ТаблицаМаршрутСледования"));
	ПараметрыФормы.Вставить("ВнесениеВторогоТранспортаБезАннулирования",Истина);
	ОткрытьФорму("Обработка.ДМ_ВнесениеДанныхОТранспорте.Форма.ФормаМаршрутаСледования", ПараметрыФормы, ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ТаблицаТОДляВторогоТранспортаПриАктивизацииСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Обработка.ДМ_ВнесениеДанныхОТранспорте.Форма.ФормаМаршрутаСледования") Тогда
		ТаблицаТОДляВторогоТранспортаПриАктивизацииСтроки();
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		ОбновитьТЗ(ВыбранноеЗначение.АдресТЗТаблицаМаршрутСледования);
		Для Каждого ТекСтр из Объект.ТаблицаТОДляВторогоТранспорта Цикл
			СтрОтб = Новый Структура("ТО",ТекСтр.ТО);
			мСтр = Объект.ТаблицаМаршрутСледования.НайтиСтроки(СтрОтб);
			Если мСтр.Количество() > 0 Тогда
				СтрМС = "";
				Для мм=0 по мСтр.Количество()-1 Цикл
					ТекМ = мСтр.Получить(мм);
					Если Не ПустаяСтрока(СтрМС) Тогда
						СтрМС = СтрМС + "
						|";
					КонецЕсли;	
					СтрМС = СтрМС + "" + ТекМ.ИнформацияОСледующемТранспорте + " " + ТекМ.НазваниеПункта;
				КонецЦикла;
				ТекСтр.ТаблицаМаршрутСледования = СтрМС;
			Иначе
				ТекСтр.ТаблицаМаршрутСледования = "";
			КонецЕсли;	
		КонецЦикла;
		ТаблицаТОДляВторогоТранспортаПриАктивизацииСтроки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьМаршрутСледованияНаСервере(ИсхТО) Экспорт
	
	КвоТО = 0;
	СтрОтб = Новый Структура("ТО",ИсхТО);
	мМС = Объект.ТаблицаМаршрутСледования.НайтиСтроки(СтрОтб);
	Если мМС.Количество() > 0 Тогда
		Для Каждого ТекСтр из Объект.ТаблицаТОДляВторогоТранспорта Цикл
			Если ТекСтр.ТО = ИсхТО Тогда
				Продолжить;
			КонецЕсли;	
			СтрОтб2 = Новый Структура("ТО",ТекСтр.ТО);
			мМС2 = Объект.ТаблицаМаршрутСледования.НайтиСтроки(СтрОтб2);
			Если мМС2.Количество() > 0 Тогда
				Для мм2=0 по мМС2.Количество()-1 Цикл
					Объект.ТаблицаМаршрутСледования.Удалить(мМС2.Получить(мм2));
				КонецЦикла;	
			КонецЕсли;
			СтрМС = "";
			Для мм=0 по мМС.Количество()-1 Цикл
				НовСтр = Объект.ТаблицаМаршрутСледования.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,мМС.Получить(мм));
				НовСтр.ТО = ТекСтр.ТО;
				Если Не ПустаяСтрока(СтрМС) Тогда
					СтрМС = СтрМС + "
					|";
				КонецЕсли;	
				СтрМС = СтрМС + "" + НовСтр.ИнформацияОСледующемТранспорте + " " + НовСтр.НазваниеПункта;
			КонецЦикла;
			ТекСтр.ТаблицаМаршрутСледования = СтрМС;
			КвоТО = КвоТО + 1;
		КонецЦикла;	
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для " + КвоТО + " транспортных операций скопирован маршрут следования из строки с док-м " + ИсхТО);
	
КонецПроцедуры	

&НаКлиенте
Процедура СкопироватьМаршрутСледованияПослеОтвет(Знач Результат,ИсхТО) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		 СкопироватьМаршрутСледованияНаСервере(ИсхТО);
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура СкопироватьМаршрутСледования(Команда)
	
	Обработчик = Новый ОписаниеОповещения("СкопироватьМаршрутСледованияПослеОтвет", ЭтотОбъект,Элементы.ТаблицаТОДляВторогоТранспорта.ТекущиеДанные.ТО);
	ТекстВопроса = НСтр("ru = 'Скопировать маршрут следования из текущей строки с док-м " + Элементы.ТаблицаТОДляВторогоТранспорта.ТекущиеДанные.ТО + " для всех остальных строк ?'");
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТОДляВторогоТранспортаПриАктивизацииСтроки()
	
	Элементы.ТаблицаТОДляВторогоТранспортаСкопироватьМаршрутСледования.Доступность = Не ПустаяСтрока(Элементы.ТаблицаТОДляВторогоТранспорта.ТекущиеДанные.ТаблицаМаршрутСледования);
	
КонецПроцедуры

