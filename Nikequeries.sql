/*Question #1:If we exclude the discounts that have been given, the expectedprofit margin for each product is calculated by: (retail price -cost) / retail price.Create a column that flags products with a name that includesâ€oeVintageâ€ as products from Nike Vintage and Nike Officialotherwise.Calculate the expected profit margins for each product name andinclude the group that splits products between Nike Official andNike Vintage in the result.*/-- Question #1 Solution:SELECTCASE WHEN products.product_name LIKE 'Vintage%' THEN'Vinatge'ELSE 'Nike Official'END AS Business_unit,products.product_name,(products.retail_priceproducts.cost)/products.retail_price AS profit_marginFROM products;

/*Question #2:What is the profit margin for each distribution center? Arethere any centers that stand out?*/-- Question #2 Solution:SELECTdistribution_centers.name,SUM(products.retail_price-products.cost)/SUM(products.retail_price) AS profit_marginFROM productsINNER JOINdistribution_centersONdistribution_centers.distribution_center_id=products.distribution_center_idGROUP BYdistribution_centers.name;

/*Question #3:The real profit margin per order item is calculated by: (salesprice - cost) / sales price. By summing up all the order items,we will find the real profit margin generated by the products.Calculate the profit margin for the Nike Official products: NikePro Tights, Nike Dri-FIT Shorts, and Nike Legend Tee*/-- Question #3 Solution:SELECTproducts.product_name,SUM(order_items.sale_price-products.cost)/SUM(order_items.sale_price) AS profit_marginFROM order_itemsINNER JOINproductsON order_items.product_id=productS.product_idWHERE products.product_name IN ('Nike Pro Tights', 'Nike Dri-FITShorts', 'Nike Legend Tee')GROUP BYproducts.product_name;

/*Question #4:Calculate the real profit margin by product and split the datausing the created date before 2021-05-01 and post 2021-05-01 forNike Official order items.*/-- Question #4 Solution:SELECTDISTINCT(products.product_name),CASE WHEN order_items.created_at <'2021-05-01' THEN 'PRE-MAY'ELSE 'POST-MAY'END AS may21_split,SUM(order_items.sale_price-products.cost)/SUM(order_items.sale_price) AS profit_marginFROM order_itemsFULL JOINproductsON order_items.product_id=productS.product_idGROUP BYproducts.product_name,may21_splitHAVINGSUM(order_items.sale_price-products.cost)/SUM(order_items.sale_price) IS NOT NULL;

/*Question #5:Calculate the profit margin by product for both Nike Officialand Nike Vintage products in a single view*/-- Question #5 Solution:SELECTproducts.product_name,SUM(order_items_vintage.sale_price-products.cost)/SUM(order_items_vintage.sale_price) AS profit_marginFROM order_items_vintageINNER JOINproductsON order_items_vintage.product_id=products.product_idGROUP BYproducts.product_nameUNION ALLSELECTproducts.product_name,SUM(order_items.sale_price-products.cost)/SUM(order_items.sale_price) AS profit_marginFROM order_itemsINNER JOINproductsON order_items.product_id=products.product_idGROUP BYproducts.product_name;

/*Question #6:What are the top 10 products by profit margin from Nike Officialand Nike Vintage?Include the product name, profit margin, and what business unit(Nike Official or Nike Vintage) sells the product.*/-- Question #6 Solution:SELECT'Nike Vintage' AS Business_Unit,products.product_name,SUM(order_items_vintage.sale_price-products.cost)/SUM(order_items_vintage.sale_price) AS profit_marginFROM order_items_vintageINNER JOINproductsON order_items_vintage.product_id=products.product_idGROUP BYproducts.product_nameUNION ALLSELECT'Nike Official' AS Business_Unit,products.product_name,SUM(order_items.sale_price-products.cost)/SUM(order_items.sale_price) AS profit_marginFROM order_itemsINNER JOINproductsON order_items.product_id=products.product_idGROUP BYproducts.product_nameORDER BY profit_margin DESCLIMIT 10;