﻿
Процедура СозданиеСвязанныхОбъектов(МассивСсылок, ПараметрыВыполнения) Экспорт

	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	ПараметрыВыполненияКоманды.Источник = ПараметрыВыполнения.Форма;
	
	ДополнительныеОтчетыИОбработкиКлиент.ОткрытьФормуКомандДополнительныхОтчетовИОбработок(
		МассивСсылок,
		ПараметрыВыполненияКоманды,
		ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиСозданиеСвязанныхОбъектов());

КонецПроцедуры

Процедура СозданиеНаОснованииУполномоченноеГашениеСводно(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если Не ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ИмяФормы = "Документ.ПриходныеОперацииСводно.Форма.ФормаДокумента";
	
	ПараметрыОснования = Новый Структура;
	
	ПараметрыОснования.Вставить("ДокументОснование"    , ПараметрКоманды);
	ПараметрыОснования.Вставить("УполномоченноеГашение", Истина);
	
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", ПараметрыОснования));
	
КонецПроцедуры

Процедура СозданиеНаОснованииУполномоченноеГашение(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры);
	
	Если Не ПараметрыВыполнения.ОписаниеКоманды.МножественныйВыбор Тогда
		ПараметрКоманды = МассивСсылок;
	Иначе
		ПараметрКоманды = МассивСсылок[0];
	КонецЕсли;
	
	ИмяФормы = "Документ.ПриходныеОперации.Форма.ФормаДокумента";
	
	ПараметрыОснования = Новый Структура;
	
	ПараметрыОснования.Вставить("ДокументОснование"    , ПараметрКоманды);
	ПараметрыОснования.Вставить("УполномоченноеГашение", Истина);
	
	ОткрытьФорму(ИмяФормы, Новый Структура("Основание", ПараметрыОснования));
	
КонецПроцедуры
