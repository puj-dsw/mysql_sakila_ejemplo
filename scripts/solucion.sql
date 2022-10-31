    WITH sales_2005 AS (
            SELECT
                    CONCAT(city, ',', country) AS store,
                    CONCAT(staff.first_name,' ', staff.last_name) AS manager,
                    YEAR(payment_date) as year,
                    MONTH(payment_date) as month,
                    SUM(amount) as amount
                FROM country
                    INNER JOIN city USING(country_id)
                    INNER JOIN address USING(city_id)
                    INNER JOIN store USING(address_id)
                    INNER JOIN staff USING(store_id)
                    INNER JOIN payment USING(staff_id)
                    INNER JOIN customer USING(customer_id)
                GROUP BY store, manager, year, month
                HAVING year=2005
        ),
        pivote AS (
            SELECT 
                store,
                manager,
                SUM( 
                    CASE WHEN month=5 THEN amount ELSE 0 END
                ) as may,
                SUM(
                    CASE WHEN month=6 THEN amount ELSE 0 END
                ) as june,
                SUM(
                    CASE WHEN month=7 THEN amount ELSE 0 END
                ) as july,
                SUM(
                    CASE WHEN month=8 THEN amount ELSE 0 END
                ) as aug
            FROM sales_2005
            GROUP BY store, manager
        )
    SELECT 
        store,
        manager,
        may,
        july
        june,
        (june - may) AS diff_may,
        ((june - may)/may) as perc_may,
        (july - june) AS diff_july,
        ((july - june)/june) as perc_july,
        (aug - july) AS diff_aug,
        ((aug - july)/july) as perc_aug
    FROM pivote
    ;
