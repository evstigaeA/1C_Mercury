﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", ПараметрКоманды);
	
	ОткрытьФорму("Справочник.АдминистрированиеПользователейПрисоединенныеФайлы.Форма.ФормаПротоколаОбмена", ПараметрыФормы);
	
КонецПроцедуры
