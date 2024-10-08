﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ВариантВеденияЖурнала.Доступность = Запись.ВидОбъекта.ПолноеИмя <> "РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций";
	Элементы.СрокХраненияДанных.Доступность    = Запись.ВариантОчисткиДанныхЖурнала <> Перечисления.ВариантыОчисткиЖурналовЗагрузкиДанных.НеОчищать;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОчисткиДанныхЖурналаПриИзменении(Элемент)
	
	Если Запись.ВариантОчисткиДанныхЖурнала = ПредопределенноеЗначение("Перечисление.ВариантыОчисткиЖурналовЗагрузкиДанных.НеОчищать") Тогда
		Запись.СрокХраненияДанных = 0;
	КонецЕсли;
	
	Элементы.СрокХраненияДанных.Доступность = Запись.ВариантОчисткиДанныхЖурнала <> ПредопределенноеЗначение("Перечисление.ВариантыОчисткиЖурналовЗагрузкиДанных.НеОчищать");
	
КонецПроцедуры

#КонецОбласти
