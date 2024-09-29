﻿#Область ОбработкаТабличнойЧасти

Процедура ОбработатьСтрокуПродукции(Объект, СтрокаТабличнойЧасти, ДанныеЗаполнения, ЗначенияПоУмолчанию, ТаблицаУпаковок, ТабЧастьУпаковок) Экспорт
	
	СвойстваПродукции = ОбщегоНазначенияУВССервер.ПолучитьСвойстваПродукции(ДанныеЗаполнения.Продукция);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СвойстваПродукции);
	
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполнения);//Данные подбора
	
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияПоУмолчанию);//Значения по умолчанию
	
	СтрокаТабличнойЧасти.ТипПродукцииЖивыеЖивотные = ИнтеграцияВетисAPIВызовСервера.ПродукцияПринадлежитТипуЖивыхЖивотных(СтрокаТабличнойЧасти.Продукция);
	
	ИнтеграцияВетисAPIСервер.УстановитьСвойстваПродукции(СтрокаТабличнойЧасти, СтрокаТабличнойЧасти.ТипПродукцииЖивыеЖивотные);
	
	МассивУпаковок = ТаблицаУпаковок.НайтиСтроки(Новый Структура("GUIDСтроки", ДанныеЗаполнения.GUIDСтроки));
	
	Если МассивУпаковок.Количество() > 0 Тогда
		
		Для Каждого ТекУпаковка Из МассивУпаковок Цикл
			
			СтрокаУпаковки = Объект[ТабЧастьУпаковок].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУпаковки, ТекУпаковка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	СтрокаТабличнойЧасти.ПредставлениеДатыВыработки = ИнтеграцияВетисAPIКлиентСервер.СформироватьПредставлениеДатыВыработки(СтрокаТабличнойЧасти);
	СтрокаТабличнойЧасти.ПредставлениеСрокаГодности = ИнтеграцияВетисAPIКлиентСервер.СформироватьПредставлениеСрокаГодности(СтрокаТабличнойЧасти);
	
КонецПроцедуры

Процедура ОбработатьИзменениеПродукции(СтрокаТабличнойЧасти) Экспорт
	
	СвойстваПродукции = ОбщегоНазначенияУВССервер.ПолучитьСвойстваПродукции(СтрокаТабличнойЧасти.Продукция);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СвойстваПродукции);
	
	СтрокаТабличнойЧасти.ТипПродукцииЖивыеЖивотные = ИнтеграцияВетисAPIВызовСервера.ПродукцияПринадлежитТипуЖивыхЖивотных(СтрокаТабличнойЧасти.Продукция);
	
	ИнтеграцияВетисAPIСервер.УстановитьСвойстваПродукции(СтрокаТабличнойЧасти, СтрокаТабличнойЧасти.ТипПродукцииЖивыеЖивотные);
	
	СтрокаТабличнойЧасти.ПредставлениеДатыВыработки = ИнтеграцияВетисAPIКлиентСервер.СформироватьПредставлениеДатыВыработки(СтрокаТабличнойЧасти);
	СтрокаТабличнойЧасти.ПредставлениеСрокаГодности = ИнтеграцияВетисAPIКлиентСервер.СформироватьПредставлениеСрокаГодности(СтрокаТабличнойЧасти);
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

Процедура УстановитьУсловноеОформлениеСкоропортящейсяПродукции(ЭтаФорма, ИмяТабличнойЧасти) Экспорт
	
	Объект = "Объект." + ИмяТабличнойЧасти;
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить(ИмяТабличнойЧасти + "СкоропортящаясяПродукция");
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Истина, МассивПолей, "ОтметкаНезаполненного", Ложь);
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Истина, МассивПолей, "ТолькоПросмотр", Истина);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеВетЭкспертизы(ЭтаФорма, ИмяТабличнойЧасти) Экспорт
	
	Объект = "Объект." + ИмяТабличнойЧасти;
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить(ИмяТабличнойЧасти + "СкоропортящаясяПродукция");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "ОсуществленКонтрольВрачом");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "ПроводиласьВетсанэкспертиза");
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Истина, МассивПолей, "ОтметкаНезаполненного", Ложь);
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Истина, МассивПолей, "ТолькоПросмотр", Истина);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеПоТипуПродукции(ЭтаФорма, ИмяТабличнойЧасти) Экспорт
	
	Объект = "Объект." + ИмяТабличнойЧасти;
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить(ИмяТабличнойЧасти + "ПериодНахожденияЖивотныхНаТерриторииТС");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "МестоПроведенияКарантинирования");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "ДатаКарантинирования");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "СрокДействияКарантина");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "ДополнительныеСведенияОКарантинировании");
	МассивПолей.Добавить(ИмяТабличнойЧасти + "КоличествоМесяцевНахожденияЖивотныхНаТерриторииТС");
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Ложь, МассивПолей, "ОтметкаНезаполненного", Ложь);
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ТипПродукцииЖивыеЖивотные", ВидСравненияКомпоновкиДанных.Равно, Ложь, МассивПолей, "ТолькоПросмотр", Истина);
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить(ИмяТабличнойЧасти + "КоличествоМесяцевНахожденияЖивотныхНаТерриторииТС");
	ДобавитьЭлементОформления(ЭтаФорма, Объект + ".ПериодНахожденияЖивотныхНаТерриторииТС", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.ПериодыНахожденияЖивотныхНаТерритории.НаходилисьНаТерриторииТСУказаннойКоличествоМесяцев, МассивПолей, "ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеМаршрутаСледования(Форма) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы.ТаблицаМаршрутСледованияИнформацияОСледующемТранспорте.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаМаршрутСледования.ОсуществляетсяПерегрузка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

Процедура ДобавитьЭлементОформления(ЭтаФорма, РеквизитТабЧасти, ВидСравнения, ЗначениеДляСравнения, МассивПолей, ИмяПараметра, ЗначениеПараметра)
	
	ЭлементОформления = ЭтаФорма.УсловноеОформление.Элементы.Добавить();

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(РеквизитТабЧасти);
	ЭлементОтбора.ВидСравнения   = ВидСравнения;
	ЭлементОтбора.ПравоеЗначение = ЗначениеДляСравнения;
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
	Для Каждого ТекПоле Из МассивПолей Цикл
		ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(ТекПоле);
		ПолеОформления.Использование = Истина;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти