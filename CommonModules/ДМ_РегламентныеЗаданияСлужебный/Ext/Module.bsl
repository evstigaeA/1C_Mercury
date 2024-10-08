﻿
Процедура ЗагрузкаПринтеров( пИмяФайла, пИмяФайлаПротоколаЗагрузки = Неопределено ) Экспорт
	
	лОбработка = Обработки.ДМ_ЗагрузкаПринтеров.Создать();
	лОбработка.ИмяФайла = пИмяФайла;
	Если пИмяФайлаПротоколаЗагрузки = Неопределено Тогда
		лОбработка.ИмяФайлаПротоколаЗагрузки = "";
	Иначе
		лОбработка.ИмяФайлаПротоколаЗагрузки = пИмяФайлаПротоколаЗагрузки;
	КонецЕсли;
	Если Не лОбработка.ПроверитьЗаполнение() Тогда
		ВызватьИсключение("ru = 'Не заданы параметры регламентного задания для выполнения загрузки'");
	КонецЕсли;
	лОбработка.ЗагрузитьДанныеРегламентнымЗаданием();
	
КонецПроцедуры

Процедура ДМ_ПроверкаНаличияИнтернетПодключения() Экспорт
	
	УстановитьПривилегированныйРежим( Истина );
	
	КолвоПопыток = 3;
	лПауза = 10;//секунд
	лАпи = 0;
	лИнтернет = 0;
	лРезультатОбработки = "";
	Для Н = 1 По КолвоПопыток Цикл
		лОбработка = Обработки.ДМ_ПроверкаНаличияИнтернетПодключения.Создать();
		лОбработка.ВыполнитьПроверку();
		лАпи = лАпи+лОбработка.АпиНеДоступен;
		лИнтернет = лИнтернет+лОбработка.НетПодключенияИнтернет;
		лРезультатОбработки = лРезультатОбработки+ТекущаяДата()+": Попытка №"+Н+Символы.ПС+лОбработка.РезультатОбработки+Символы.ПС;
		лОбработка = Неопределено;
		ДМ_ОбщегоНазначенияКлиентСервер.Пауза(лПауза);
	КонецЦикла;
	
	Если лАпи = КолвоПопыток Тогда
		ДМ_СлужебныйПривилегированный.ЗарегистрироватьОшибкуВыполненияРегЗадания( "ДМ_ПроверкаНаличияИнтернетПодключения", лРезультатОбработки);
		ВызватьИсключение лРезультатОбработки;
	Иначе
		Если лАпи > 0 Или лИнтернет > 0 Тогда
			ДМ_СлужебныйПривилегированный.УстановитьКодСостоянияПоказателя( "ДМ_ПроверкаНаличияИнтернетПодключения", 2, лРезультатОбработки );
		Иначе
			ДМ_СлужебныйПривилегированный.УстановитьКодСостоянияПоказателя( "ДМ_ПроверкаНаличияИнтернетПодключения", 1, лРезультатОбработки );
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим( Ложь );
	
КонецПроцедуры

Процедура ДМ_ПроверкаБлокировкиПользователейМеркурий() Экспорт
	
	лОбработка = Обработки.ДМ_ПроверкаБлокировкиПользователейМеркурий.Создать();
	лОбработка.ПроверитьБлокировку();
	
	Если лОбработка.НеобходимоОтправитьПисьмо Тогда
		лСтруктура = Новый Структура;
		лСтруктура.Вставить("Тема"," СРОЧНО! Блокировка учетных записей 1С-Меркурий!");
		лСтруктура.Вставить("Текст","Добрый день.
		|Все учетные записи для обмена 1С <-> Меркурий заблокированы. Обмен между системами невозможен!");
		лОтветственные = Справочники.ДМ_ГруппыОтветственных.УведомленияОПроблемахСРегзаданиями.ПолучитьОбъект().Пользователи;
		Для Каждого лСтрока Из лОтветственные Цикл
			лСтруктура.Вставить("Получатель",лСтрока.ЭлПочта);
			ДМ_СлужебныйПривилегированный.ОтправитьУведомлениеНаEmail(лСтруктура);
		КонецЦикла;
		ДМ_СлужебныйПривилегированный.УстановитьКодСостоянияПоказателя( "ДМ_ПроверкаБлокировкиПользователейМеркурий", 2, лОбработка.Результат );
	ИначеЕсли лОбработка.Предупреждение Тогда
		ДМ_СлужебныйПривилегированный.УстановитьКодСостоянияПоказателя( "ДМ_ПроверкаБлокировкиПользователейМеркурий", 2, лОбработка.Результат );
	Иначе
		ДМ_СлужебныйПривилегированный.УстановитьКодСостоянияПоказателя( "ДМ_ПроверкаБлокировкиПользователейМеркурий", 1, лОбработка.Результат );
	КонецЕсли;
	
КонецПроцедуры



#Область СлужебныйПрограммныйИнтерфейс


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
