--Q1. Afficher dans l'ordre alphabétique et sur une seule colonne les noms et prénoms des employés qui ont des enfants, présenter d'abord ceux qui en ont le plus.--

SELECT concat (emp_lastname, '',emp_firstname), emp_children FROM employees ORDER BY emp_children DESC,emp_lastname 

--Q2. Y-a-t-il des clients étrangers ? Afficher leur nom, prénom et pays de résidence.--

SELECT `cus_lastname`, `cus_firstname`, `cus_countries_id` FROM `customers`  where cus_countries_id !="FR"

--Q3. Afficher par ordre alphabétique les villes de résidence des clients ainsi que le code (ou le nom) du pays.--

SELECT 'cus_city','cus_countries_id', cou_name FROM customers JOIN countries ON cou_id = cus_countries_id order by cus_city 

--Q4. Afficher le nom des clients dont les fiches ont été modifiées--

SELECT cus_lastname, cus_update_date FROM customers WHERE cus_update_date

--Q5. La commerciale Coco Merce veut consulter la fiche d'un client, mais la seule chose dont elle se souvienne est qu'il habite une ville genre 'divos'. Pouvez-vous l'aider ?--

SELECT * FROM customers WHERE cus_city LIKE '%divos%' 

--Q6. Quel est le produit vendu le moins cher ? Afficher le prix, l'id et le nom du produit.--

SELECT pro_id, pro_name, pro_price FROM products ORDER BY 1 DESC, pro_price DESC LIMIT 1

--Q7. Lister les produits qui n'ont jamais été vendus--

SELECT `pro_id`, `pro_ref`, `pro_name` 
FROM `products` 
WHERE NOT EXISTS 
    (SELECT ode_pro_id 
    FROM `orders_details`
    WHERE ode_pro_id = pro_id)

--Q8. Afficher les produits commandés par Madame Pikatchien.--

SELECT pro_id,pro_ref,pro_name,cus_id,ord_id,ode_id
FROM customers
JOIN orders 
ON ord_cus_id = cus_id 
JOIN orders_details
ON ode_ord_id = ord_id
JOIN products
ON pro_id = ode_pro_id
WHERE cus_lastname = "Pikatchien"

--Q9. Afficher le catalogue des produits par catégorie, le nom des produits et de la catégorie doivent être affichés.--

SELECT cat_id,cat_name,pro_name
FROM products
JOIN categories
ON cat_id = pro_cat_id

--Q10. Afficher l'organigramme hiérarchique (nom et prénom et poste des employés) du magasin de Compiègne, classer par ordre alphabétique. Afficher le nom et prénom des employés, éventuellement le poste (si vous y parvenez).--
SELECT CONCAT( employees.emp_lastname, ' ', employees.emp_firstname ) AS `Employé`, 
CONCAT( employees_responsable.emp_lastname, ' ', employees_responsable.emp_firstname ) AS `Supérieur` 
FROM employees 
LEFT JOIN employees employees_responsable 
ON employees_responsable.emp_id = employees.emp_superior_id 
where employees_responsable.`emp_sho_id` =3 
group by employees.emp_lastname 
ORDER BY employees.emp_lastname ASC

--Fonctions d'agrégation--
--Q11. Quel produit a été vendu avec la remise la plus élevée ? Afficher le montant de la remise, le numéro et le nom du produit, le numéro de commande et de ligne de commande.--
SELECT ode_pro_id, ode_ord_id, ode_id, cat_name, pro_name  
FROM orders_details  
JOIN products 
on pro_id = ode_pro_id 
JOIN categories 
on cat_id = pro_cat_id 
order by ode_discount desc limit 1

--Q13. Combien y-a-t-il de clients canadiens ? Afficher dans une colonne intitulée 'Nb clients Canada'--
SELECT COUNT(*) FROM customers WHERE cus_countries_id = 'CA' 

--Q14. Afficher le détail des commandes de 2020.
SELECT ode_id, ode_unit_price, ode_discount, ode_quantity, ode_ord_id, ode_pro_id, ord_order_date 
FROM orders 
JOIN orders_details 
on ord_id=ode_ord_id 
where ord_order_date 
like "%2020%"

--Q15. Afficher les coordonnées des fournisseurs pour lesquels des commandes ont été passées.--
SELECT sup_address, sup_zipcode, sup_contact, sup_phone, sup_mail
FROM suppliers
JOIN products
ON pro_sup_id = sup_id 
GROUP BY pro_sup_id

--Q16. Quel est le chiffre d'affaires de 2020 ?--
SELECT sum(total) 
FROM ( SELECT ( sum(ode_unit_price - ode_unit_price / 100 * ode_discount ) * ode_quantity) AS total 
FROM orders 
JOIN orders_details 
ON ord_id = ode_ord_id 
where `ord_order_date` 
like '%2020%' 
group by `ord_id` ) as total

--Q17. Quel est le panier moyen ?
SELECT AVG(ode_unit_price) FROM orders_details 

--Q18. Lister le total de chaque commande par total décroissant (Afficher numéro de commande, date, total et nom du client).--

SELECT
    ord_id,
    cus_lastname,
    ord_order_date, CAST(SUM(
        ode_unit_price - ode_unit_price / 100 * ode_discount
    ) * ode_quantity AS DECIMAL(7,2)) AS Total
FROM
    orders
JOIN orders_details ON ode_ord_id = ord_id
JOIN customers ON cus_id = ord_cus_id GROUP BY
    `ord_id`
ORDER BY
    Total DESC 

--Q19. La version 2020 du produit barb004 s'appelle désormais Camper et, bonne nouvelle, son prix subit une baisse de 10%.--
UPDATE products
SET pro_price=pro_price / 100 * 10,
pro_name = 'Camper'
where pro_id = 12

--Q20. L'inflation en France en 2019 a été de 1,1%, appliquer cette augmentation à la gamme de parasols.--

UPDATE products 
SET  pro_price =pro_price + 1.1
where pro_id = 25 
OR pro_id = 26
OR pro_id = 27

--Q21. Supprimer les produits non vendus de la catégorie "Tondeuses électriques". Vous devez utiliser une sous-requête sans indiquer de valeurs de clés.--

DELETE p
FROM products p
INNER JOIN `categories` c ON c.cat_id = p.pro_cat_id
WHERE NOT EXISTS(
        SELECT od.ode_pro_id
        FROM orders_details od
        WHERE od.ode_pro_id = p.pro_id
    )
  AND c.cat_name LIKE "Tondeuses électriques";

