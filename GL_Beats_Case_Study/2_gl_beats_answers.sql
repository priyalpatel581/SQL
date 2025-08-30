/*--------------------------------------------
    SECTION-01: Data Exploration
--------------------------------------------*/

-- [1] List the total sales for each year.
SELECT 
    YEAR(invoice_date) AS YR, 
    SUM(total_price) AS Total_Sales
FROM invoice
GROUP BY YEAR(invoice_date);
-- YEAR() function to extract the year from a datatime data type.

-- [2] Check the distribution of the month wise sales for the year 2010.
SELECT 
    MONTH(invoice_date) AS MTH, 
    SUM(total_price) AS Total
FROM invoice
WHERE YEAR(invoice_date) = 2010
GROUP BY MONTH(invoice_date);

-- [3] List the full names of the customers in decreasing order of sales.
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    SUM(total_price) AS total_spent
FROM customers
LEFT JOIN invoice 
    ON customers.customer_id = invoice.customer_id
GROUP BY full_name
ORDER BY total_spent DESC;

-- [4] List all artists with their respective albums names, including artists with no albums.
SELECT 
    artist.artist_name AS Artist,
    album.title_name AS Album
FROM artist
    LEFT JOIN album ON album.artist_id = artist.artist_id;

-- [5] Display each artist along with the count of albums they have produced, including artists with no albums.
SELECT 
    artist.artist_name AS Artist, 
    COUNT(album.album_id) AS Album_Count
FROM artist
    LEFT JOIN album ON artist.artist_id = album.artist_id
GROUP BY artist.artist_name;

-- [6] Identify the total revenue for each album by summing the total prices from all invoices associated with the album.
SELECT 
    a.title_name, 
    SUM(i.unit_price * i.quantity) AS Total_Revenue
FROM invoice_items i
     INNER JOIN tracks t ON i.track_id = t.track_id
     INNER JOIN album a ON a.album_id = t.album_id
GROUP BY a.title_name;

/* -----------------------------------
    SECTION-02: Recommendations
------------------------------------*/

-- [1] What are the most popular genres in each country, ranked by the number of purchases?
SELECT 
    c.customer_country, 
    g.genre_name, 
    COUNT(ii.invoice_line_id) AS purchase_count
FROM invoice_items ii
    JOIN invoice i ON ii.invoice_id = i.invoice_id
    JOIN customers c ON i.customer_id = c.customer_id
    JOIN tracks t ON ii.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
GROUP BY 
    c.customer_country, 
    g.genre_name
ORDER BY 
    c.customer_country, 
    purchase_count DESC;

-- [2] Which artists are the most popular in each country?
SELECT 
    c.customer_country, 
    ar.artist_name, 
    COUNT(ii.invoice_line_id) AS purchase_count
FROM invoice_items ii
    JOIN invoice i ON ii.invoice_id = i.invoice_id
    JOIN customers c ON i.customer_id = c.customer_id
    JOIN tracks t ON ii.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY 
    c.customer_country, 
    ar.artist_name
ORDER BY 
    c.customer_country, 
    purchase_count DESC;
