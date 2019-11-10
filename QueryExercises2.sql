use Northwind
--1.	Tedarik�isinin posta kodu '33007' olan deniz �r�nleri 'Seafood' hari� sipari�ler ile ilgilenmi� �al��anlar�m�n ad, soyad, ev telefonu alanlar�n� getir

select distinct
	e.FirstName,
	e.LastName,
	e.HomePhone 
from Suppliers sup
	inner join Products p on sup.SupplierID=p.SupplierID
	inner join Categories cat on p.CategoryID = cat.CategoryID
	inner join [Order Details] od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID=o.OrderID
	inner join Employees e on o.EmployeeID=e.EmployeeID
where sup.PostalCode='33007' and 
	cat.CategoryName!='Seafood'

--2.	Region'u 'SP' olan m��terilerimin, Federal Shipping ile ta��nan �r�nlerini kategorilerine g�re s�ralanm�� halini listeleyiniz.

select distinct
 co.CategoryName, p.ProductName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join Shippers shp on shp.ShipperID=o.ShipVia
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on p.ProductID= od.ProductID
	join Categories co on p.CategoryID=co.CategoryID
where c.Region='SP' and
	shp.CompanyName='Federal Shipping'
order by co.CategoryName asc

--3.	Tedarik �ehri Londra olan, kargo �irketinin 4. harfi e olan sto�umda bulunan sipari�lerim nelerdir?

select
o.OrderID
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on p.ProductID=od.ProductID
	join Suppliers sup on sup.SupplierID=p.SupplierID
	join Shippers shp on shp.ShipperID=o.ShipVia
where
	sup.City='London' and
	shp.CompanyName like '___e%'and
	p.UnitsInStock>0
	
--4.	Sto�umdaki miktar 0-20 aras�nda ise %20 zam 20-40 aras�nda ise ayn� fiyat 40-90 aras�nda ise y�zde 10 indirim 90 �zerinde ise y�zde 40 indirim yaps�n

select ProductName, UnitPrice,
	(
	case 
	when (UnitsInStock between 0 and 20) then (UnitPrice*1.2)
	when (UnitsInStock between 40 and 90) then (UnitPrice*0.9)
	when (UnitsInStock>90) then (UnitPrice*0.6)
	else UnitPrice
	end
	) Fiyat
from Products

--5.	Stokta bulunan indirimsiz �r�nleri adetleriyle birlikte listeleyiniz.

select distinct
p.ProductID , p.UnitsInStock , od.Discount
from Products p
	join [Order Details] od on od.ProductID=p.ProductID
where p.UnitsInStock>0 and
	od.Discount=0
order by p.ProductID

--6.	�ehri Tacoma olan �al��anlar�m�n ald��� sipari�lerin listesi?

select
o.OrderID
from Orders o
	join Employees e on e.EmployeeID=o.EmployeeID
where e.City='Tacoma'
order by o.OrderID

--7.	Sto�u 20den fazla olan sipari�lerimin hangi kargo �irketleriyle teslim edildi�ini listeleyiniz

select distinct
o.OrderID , shp.CompanyName
from Orders o
	join [Order Details] od on od.OrderID=o.OrderID
	join Products p on p.ProductID=od.ProductID
	join Shippers shp on shp.ShipperID=o.ShipVia
where p.UnitsInStock>20
order by o.OrderID

--8.	Stokta 40tan fazla olan �r�nlerimin adlar� ve kategori isimleri?

select 
p.ProductName, c.CategoryName
from Products p
	left join Categories c on p.CategoryID = c.CategoryID
where p.UnitsInStock>40

--9.	Stokta olmayan �r�nlerimin ve devaml�l��� olmayanlar�n tedarik�ilerinin telefon numaralar�n� listeleyiniz

select
p.ProductID, sup.Phone
from Products p
	join Suppliers sup on sup.SupplierID=p.SupplierID
where p.UnitsInStock=0 and
	p.Discontinued=1

--10.   Ta��nan sipari�lerin hangi kargo firmas� ile ta��nd���n� kargo firmas�n�n ismi ile belirtiniz.

select
o.OrderID , shp.CompanyName
from Orders o
	join Shippers shp on shp.ShipperID=o.ShipVia
where o.ShippedDate is not null

--11.   Hi� sat�� yap�lmam�� m��terilerin isimlerini ve telefonlar�n� listeleyiniz.

select
	c.CompanyName,c.Phone
from Customers c
	left join Orders o on c.CustomerID=o.CustomerID
where o.CustomerID is null
	
--12.   �ndirimli g�nderdi�im sipari�lerdeki �r�n adlar�n�, birim fiyat�n� ve indirim tutar�n� g�sterin

select
	p.ProductName , p.UnitPrice , od.Discount
from [Order Details] od
	join Products p on od.ProductID=p.ProductID
where od.Discount!=0 

--13.   Amerikali toptancilardan alinmis olan urunleri gosteriniz...

select
	p.ProductName
from Products p 
	join Suppliers sup on p.SupplierID=sup.SupplierID
where sup.Country = 'USA'
order by p.ProductName

--14.   Speedy Express ile tasinmis olan siparisleri gosteriniz...

select
	o.OrderID
from Orders o
	join Shippers s on o.ShipVia=s.ShipperID
where s.CompanyName='Speedy Express'

--15.   Federal Shipping ile tasinmis ve Nancy'nin almis oldugu siparisleri gosteriniz...

select
	*
from Orders o
	join Shippers s on o.ShipVia=s.ShipperID
	join Employees e on o.EmployeeID= e.EmployeeID
where s.CompanyName='Federal Shipping' and
	e.FirstName like '%Nancy%'
	
--16.   Web sayfas� olan tedarik�ilerimden hangi �r�nleri tedarik ediyorum?

select
	p.ProductName
from Products p
	join Suppliers s on p.SupplierID=s.SupplierID
where s.HomePage is not null
order by p.ProductName

--17.   Hangi �al��an�m hangi �al��an�ma rapor veriyor? 

select 
	calisan.FirstName Calisan, 
	mudur.FirstName Mudur 
from Employees calisan
	left join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--18.   Do�u konumundaki b�lgeleri listeleyin

select
	t.TerritoryID , t.TerritoryDescription
from Territories t
	join Region r on t.RegionID=r.RegionID
where r.RegionDescription like '%East%'

--20.   Konumu 'Eastern' olan m��terilerimin, federal shipping ile ta��nan �r�nlerini
--kategorilere g�re s�ralay�n�z.

select distinct
	 c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
from Products p
	join [Order Details] od on p.ProductID=od.ProductID
	join Orders o on od.OrderID=o.OrderID
	join Shippers sh on o.ShipVia=sh.ShipperID
	join Employees e on o.EmployeeID=e.EmployeeID
	join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
	join Territories t on et.TerritoryID=t.TerritoryID
	join Region r on t.RegionID=r.RegionID
	join Categories c on p.CategoryID=c.CategoryID
where sh.CompanyName='Federal shipping' and
	r.RegionDescription='Eastern'
order by c.CategoryID
	
--21.   Tedarik �ehri londra olan, kargo �irketinin  4. harfi e olan sto�umda bulunan ve birim fiyat� 10 - 30 aras�nda olan sipari�lerim nelerdir? 

select
	o.OrderID 
from Orders o
	inner join Shippers sp on o.ShipVia=sp.ShipperID
	inner join [Order Details] od on od.OrderID=o.OrderID
	inner join Products p on p.ProductID = od.ProductID
	inner join Suppliers su on su.SupplierID=p.SupplierID
where su.City='London' and
	sp.CompanyName like '___e%' and
	p.UnitsInStock>0 and
	p.UnitPrice between 10 and 30

--22.   �ehri tacoma olan �al��anlar�m�n ald��� sipari�lerin listesi?

select
	o.OrderID
from Orders o
	join Employees e on o.EmployeeID=e.EmployeeID
where e.City like '%Tacoma%'

--23.   Sat��� durdurulmu� ve ayn� zamanda sto�u kalmam�� �r�nlerimin tedarik�ilerinin isimlerini ve telefon numaralar�n� listeleyiniz.

select 
	s.CompanyName, s.Phone, p.ProductName
from Suppliers s
	join Products p on s.SupplierID=p.SupplierID
where p.Discontinued=1 and
	p.UnitsInStock=0

--24.   New York �ehrinden sorumlu �al��an(lar)�m kim?

select distinct
	e.FirstName+' '+e.LastName Employee
from Employees e
	join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
	join Territories t on et.TerritoryID = t.TerritoryID
where t.TerritoryDescription= 'New York'

--25.   1 Ocak 1998 tarihinden sonra sipari� veren m��terilerimin isimlerini artan olarak s�ralay�n�z.

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
where o.OrderDate>'1998-01-01'
order by c.CompanyName asc

--26.	CHAI �r�n�n� hangi m��terilere satm���m?

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
where p.ProductName like 'chai'

--27.	10248 ID'li sipari�imle hangi �al��an�m ilgilenmi�tir?

select
	e.FirstName+' '+e.LastName
from Employees e
	join Orders o on e.EmployeeID=o.EmployeeID
where o.OrderID=10248

--28.   �i�ede sat�lan �r�nlerimi sipari� ile g�nderdi�im �lkeler hangileridir?

select distinct
	o.ShipCountry
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
where p.QuantityPerUnit like '%bottle%' 


--29.	A�ustos ay�nda teslim edilen sipari�lerimdeki �r�nlerden kategorisi i�ecekler olanlar�n,
--�r�n isimlerini, teslim tarihini ve hangi �ehre teslim edildi�ini kargo �cretine g�re ters s�ral� �ekilde listeleyiniz.

select
	p.ProductName, o.ShippedDate, o.ShipCity
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories c on p.CategoryID=c.CategoryID
where c.CategoryName='Beverages' and
	format(o.ShippedDate,'MMMM')='august'
order by o.Freight desc

--30.	Speedy Express ile ta��nan tedarik�ilerimden pazarlama m�d�rleriyle ileti�ime ge�ti�im,
--Steven Buchanan adl� �al��an�ma rapor veren �al��anlar�m�n ilgilendi�i,
--Amerika'ya g�nderdi�im sipari�lerimin �r�nlerinin kategorileri nelerdir?

select 
		cat.CategoryName
from Employees Calisan
	inner join Employees Mudur on calisan.ReportsTo=Mudur.EmployeeID
	join Orders o on o.EmployeeID=Calisan.EmployeeID
	join Shippers s on s.ShipperID=o.ShipVia
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on p.ProductID=od.ProductID
	join Suppliers su on su.SupplierID=p.SupplierID
	join Categories cat on p.CategoryID=cat.CategoryID
where 
	mudur.FirstName='Steven' and
	mudur.LastName='Buchanan' and
	s.CompanyName='Speedy Express' and
	su.ContactTitle='Marketing Manager' and
	o.ShipCountry='USA'
	

--31.	Meksikal� m��terilerimden �irket sahibi ile ileti�ime ge�ti�im,
--kargo �creti 30 dolar�n alt�nda olan sipari�lerle hangi �al��anlar�m ilgilenmi�tir?

select distinct
	e.EmployeeID, e.FirstName+' '+e.LastName
from Orders o
	join Customers c on o.CustomerID=c.CustomerID
	join Employees e on o.EmployeeID=e.EmployeeID
where c.Country='Mexico' and
	c.ContactTitle='Owner' and
	o.Freight<30
order by e.EmployeeID

--32.	Seafood �r�nlerinden sipari� g�nderdi�im m��terilerim kimlerdir?

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories cat on p.CategoryID=cat.CategoryID
where cat.CategoryName='SeaFood'

--33.	Doktora yapmam�� kad�n �al��anlar�m�n ilgilendi�i sipari�lerin,
--g�nderildi�i m��terilerimden ileti�ime ge�ti�im ki�ilerin isimleri ve �ehirleri nelerdir?

select distinct
c.ContactName,c.City 
from Employees e
	join Orders o on e.EmployeeID=o.EmployeeID
	join Customers c on c.CustomerID=o.CustomerID
where e.TitleOfCourtesy in ('Ms.','Mrs.') and
	e.TitleOfCourtesy!='Dr.'
	
--------------Union - Union All
--34.	Hangi �irketlerle �al���yorum => hem suppliers hem customers hem de shippers

select s.CompanyName from Suppliers s
union
select c.CompanyName from Customers c
union
select sh.CompanyName from Shippers sh

--35.	Hangi insanlarla �al���yorum => hem customers hem suppliers hem Employees

select c.ContactName from Customers c
union
select e.FirstName+' '+e.LastName from Employees e

--------------Case-When
--36.	i�ecekler kategorisinden sipari� veren m��terilerimin �r�n ad� �irket isimlerini 
--tedarik�i �irket ismini kargo �cretini ve e�er kargo �creti 20 den az ise 'ucuz',
--20-40 aral���nda ise 'orta', 40 dan b�y�k ise 'pahal�' yazacak �ekilde listeleyiniz. 
--(kolon isimleri m��teri �irketi, �r�n ad�, tedarik�inin �irketi, kargo �creti, �cret de�erlendirmesi)	

select
	c.CompanyName [M��teri �irketi],
	p.ProductName [�r�n Ad�],
	sup.CompanyName [Tedarik�inin �irketi],
	o.Freight [Kargo �creti],
	(
	case 
	when (o.Freight <= 20) then 'Ucuz'
	when (o.Freight between 20 and 40) then 'Orta'
	when (o.Freight>40) then 'Pahal�'
	end
	) [�cret De�erlendirmesi]
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories cat on p.CategoryID=cat.CategoryID
	join Suppliers sup on p.SupplierID=sup.SupplierID
where cat.CategoryName='Beverages'
order by c.CompanyName